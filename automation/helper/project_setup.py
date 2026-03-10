import json
import os
import re

import requests
import yaml

from automation.ai.ai_palette_and_i18n import generate_language_enum
from automation.helper.utils import write_file, read_file


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