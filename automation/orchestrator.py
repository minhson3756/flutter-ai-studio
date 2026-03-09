import os
import json
import shutil
import subprocess
import hashlib

import time
import yaml
import re
from dotenv import load_dotenv
import requests

from figma_extractor import get_figma_screens, find_image_nodes, download_figma_images, find_fonts, \
    extract_languages_from_figma, find_icon_nodes, download_figma_icons
from agents import generate_feature_code, analyze_global_styles, generate_language_enum, \
    generate_screen_translations, generate_global_models, fix_flutter_code_agent
from injector import inject_to_flutter, to_snake_case
from utils import read_file, write_file

load_dotenv()


def to_camel_case(snake_str):
    components = snake_str.split('_')
    return components[0] + ''.join(x.title() for x in components[1:])


def update_palette_file(app_path, new_colors_code):
    palette_path = os.path.join(app_path, "lib/src/config/theme/palette.dart")
    content = read_file(palette_path)
    if not content: content = "import 'package:flutter/material.dart';\n\nclass Palette {\n}"
    lines = []
    if isinstance(new_colors_code, dict):
        for k, v in new_colors_code.items():
            if k not in content: lines.append(f"  static const Color {k} = Color({v});")
    elif isinstance(new_colors_code, str):
        for l in new_colors_code.strip().split('\n'):
            if '=' in l and l.split('=')[0].strip() not in content: lines.append(f"  {l.strip()}")
    if lines:
        new_content = re.sub(r'}\s*$', "\n".join(lines) + "\n}", content)
        write_file(palette_path, new_content)


def get_used_assets(node, img_dict, icon_dict, used_images=None, used_icons=None):
    """Đệ quy quét chính xác 100% các hình ảnh/icon CÓ XUẤT HIỆN trong màn hình này"""
    if used_images is None: used_images = set()
    if used_icons is None: used_icons = set()

    node_id = node.get("id")
    # Khớp ID Figma để lấy tên file chính xác
    if node_id in img_dict:
        used_images.add(img_dict[node_id])
    if node_id in icon_dict:
        used_icons.add(icon_dict[node_id])

    for child in node.get("children", []):
        get_used_assets(child, img_dict, icon_dict, used_images, used_icons)

    return used_images, used_icons


def download_font(font_family, target_dir):
    """Tải font từ Google Fonts Helper với cơ chế kiểm tra lỗi"""
    font_id = font_family.lower().replace(" ", "-")
    api_url = f"https://google-webfonts-helper.herokuapp.com/api/fonts/{font_id}"

    print(f"      🔤 Đang kiểm tra font: {font_family}...")

    try:
        response = requests.get(api_url, timeout=10)
        # Kiểm tra nếu API trả về lỗi (như 404 cho SF Pro)
        if response.status_code != 200:
            print(
                f"      ⚠️ Font '{font_family}' không có trên Google Fonts. Hãy thêm thủ công vào assets/fonts.")
            return None

        res = response.json()
        variants = res.get("variants", [])
        if not variants: return None

        ttf_url = variants[0].get("ttf")
        if ttf_url:
            font_data = requests.get(ttf_url).content
            file_name = f"{font_family.replace(' ', '')}.ttf"
            file_path = os.path.join(target_dir, file_name)

            os.makedirs(target_dir, exist_ok=True)
            with open(file_path, "wb") as f:
                f.write(font_data)

            print(f"      ✅ Đã tải xong: {file_name}")
            return file_path
    except Exception as e:
        print(f"      ❌ Không thể tải {font_family}: {e}")

    return None


def update_pubspec_fonts(app_path, font_families=None):
    """
    Tự động đồng bộ các file font thực tế từ assets/fonts vào pubspec.yaml.
    Sử dụng PyYAML để đảm bảo cấu trúc file không bị hỏng.
    """
    pubspec_path = os.path.join(app_path, "pubspec.yaml")
    fonts_dir = os.path.join(app_path, "assets/fonts")

    if not os.path.exists(pubspec_path):
        print(f"      ⚠️ Cảnh báo: Không tìm thấy pubspec.yaml tại {app_path}")
        return

    # 1. Đọc nội dung pubspec.yaml hiện tại
    try:
        with open(pubspec_path, 'r', encoding='utf-8') as f:
            # Dùng safe_load để đọc file YAML thành Dictionary trong Python
            data = yaml.safe_load(f) or {}
    except Exception as e:
        print(f"      🚨 Lỗi khi đọc pubspec.yaml: {e}")
        return

    # 2. Đảm bảo cấu trúc flutter: fonts: tồn tại trong file
    if 'flutter' not in data:
        data['flutter'] = {}

    if 'fonts' not in data['flutter'] or data['flutter']['fonts'] is None:
        data['flutter']['fonts'] = []

    # 3. Quét các file font thực tế trong thư mục assets/fonts
    new_entries_added = 0
    if os.path.exists(fonts_dir):
        # Lấy danh sách các file font (ttf, otf)
        font_files = [f for f in os.listdir(fonts_dir) if f.lower().endswith(('.ttf', '.otf'))]

        for file_name in font_files:
            # Tạo tên Family từ tên file (VD: SFProText-Regular.ttf -> SFProText)
            family_name = file_name.split('-')[0].replace('.ttf', '').replace('.otf', '')

            # Kiểm tra xem font family này đã được khai báo chưa để tránh trùng lặp
            is_exists = any(f.get('family') == family_name for f in data['flutter']['fonts'])

            if not is_exists:
                # Tạo entry mới theo chuẩn pubspec của Flutter
                font_entry = {
                    'family': family_name,
                    'fonts': [
                        {'asset': f'assets/fonts/{file_name}'}
                    ]
                }
                data['flutter']['fonts'].append(font_entry)
                new_entries_added += 1
                print(f"      📦 Đã đăng ký font mới: {family_name} ({file_name})")

    # 4. Ghi lại nội dung đã cập nhật vào file pubspec.yaml
    if new_entries_added > 0:
        try:
            with open(pubspec_path, 'w', encoding='utf-8') as f:
                # Lưu file với định dạng YAML chuẩn, không sắp xếp key để giữ nguyên thứ tự cũ
                yaml.dump(data, f, default_flow_style=False, sort_keys=False, allow_unicode=True)
            print(f"   ✅ Đã cập nhật xong pubspec.yaml ({new_entries_added} font mới).")
        except Exception as e:
            print(f"      🚨 Lỗi khi ghi file pubspec.yaml: {e}")
    else:
        print("   ℹ️ Không có font mới cần khai báo.")


def update_localization(app_path, languages):
    """Tạo file arb và cập nhật enum"""
    l10n_dir = os.path.join(app_path, "assets/l10n")
    os.makedirs(l10n_dir, exist_ok=True)

    for lang in languages:
        code = lang['code']
        file_path = os.path.join(l10n_dir, f"app_{code}.arb")
        if not os.path.exists(file_path):
            # Tạo file arb trống với cấu trúc chuẩn
            write_file(file_path, '{\n  "@@locale": "' + code + '"\n}')
            print(f"      🌐 Đã tạo file ngôn ngữ: app_{code}.arb")

    # Cập nhật enum Language
    enum_path = os.path.join(app_path, "lib/src/shared/enum/language.dart")
    new_enum_code = generate_language_enum(languages)
    write_file(enum_path, new_enum_code.get("screen", ""))
    print("      ✅ Đã cập nhật enum Language.")


def get_screen_texts(node, text_set=None):
    """Đệ quy quét tất cả các text có trong một màn hình Figma cụ thể"""
    if text_set is None: text_set = set()

    if node.get("type") == "TEXT" and node.get("text"):
        # SANITIZE: Dọn dẹp ký tự xuống dòng (Enter) và Tab làm gãy JSON
        txt = node.get("text").strip()
        txt = txt.replace('\n', ' ').replace('\r', '').replace('\t', ' ')

        # Gộp nhiều khoảng trắng thừa thành 1 khoảng trắng duy nhất
        txt = re.sub(r'\s+', ' ', txt).strip()

        if txt and len(txt) > 1:  # Bỏ qua các text rỗng hoặc quá ngắn
            text_set.add(txt)

    for child in node.get("children", []):
        get_screen_texts(child, text_set)
    return text_set


def update_arb_files(app_path, translations):
    """Ghi đè hoặc thêm mới các key dịch thuật vào file .arb tương ứng"""
    l10n_dir = os.path.join(app_path, "assets/l10n")
    os.makedirs(l10n_dir, exist_ok=True)

    for lang_code, lang_data in translations.items():
        arb_path = os.path.join(l10n_dir, f"app_{lang_code}.arb")
        current_data = {"@@locale": lang_code}

        # Đọc dữ liệu cũ nếu có
        if os.path.exists(arb_path):
            try:
                with open(arb_path, 'r', encoding='utf-8') as f:
                    current_data = json.load(f)
            except:
                pass

        # Nối dữ liệu mới vào
        for k, v in lang_data.items():
            if k not in current_data:
                current_data[k] = v

        # Lưu lại file arb
        with open(arb_path, 'w', encoding='utf-8') as f:
            json.dump(current_data, f, ensure_ascii=False, indent=2)


def group_complex_screens(screens):
    """
    Gom nhóm tất cả các màn hình có chung tên gốc hoặc có dấu '/' thành 1 màn hình duy nhất.
    """
    grouped = {}
    result = []

    for s in screens:
        name = s.get("name", "").strip()

        # 1. Tìm base_name trước dấu gạch chéo hoặc theo số
        if "/" in name:
            base_name = name.split("/")[0].strip()
        elif re.match(r"^([a-zA-Z_]+)\s*\d+$", name):
            base_name = re.match(r"^([a-zA-Z_]+)\s*\d+$", name).group(1).strip()
        else:
            base_name = name

        # 2. CHÌA KHÓA GOM NHÓM (MAGIC HAPPENS HERE)
        # Loại bỏ chữ "Screen", "View" và khoảng trắng, đưa về viết thường để gộp chính xác 100%
        # VD: "LanguageScreen" và "Language / Setting" đều biến thành "language"
        base_key = base_name.replace("Screen", "").replace("View", "").replace(" ", "").lower()

        if base_key not in grouped:
            grouped[base_key] = {
                "base_name": base_name,
                "pages": []
            }
        grouped[base_key]["pages"].append(s)

    # 3. Tạo màn hình tổng hợp
    for base_key, data in grouped.items():
        pages = data["pages"]

        # Gọt sạch ký tự đặc biệt cho tên class (để tránh lỗi tạo file)
        clean_base = re.sub(r'[^a-zA-Z0-9]', '', data["base_name"])

        # Kiểm tra xem nhóm này có màn hình nào chứa dấu "/" không
        has_slash = any("/" in p.get("name", "") for p in pages)

        # Nếu có >1 màn hình, HOẶC màn hình duy nhất đó có chứa "/", ta ép nó thành Màn hình Phức tạp
        if len(pages) > 1 or has_slash:
            # 🌟 FIX: Nếu tên gốc đã cố tình đặt là Widget, TUYỆT ĐỐI không gắn đuôi Screen vào!
            if "Widget" in clean_base:
                final_name = clean_base
            else:
                final_name = f"{clean_base}Screen" if not clean_base.endswith(
                    "Screen") else clean_base

            result.append({
                "name": final_name,
                "type": "COMPLEX_SCREEN",
                "is_complex": True,
                "children": pages
            })
        else:
            result.extend(pages)

    return result


def extract_all_colors(node, color_set=None):
    """Đệ quy quét toàn bộ màu sắc và gradient độc nhất trong Figma JSON"""
    if color_set is None: color_set = set()

    if "color" in node and isinstance(node["color"], str):
        color_set.add(node["color"])
    if "gradient" in node:
        # Ép chuỗi JSON để có thể đưa vào tập hợp (Set) nhằm loại bỏ trùng lặp
        color_set.add(json.dumps(node["gradient"]))

    for child in node.get("children", []):
        extract_all_colors(child, color_set)

    return color_set


def extract_flutter_models(app_path):
    """
    Quét thư mục models để trích xuất cấu trúc Class và các biến (fields).
    Tiêm thẳng vào não AI để chống bệnh 'mất trí nhớ'.
    """
    models_dir = os.path.join(app_path, "lib", "src", "shared", "models")
    if not os.path.exists(models_dir):
        return ""

    model_context = "🚨 [KỶ LUẬT DATA MODELS TRONG HỆ THỐNG ĐANG CÓ]:\n"
    model_context += "BẠN BẮT BUỘC PHẢI DÙNG CHUNG CÁC MODEL NÀY KHI TRUYỀN DỮ LIỆU. TUYỆT ĐỐI KHÔNG TỰ BỊA RA MODEL KHÁC HOẶC TRƯỜNG KHÁC:\n\n"

    found_models = False

    for root, _, files in os.walk(models_dir):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Dùng Regex tìm tên class
                class_matches = re.finditer(r'class\s+([A-zA-Z0-9_]+)\s*(?:extends|implements|\{)',
                                            content)
                for match in class_matches:
                    class_name = match.group(1)

                    # Dùng Regex trích xuất các biến (Ví dụ: final String id; hoặc int? age;)
                    fields = re.findall(r'(?:final\s+)?([a-zA-Z0-9_<>]+[?]?)\s+([a-zA-Z0-9_]+)\s*;',
                                        content)

                    if fields:
                        found_models = True
                        fields_str = ", ".join([f"{t} {n}" for t, n in fields])
                        model_context += f"  - class {class_name} {{ {fields_str} }}\n"
                        model_context += f"    (Sử dụng import: import 'package:flutter_base/src/shared/models/{file}';)\n"
                        # 🌟 THÊM DÒNG KỶ LUẬT THÉP NÀY VÀO ĐÂY:
                        model_context += f"    🚨 CẤM TRUYỀN THAM SỐ LẠ: Tuyệt đối không khởi tạo Model với các tham số không có mặt trong danh sách trên. NẾU CÓ DỮ LIỆU PHỨC TẠP (như mật khẩu wifi, tọa độ, v.v.), BẮT BUỘC phải dùng `jsonEncode` để biến chúng thành chuỗi JSON String và lưu vào trường `rawData`. KHÔNG ĐƯỢC BỊA THÊM TRƯỜNG!\n\n"

    if found_models:
        return model_context
    return ""

def extract_generated_constructors(app_path):
    """
    Quét liên tục thư mục presentation. Cứ file nào gen xong,
    bóc ngay Constructor của nó ra để dạy cho Màn hình sau cách gọi cho đúng!
    """
    presentation_dir = os.path.join(app_path, "lib", "src", "presentation")
    if not os.path.exists(presentation_dir):
        return ""

    context_str = "🚨 [HỢP ĐỒNG CONSTRUCTOR CỦA CÁC WIDGET/SCREEN ĐÃ ĐƯỢC GEN TỪ TRƯỚC]:\n"
    context_str += "Khi bạn điều hướng (PushRoute) hoặc nhúng Widget con, BẮT BUỘC PHẢI TRUYỀN ĐÚNG CÁC THAM SỐ DƯỚI ĐÂY:\n\n"

    found = False
    for root, _, files in os.walk(presentation_dir):
        for file in files:
            if file.endswith(".dart") and ("_screen" in file or "_widget" in file):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Regex tìm chính xác Tên Class và Constructor của nó
                match = re.search(r'class\s+([A-zA-Z0-9_]+).*?(const\s+\1\s*\(\s*\{[^}]*\}\s*\);?)', content, re.DOTALL)
                if match:
                    # Gọt sạch dấu xuống dòng để Prompt gọn gàng
                    clean_constructor = re.sub(r'\s+', ' ', match.group(2))
                    context_str += f"  - `{clean_constructor}`\n"
                    found = True

    return context_str if found else ""
def main():
    # 0. Cấu hình môi trường và đường dẫn
    app_name = os.environ.get("APP_NAME", "TestApp")
    figma_key = os.environ.get("FIGMA_KEY")
    current_dir = os.path.dirname(os.path.abspath(__file__))
    new_app_path = os.path.normpath(os.path.join(current_dir, f"../apps/{app_name}"))
    base_project_path = os.path.normpath(os.path.join(current_dir, "../base_flutter_project"))

    # 1. KHỞI TẠO PROJECT: Copy từ Base
    print(f"1. Đang chuẩn bị App: {app_name}...")
    if not os.path.exists(new_app_path):
        print(f"   -> 📂 Đang sao chép mã nguồn cơ bản từ Base Project...")
        shutil.copytree(base_project_path, new_app_path,
                        ignore=shutil.ignore_patterns('.git', 'build'))
    else:
        print("   -> ✅ Thư mục App đã tồn tại.")

    # 2. KHỞI TẠO BỘ NHỚ ĐÊM (GLOBAL CACHE)
    cache_path = os.path.join(new_app_path, ".ai_build_cache.json")
    build_cache = {}
    if os.path.exists(cache_path):
        try:
            with open(cache_path, "r", encoding="utf-8") as f:
                build_cache = json.load(f)
        except:
            pass

    # 3. BÓC TÁCH DỮ LIỆU FIGMA
    print("3. Đang bóc tách dữ liệu từ Figma...")
    figma_data = get_figma_screens(figma_key)
    rules_content = read_file(os.path.join(current_dir, "prompts/ai_architecture_rules.md"))
    spec_content = read_file(os.path.join(current_dir, "app_spec"))

    # 4. TỰ ĐỘNG HÓA LOCALIZATION (l10n & Enum Language)
    print("4. Đang xử lý đa ngôn ngữ (Localization)...")
    detected_languages = extract_languages_from_figma(figma_data)
    update_localization(new_app_path, detected_languages)

    # 5. XỬ LÝ TÀI NGUYÊN (HÌNH ẢNH PNG VÀ ICON SVG)
    print("5. Đang quét và tải Hình ảnh & Icon...")
    image_nodes = find_image_nodes(figma_data)
    images_dir = os.path.join(new_app_path, "assets/images")
    downloaded_images = download_figma_images(figma_key, image_nodes, images_dir)
    # 🌟 Thêm dòng in Log thống kê cho đẹp
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_images)} hình ảnh.")

    icon_nodes = find_icon_nodes(figma_data)
    icons_dir = os.path.join(new_app_path, "assets/icons")
    downloaded_icons = download_figma_icons(figma_key, icon_nodes, icons_dir)
    # 🌟 Thêm dòng in Log thống kê
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_icons)} icons.")

    # 6. XỬ LÝ FONT CHỮ
    print("6. Đang xử lý Font chữ...")
    font_families = find_fonts(figma_data)
    fonts_dir = os.path.join(new_app_path, "assets/fonts")
    for family in font_families:
        download_font(family, fonts_dir)
    update_pubspec_fonts(new_app_path)

    # 7. ĐỒNG BỘ TÀI NGUYÊN
    print("7. Đang chạy flutter pub get...")
    subprocess.run(["flutter", "pub", "get"], cwd=new_app_path)

    # 🌟 BỘ LỌC TÀI NGUYÊN (ASSET FILTERING): Tạo từ điển tra cứu nhanh
    img_dict = {n_id: f_name for n_id, f_name in image_nodes}
    icon_dict = {n_id: r_path for n_id, r_path in icon_nodes}

    # 8. CẬP NHẬT PALETTE (Bao gồm Gradient)
    print("8. Đang cập nhật Palette và thiết kế màu sắc...")
    unique_colors = list(extract_all_colors(figma_data))

    # 🌟 CACHE MÀU SẮC
    colors_hash = hashlib.md5(json.dumps(unique_colors, sort_keys=True).encode('utf-8')).hexdigest()

    if build_cache.get("global_colors_hash") == colors_hash and "palette_code" in build_cache:
        print("      ⚡ [CACHE HIT] Không có màu mới, bỏ qua gọi AI sinh Palette!")
        palette_updates = build_cache["palette_code"]
    else:
        styles = analyze_global_styles(json.dumps(unique_colors))
        palette_updates = styles.get("palette_updates", "")

        # Lưu cache
        build_cache["global_colors_hash"] = colors_hash
        build_cache["palette_code"] = palette_updates
        with open(cache_path, "w", encoding="utf-8") as f:
            json.dump(build_cache, f, ensure_ascii=False, indent=2)

    update_palette_file(new_app_path, palette_updates)

    # 9. CHUẨN BỊ ROUTE VÀ GỘP NHÓM MÀN HÌNH
    raw_screens = figma_data.get("children", [])
    if not isinstance(raw_screens, list): raw_screens = [raw_screens]

    # Sử dụng hàm gom nhóm phức tạp
    grouped_screens = group_complex_screens(raw_screens)

    # 🌟 CHIẾN THUẬT CHIA ĐỂ TRỊ (COMPONENT SPLITTING - TỐI ƯU WIDGETS) 🌟
    final_screens = []
    for s in grouped_screens:
        if s.get("is_complex") and s.get("children"):
            sub_imports = []
            sub_classes = []

            # Lấy tên feature của màn hình cha để dùng làm thư mục gốc
            parent_name_clean = re.sub(r'[^a-zA-Z0-9]', '', s.get("name", "Unknown"))
            parent_feature = parent_name_clean.replace("View", "").replace("Screen", "").strip()

            for child in s["children"]:
                # Làm sạch tên Sub-Tab và gắn đuôi Widget
                c_name = re.sub(r'[^a-zA-Z0-9]', '', child.get("name", "Unknown").replace(" ", ""))
                c_feature = c_name.replace("View", "").replace("Screen", "").replace("Widget",
                                                                                     "").strip()
                c_snake = to_snake_case(c_feature)
                c_class = f"{c_feature}Widget"  # Đổi hậu tố thành Widget

                # Import path trỏ vào folder widgets của màn hình cha
                sub_imports.append(f"import 'widgets/{c_snake}_widget.dart';")
                sub_classes.append(c_class)

                # Biến Frame con thành một Widget độc lập
                child_screen = dict(child)
                child_screen["name"] = c_class
                child_screen["is_sub_tab"] = True
                child_screen[
                    "parent_name"] = parent_feature  # Gắn thẻ parent để injector biết đường lưu
                final_screens.append(child_screen)

            s["sub_imports"] = "\n".join(sub_imports)
            s["sub_classes"] = ", ".join(sub_classes)
            final_screens.insert(0, s)
        else:
            final_screens.append(s)

    # Lọc trùng lặp và tự động nhận diện Widget cấp cao
    screens = []
    seen = set()
    for s in final_screens:
        raw_s_name = s.get("name", "Unknown")
        if raw_s_name not in seen:
            # 🌟 AUTO-DETECT WIDGET DÙ ĐỂ NGOÀI CÙNG TRÊN FIGMA
            if "Widget" in raw_s_name and not s.get("is_sub_tab"):
                s["is_sub_tab"] = True
                # Tự suy luận tên Parent từ tên Widget (VD: HomeHistoryWidget -> Home)
                if raw_s_name.startswith("Home"):
                    s["parent_name"] = "Home"
                elif raw_s_name.startswith("Scan"):
                    s["parent_name"] = "Scan"
                else:
                    # Fallback: Lấy chữ viết hoa đầu tiên làm thư mục cha
                    match = re.search(r'^([A-Z][a-z]+)', raw_s_name)
                    s["parent_name"] = match.group(1) if match else "shared"

            screens.append(s)
            seen.add(raw_s_name)

    # 🌟 CHỈ TẠO ROUTE CHO CÁC MÀN HÌNH CHÍNH (BỎ QUA WIDGET)
    top_level_screens = [s for s in screens if not s.get("is_sub_tab")]
    route_list = ", ".join(
        [f"{s.get('name', '').replace('View', '').replace('Screen', '').strip()}Route()" for s in
         top_level_screens])
    lang_codes = [l['code'] for l in detected_languages]

    # 🌟 9.5 DỊCH THUẬT TOÀN CỤC (GLOBAL TRANSLATION - BATCHING AN TOÀN) 🌟
    print("\n🌍 Đang trích xuất và dịch toàn bộ text trong App...")
    all_app_texts = set()
    for s in screens:
        get_screen_texts(s, all_app_texts)

    global_keys_mapping = {}
    translations_merged = {}

    if all_app_texts:
        text_list = list(all_app_texts)
        text_list.sort()  # Sắp xếp để đảm bảo mã băm không bị đổi ngẫu nhiên
        texts_hash = hashlib.md5(json.dumps(text_list).encode('utf-8')).hexdigest()

        # 🌟 CACHE DỊCH THUẬT
        if build_cache.get("global_texts_hash") == texts_hash and "translations" in build_cache:
            print("      ⚡ [CACHE HIT] Không có text mới, bỏ qua gọi AI dịch thuật!")
            global_keys_mapping = build_cache["translations"]["keys_mapping"]
            translations_merged = build_cache["translations"]["merged"]
            if translations_merged:
                update_arb_files(new_app_path, translations_merged)
        else:
            batch_size = 10
            total_batches = (len(text_list) - 1) // batch_size + 1

            for i in range(0, len(text_list), batch_size):
                batch = text_list[i:i + batch_size]
                print(
                    f"      🔄 Đang dịch batch {i // batch_size + 1}/{total_batches} ({len(batch)} texts)...")
                try:
                    trans_result = generate_screen_translations(batch, lang_codes)
                    global_keys_mapping.update(trans_result.get("keys_mapping", {}))
                    for lang_code, lang_data in trans_result.get("translations", {}).items():
                        if lang_code not in translations_merged:
                            translations_merged[lang_code] = {}
                        translations_merged[lang_code].update(lang_data)
                except Exception as e:
                    print(f"      ⚠️ Lỗi dịch: {e}")

            if translations_merged:
                update_arb_files(new_app_path, translations_merged)

            # Lưu cache sau khi dịch xong
            build_cache["global_texts_hash"] = texts_hash
            build_cache["translations"] = {"keys_mapping": global_keys_mapping,
                                           "merged": translations_merged}
            with open(cache_path, "w", encoding="utf-8") as f:
                json.dump(build_cache, f, ensure_ascii=False, indent=2)

        print(f"   ✅ Đã tạo/cập nhật {len(global_keys_mapping)} keys dịch thuật cho toàn App.")
    # 9.7 🧠 AI ARCHITECT TỰ ĐỘNG SUY LUẬN VÀ TẠO MODEL
    models_dir = os.path.join(new_app_path, "lib", "src", "shared", "models")
    os.makedirs(models_dir, exist_ok=True)
    global_models_file = os.path.join(models_dir, "app_models.dart")

    # Nếu file model chưa có, gọi AI Architect tự động thiết kế
    if not os.path.exists(global_models_file):
        print("\n🧠 AI Architect đang tự suy luận và thiết kế Data Models từ Figma...")
        screen_names = [s.get("name") for s in screens]
        models_code = generate_global_models(spec_content, str(screen_names))

        if models_code:
            with open(global_models_file, "w", encoding="utf-8") as f:
                f.write(models_code)
            print("   ✅ Đã tự động tạo xong file: shared/models/app_models.dart")

    # 9.8 ĐỌC CẤU TRÚC MODEL ĐỘNG (AST PARSING)
    print("\n🔍 Đang quyét Data Models để nạp vào bộ nhớ AI UI...")
    dynamic_models_context = extract_flutter_models(new_app_path)
    if dynamic_models_context:
        print("   ✅ Đã nạp thành công các Data Models vào bộ nhớ chung.")

    # 🌟 THUẬT TOÁN BOTTOM-UP: SẮP XẾP THỨ TỰ GEN HỢP LÝ NHẤT
    def get_sort_priority(screen_node):
        name = screen_node.get("name", "").lower()
        if screen_node.get("is_sub_tab"):
            return 0  # Priority 0: Widget con LUÔN LUÔN gen đầu tiên
        if any(kw in name for kw in ["complete", "result", "detail", "history", "view"]):
            return 1  # Priority 1: Màn hình đích (thường được điều hướng tới)
        if any(kw in name for kw in ["home", "main", "splash", "root", "nav"]):
            return 3  # Priority 3: Màn hình gốc (chứa TabBar, thường gọi màn khác) gen cuối
        return 2      # Priority 2: Các màn hình thông thường

    screens.sort(key=get_sort_priority)

    # 10. VÒNG LẶP SẢN XUẤT MÀN HÌNH
    print(f"\n🚀 BẮT ĐẦU GEN {len(screens)} MÀN HÌNH THEO SPEC...")
    palette_code = read_file(os.path.join(new_app_path, "lib/src/config/theme/palette.dart"))

    for i, screen_node in enumerate(screens):
        raw_name = screen_node.get("name", "Unknown")
        raw_name = re.sub(r'[^a-zA-Z0-9]', '', raw_name)
        feature_name = raw_name.replace("View", "").replace("Screen", "").strip()
        snake_name = to_snake_case(feature_name)

        print(f"\n   ⚙️ [{i + 1}/{len(screens)}] Đang xử lý: {raw_name}...")

        # 🌟 MD5 CACHING: Tạo mã băm (Fingerprint) bảo vệ
        screen_fingerprint = json.dumps(screen_node, sort_keys=True) + rules_content + spec_content
        screen_hash = hashlib.md5(screen_fingerprint.encode('utf-8')).hexdigest()

        if build_cache.get(raw_name) == screen_hash:
            print(f"      ⚡ [CACHE HIT] Màn hình không đổi, bỏ qua gọi AI để tiết kiệm Token!")
            continue

        # 🌟 CẮT TỈA CONTEXT ASSETS CỰC MẠNH: Chỉ đưa cho AI những ảnh nó thực sự cần
        used_imgs, used_icns = get_used_assets(screen_node, img_dict, icon_dict)

        asset_instructions = "QUY TẮC DÙNG ẢNH VÀ ICON (CHỈ DÙNG CÁC ASSETS DƯỚI ĐÂY):\n"
        if not used_imgs and not used_icns:
            asset_instructions += "- Màn hình này không sử dụng ảnh/icon nào từ Figma.\n"
        else:
            for img in used_imgs:
                var_name = to_camel_case(img)
                asset_instructions += f"- File ảnh {img}.png -> Assets.images.{var_name}.image(fit: BoxFit.cover)\n"
            for icn in used_icns:
                gen_path = ".".join([to_camel_case(p) for p in icn.split('/')])
                asset_instructions += f"- File icon {icn}.svg -> Assets.icons.{gen_path}.svg()\n"

        # --- BƯỚC 1: LỌC TỪ ĐIỂN CHO MÀN HÌNH NÀY ---
        screen_texts = list(get_screen_texts(screen_node))
        l10n_instructions = """
        QUY TẮC ĐA NGÔN NGỮ (BẮT BUỘC):
        1. Thay thế các text gốc bằng context.l10n.<camelCaseKey> dựa trên từ điển sau:
        """
        for orig in screen_texts:
            key = global_keys_mapping.get(orig)
            if key:
                l10n_instructions += f"           - '{orig}' -> context.l10n.{key}\n"

        # --- BƯỚC 2: XỬ LÝ LOGIC DỰA TRÊN CẤU TRÚC (COMPONENT SPLITTING) ---
        special_logic_instructions = ""

        if screen_node.get("is_complex"):
            sub_imports = screen_node.get("sub_imports", "")
            sub_classes = screen_node.get("sub_classes", "")
            special_logic_instructions += f"""
        [KỶ LUẬT LỚP VỎ PARENT (SHELL ARCHITECTURE)]:
        - Đây là màn hình gốc, chứa Thanh Điều Hướng hoặc Container.
        - Hệ thống ĐÃ TẠO SẴN các màn hình con. Import và dùng chúng:
        {sub_imports}
        - Sử dụng class: `{sub_classes}`.
        - 🚨 KỶ LUẬT GIAO TIẾP (CHỐNG LỆCH THAM SỐ): Khi gọi các Widget con này, TUYỆT ĐỐI KHÔNG truyền các biến lẻ tẻ (như title, qrType, parsedFields). BẮT BUỘC chỉ truyền DUY NHẤT 1 tham số chứa dữ liệu gốc (Ví dụ: `scannedData: data` hoặc `model: historyItem`). 
            """
        elif screen_node.get("is_sub_tab"):
            parent = screen_node.get("parent_name")
            special_logic_instructions += f"""
        [KỶ LUẬT TAB CON (INDEPENDENT WIDGET)]:
        - Đây là Component con nằm trong `widgets` của màn hình `{parent}`.
        - TÊN CLASS BẮT BUỘC: `{raw_name}`
        - 🚨 KỶ LUẬT CONSTRUCTOR (CHỐNG LỆCH THAM SỐ VỚI MÀN HÌNH CHA): 
          Bắt buộc định nghĩa Constructor cực kỳ tối giản. CHỈ NHẬN DUY NHẤT 1 tham số chứa dữ liệu gốc từ màn hình cha truyền xuống (Ví dụ: `final String scannedData;` hoặc `final HistoryItemModel model;`). TUYỆT ĐỐI KHÔNG bắt màn hình cha truyền các biến UI lẻ tẻ (như isSelected, title, iconType...). Tự xử lý logic UI bên trong Widget này!
        - KHÔNG ĐƯỢC THÊM `@RoutePage()` VÀO FILE NÀY (Vì nó chỉ là Widget, không phải Route).
        - KHÔNG tạo `Scaffold` chứa `AppBar` hay `BottomNavigationBar` (vì màn hình mẹ đã có). 
        - Chỉ cần return một `Widget` (như Column, Container, ListView) chứa nội dung.
        - TRỌNG TÂM: Bạn có nguyên 8192 Token để viết logic và UI HOÀN HẢO 100% cho Widget này. TUYỆT ĐỐI KHÔNG DÙNG TODO.
            """

        elif screen_node.get("is_page_view"):
            special_logic_instructions += """
        [KỶ LUẬT PAGEVIEW]: Dùng `PageView` và tự thiết kế Data Model cho mảng dữ liệu tĩnh.
            """

        enum_file_path = os.path.join(new_app_path, "lib/src/shared/enum/language.dart")
        language_enum_code = read_file(enum_file_path) if os.path.exists(enum_file_path) else ""

        special_logic_instructions += f"""
        [KỶ LUẬT SỬ DỤNG TÀI NGUYÊN DÙNG CHUNG (SHARED RESOURCES)]:
        Dưới đây là các tài nguyên ĐÃ CÓ SẴN ở tầng Global của ứng dụng:
        1. `LanguageCubit` (import 'package:flutter_base/src/shared/cubit/language_cubit.dart')
        2. `Language` Enum: 
        {language_enum_code}
        
        NẾU MÀN HÌNH BẠN ĐANG XỬ LÝ có chức năng thay đổi ngôn ngữ: 
        -> TUYỆT ĐỐI KHÔNG tạo Cubit mới. 
        -> BẮT BUỘC sử dụng `LanguageCubit` và `Language` enum trên để render UI.
        """

        dynamic_constructors = extract_generated_constructors(new_app_path)

        ctx = f"""
        YÊU CẦU NGHIỆP VỤ (BẮT BUỘC TUÂN THỦ):
        {spec_content}

        {dynamic_models_context}
        {dynamic_constructors}

        {asset_instructions}
        {l10n_instructions}
        {special_logic_instructions}
        
        DANH SÁCH ROUTE HỢP LỆ: {route_list}
        
        [KỶ LUẬT TƯ DUY - CHAIN OF THOUGHT]:
        - TRƯỚC KHI output code, BẮT BUỘC phải viết luồng suy nghĩ vào thẻ `<plan>...</plan>`. 
        - Trong thẻ `<plan>`, hãy phân tích: Bạn sẽ dùng Model nào? Cần gọi tham số gì từ Constructor? Logic UI ra sao? 
        - Suy nghĩ xong mới được xuất khối code ```dart.
        
        KỶ LUẬT TÊN CLASS & IMPORT:
        1. TÊN CLASS: `{raw_name}` (Giữ nguyên gốc).
        2. IMPORT GLOBAL:
           import 'package:flutter_base/src/config/theme/palette.dart';
           import 'package:flutter_base/src/gen/assets.gen.dart';
           import 'package:flutter_base/src/shared/extension/context_extension.dart';
           import 'package:flutter_screenutil/flutter_screenutil.dart';
           import 'package:auto_route/auto_route.dart';
        3. KỶ LUẬT CUBIT & STATE (QUAN TRỌNG):
           - Từ Screen/Widget gọi Cubit: BẮT BUỘC dùng `import 'cubit/{snake_name}_cubit.dart';`
           - TỪ TRONG FILE CUBIT gọi State: BẮT BUỘC dùng đúng tên `import '{snake_name}_state.dart';` (Tuyệt đối không gõ thiếu chữ).
           - TÊN CLASS: Bắt buộc là `{feature_name}Cubit` và `{feature_name}State`.
        
        KỶ LUẬT UI/UX AGNOSTIC (CHỐNG ẢO GIÁC):
        1. SCREENUTIL: Mọi kích thước phải dùng hậu tố (100.w, 16.sp, 8.r).
        2. TÔN TRỌNG GIAO DIỆN JSON: Không tự đẻ thêm Nút bấm, Layout nếu JSON không có.
        3. LINH HOẠT THEO THIẾT KẾ:
           - Tự động dùng `BoxDecoration` nếu JSON có border, shadow, radius.
           - Tự động dùng `Stack` làm nền nếu JSON có layout đè lên nhau.
        4. 🚨 CẤM MOCK DATA (CỰC KỲ QUAN TRỌNG): 
           - TUYỆT ĐỐI KHÔNG hardcode các text giả (dummy text) từ Figma (ví dụ: "OfficeWifi", "10:52:00"). 
           - BẮT BUỘC phải map dữ liệu động (bind data) từ State, Cubit hoặc Data Model vào UI. 
           - Nếu hiển thị danh sách, BẮT BUỘC dùng `ListView.builder` và truyền dữ liệu thực từ mảng vào item.
        
        Palette hiện tại: {palette_code}
        """

        print(f"      ✍️  Đang gen code Flutter (Kèm phân tích logic)...")
        code = generate_feature_code(raw_name, json.dumps(screen_node), ctx, rules_content)

        # 🌟 TỰ ĐỘNG CÀI ĐẶT THƯ VIỆN AI YÊU CẦU (BỘ LỌC THÔNG MINH)
        packages_data = code.get("packages", [])
        raw_pkg_list = []

        if isinstance(packages_data, list):
            raw_pkg_list = [str(p).strip() for p in packages_data if str(p).strip()]
        elif isinstance(packages_data, str) and packages_data.strip():
            raw_pkg_list = [p.strip() for p in packages_data.split('\n') if p.strip()]

        raw_pkg_list = [p for p in raw_pkg_list if not p.startswith('//')]

        if raw_pkg_list:
            pkg_set = set()
            for p in raw_pkg_list:
                # Nếu AI trả về import 'package:hive/hive.dart'
                if 'package:' in p:
                    match = re.search(r'package:([^/]+)', p)
                    if match:
                        pkg_set.add(match.group(1).strip("';\" "))
                else:
                    # NẾU AI TRẢ VỀ: "hive: ^2.0.0" -> Cắt lấy chữ "hive"
                    clean_p = p.split(':')[0].strip().replace("'", "").replace('"', "")

                    # 🌟 FIX: Đổi 'a-zA-Z' thành 'a-z' (Chỉ cho phép chữ thường).
                    # Việc này sẽ CHẶN ĐỨNG mọi từ camelCase như onTap, mainAxisSize...
                    if re.match(r'^[a-z0-9_-]+$', clean_p):
                        pkg_set.add(clean_p)

            # 🌟 FIX: Bổ sung các từ khóa của cấu trúc pubspec.yaml vào "Sổ đen"
            ignore_pkgs = {
                'flutter', 'flutter_base', 'flutter_screenutil', 'google_fonts',
                'flutter_bloc', 'auto_route', 'dart', 'flutter_localizations',
                'shared_preferences_android', 'shared_preferences_ios',
                'dependencies', 'dev_dependencies', 'environment', 'name',
                'description', 'version', 'homepage', 'dependency_overrides', 'sdk'
            }
            final_pkgs = [pkg for pkg in pkg_set if pkg not in ignore_pkgs]

            for pkg in final_pkgs:
                print(f"      📦 Đang tự động cài đặt thư viện: {pkg}...")
                try:
                    # GỠ BỎ DEVNULL ĐỂ NHÌN THẤY LỖI NẾU FLUTTER PUB BỊ CRASH
                    subprocess.run(["flutter", "pub", "add", pkg], cwd=new_app_path, timeout=45)
                except Exception as e:
                    print(f"      ⚠️ Lỗi khi cài {pkg}: {e}")

        is_sub = screen_node.get("is_sub_tab", False)
        parent_name = screen_node.get("parent_name")

        # Tuyệt đối phải có is_sub_tab=is_sub và parent_name=parent_name ở đây!
        inject_to_flutter(new_app_path, feature_name, code, is_sub_tab=is_sub,
                          parent_name=parent_name)
        # ==========================================================
        # 🌟 VÒNG LẶP TỰ CHỮA LÀNH (SELF-HEALING) 🌟
        # ==========================================================
        # 1. Xác định đường dẫn file vừa gen xong để kiểm tra lỗi
        if is_sub:
            parent_snake = to_snake_case(parent_name) if parent_name else "shared"
            file_suffix = ".dart" if snake_name.endswith("_widget") else "_widget.dart"
            target_file_path = os.path.join(new_app_path, "lib", "src", "presentation", parent_snake, "widgets", f"{snake_name}{file_suffix}")
        else:
            file_suffix = ".dart" if snake_name.endswith("_screen") else "_screen.dart"
            target_file_path = os.path.join(new_app_path, "lib", "src", "presentation", snake_name, f"{snake_name}{file_suffix}")

        # 2. Cho AI tối đa 2 cơ hội để tự sửa lỗi
        max_retries = 2
        for attempt in range(max_retries):
            print(f"      🩺 Đang kiểm tra lỗi cú pháp (Lần {attempt + 1})...")
            # Chạy analyzer của Flutter cho MỘT file duy nhất này để tiết kiệm thời gian
            result = subprocess.run(["flutter", "analyze", target_file_path], cwd=new_app_path, capture_output=True, text=True)

            # Nếu terminal trả về "No issues found" hoặc code trả về 0 -> Code sạch!
            if "No issues found!" in result.stdout or result.returncode == 0:
                print("      ✅ Tuyệt vời! Code sạch, không có lỗi cú pháp.")
                break
            else:
                print(f"      ⚠️ Phát hiện lỗi! Đang gọi Bác sĩ AI (Fixer) tự động vá lỗi...")
                error_log = result.stdout + "\n" + result.stderr

                # Đọc file code bị lỗi
                with open(target_file_path, "r", encoding="utf-8") as f:
                    buggy_code = f.read()

                # Gọi Bác sĩ AI
                fixed_code = fix_flutter_code_agent(buggy_code, error_log)

                # Ghi đè code đã sửa vào file
                if fixed_code:
                    with open(target_file_path, "w", encoding="utf-8") as f:
                        f.write(fixed_code)
                    print("      💉 Đã tiêm code mới. Sẽ kiểm tra lại ở vòng lặp tiếp theo.")
                else:
                    print("      ❌ Bác sĩ AI bó tay, bỏ qua file này.")
                    break
        # ==========================================================
        # 🌟 LƯU CACHE SAU KHI THÀNH CÔNG
        build_cache[raw_name] = screen_hash
        with open(cache_path, "w", encoding="utf-8") as f:
            json.dump(build_cache, f, ensure_ascii=False, indent=2)

        if i < len(screens) - 1:
            print(f"      ⏸️ Đang nghỉ 8 giây để dàn đều Token...")
            time.sleep(8)

    # 11. HOÀN THIỆN: Chạy build_runner và l10n
    print("\n🛠️ Đang chạy build_runner hoàn thiện project...")
    subprocess.run(
        ["flutter", "pub", "run", "build_runner", "build", "--delete-conflicting-outputs"],
        cwd=new_app_path)

    print("🌐 Đang biên dịch các file ngôn ngữ (gen-l10n)...")
    subprocess.run(["flutter", "gen-l10n"], cwd=new_app_path)

    print(f"\n🎉 THÀNH CÔNG! App của bạn đã sẵn sàng tại: {new_app_path}")


if __name__ == "__main__":
    main()
