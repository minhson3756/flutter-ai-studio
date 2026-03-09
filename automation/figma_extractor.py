import os
import re
from asyncio import as_completed
from concurrent.futures import ThreadPoolExecutor

import requests
import time
import json  # BỔ SUNG THƯ VIỆN NÀY
from dotenv import load_dotenv

load_dotenv()

def extract_color(fills):
    """Trích xuất mã màu Hex hoặc cấu trúc Gradient từ mảng fills của Figma"""
    if not fills or not isinstance(fills, list): return None

    for fill in fills:
        if not fill.get("visible", True): continue

        fill_type = fill.get("type")

        # 1. Xử lý màu đơn (SOLID)
        if fill_type == "SOLID":
            color = fill.get("color", {})
            r, g, b = int(color.get("r", 0) * 255), int(color.get("g", 0) * 255), int(color.get("b", 0) * 255)
            return f"#{r:02x}{g:02x}{b:02x}".upper()

        # 2. Xử lý màu Gradient (LINEAR/RADIAL)
        elif fill_type in ["GRADIENT_LINEAR", "GRADIENT_RADIAL"]:
            stops = []
            for stop in fill.get("gradientStops", []):
                c = stop.get("color", {})
                r, g, b = int(c.get("r", 0) * 255), int(c.get("g", 0) * 255), int(c.get("b", 0) * 255)
                a = round(c.get("a", 1.0), 2)
                stops.append({
                    "color": f"#{r:02x}{g:02x}{b:02x}".upper(),
                    "opacity": a,
                    "position": round(stop.get("position", 0), 2)
                })
            return {
                "type": fill_type,
                "stops": stops
            }
    return None

def simplify_node(node):
    """Bóc tách dữ liệu Figma thành JSON rút gọn cho AI"""
    name = node.get("name", "Unnamed")

    simplified = {
        "id": node.get("id"), # GIỮ ID ĐỂ TẢI ASSETS
        "name": name,
        "type": node.get("type", "UNKNOWN"),
        "visible": node.get("visible", True)
    }

    # 1. Lấy Tọa độ và Kích thước (Layout)
    bbox = node.get("absoluteBoundingBox") or node.get("absoluteRenderBounds")
    if bbox:
        simplified["layout"] = {
            "x": round(bbox.get("x", 0), 1),
            "y": round(bbox.get("y", 0), 1),
            "width": round(bbox.get("width", 0), 1),
            "height": round(bbox.get("height", 0), 1)
        }

    # 2. Xử lý Màu sắc và Gradient
    fill_data = extract_color(node.get("fills"))
    if fill_data:
        if isinstance(fill_data, str):
            simplified["color"] = fill_data
        else:
            simplified["gradient"] = fill_data # Cung cấp gradient thô cho AI

    # 3. Chi tiết cho TEXT
    if node.get("type") == "TEXT":
        simplified["text"] = node.get("characters", "")
        style = node.get("style", {})
        simplified["typography"] = {
            "fontSize": style.get("fontSize"),
            "fontWeight": style.get("fontWeight"),
            "fontFamily": style.get("fontFamily"),
            "textAlign": style.get("textAlignHorizontal")
        }

    # 4. XỬ LÝ TAG ĐẶC BIỆT
    # [Image]: Dừng đệ quy tại đây, không bóc con cái
    if "[Image]" in name or "[Icon]" in name:
        return simplified

        # [List]: Đánh dấu để AI dùng ListView.builder
    if "[List]" in name:
        simplified["is_list"] = True

    # 5. Đệ quy bóc tách con cái
    children = node.get("children", [])
    if children:
        simplified_children = []
        for child in children:
            if child.get("visible", True) is False: continue
            simplified_children.append(simplify_node(child))
        if simplified_children:
            simplified["children"] = simplified_children

    return simplified

def get_figma_screens(file_key):
    token = os.environ.get("FIGMA_TOKEN")

    if not token or token.startswith("figd_..."):
        raise ValueError("🚨 Lỗi: FIGMA_TOKEN chưa được cài đặt đúng trong file .env!")

    # 1. KIỂM TRA CACHE TRƯỚC KHI GỌI MẠNG
    cache_file = os.path.join(os.path.dirname(__file__), f".cache_figma_{file_key}.json")
    if os.path.exists(cache_file):
        print(f"   -> 📦 [CACHE HIT] Đang dùng dữ liệu lưu tạm ...")
        with open(cache_file, "r", encoding="utf-8") as f:
            return json.load(f)

    headers = {"X-Figma-Token": token}
    url = f"https://api.figma.com/v1/files/{file_key}?depth=10"

    print(f"   -> 🌐 Đang kết nối với máy chủ Figma (File Key: {file_key})...")

    max_retries = 3
    for attempt in range(max_retries):
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            data = response.json()
            document = data.get("document", {})
            pages = document.get("children", [])

            if not pages:
                raise Exception("🚨 Lỗi: File Figma trống hoặc không có Page nào.")

            first_page = pages[0]
            print(f"   -> Đã tải xong data. Đang bóc tách giao diện...")

            # Xử lý dữ liệu
            simplified_data = simplify_node(first_page)

            # 2. LƯU LẠI CACHE CHO LẦN SAU DÙNG
            with open(cache_file, "w", encoding="utf-8") as f:
                json.dump(simplified_data, f, ensure_ascii=False, indent=2)

            return simplified_data

        elif response.status_code == 429:
            wait_time = 10 * (attempt + 1)
            print(f"   ⚠️ Figma báo quá tải (429). Đang đợi {wait_time}s... (Lần {attempt + 1}/{max_retries})")
            time.sleep(wait_time)

        else:
            raise Exception(f"🚨 Figma API Error {response.status_code}: {response.text}")

    raise Exception("🚨 FATAL ERROR: Bị Figma chặn (429).")

def find_image_nodes(node, found_list=None):
    """Tìm node [Image] - Xử lý cả dấu / và dấu :"""
    if found_list is None: found_list = []

    name = node.get("name", "")
    node_id = node.get("id")

    if "[Image]" in name and node_id:
        # Lấy phần tên sau dấu / hoặc :
        clean_name = name.split('/')[-1].split(':')[-1].replace("[Image]", "").strip()
        # Chuyển sang snake_case (VD: SplashBackgroud -> splash_backgroud)
        file_name = re.sub(r'(?<!^)(?=[A-Z])', '_', clean_name).lower()
        found_list.append((str(node_id), file_name))

    for child in node.get("children", []):
        find_image_nodes(child, found_list)
    return found_list

def download_figma_images(file_key, image_nodes, target_dir):
    """Tải ảnh PNG, tự động khử trùng lặp và dùng Đa luồng (Multi-threading)"""
    token = os.environ.get("FIGMA_TOKEN")
    headers = {"X-Figma-Token": token}

    if not image_nodes: return []
    os.makedirs(target_dir, exist_ok=True)

    # 1. Khử trùng lặp: Chỉ giữ lại 1 node_id cho mỗi tên file (file_name)
    unique_images = {}
    for node_id, file_name in image_nodes:
        if file_name not in unique_images:
            unique_images[file_name] = node_id

    # 2. Kiểm tra Cache
    nodes_to_download = []
    final_files = []

    for file_name, node_id in unique_images.items():
        file_path = os.path.join(target_dir, f"{file_name}.png")
        final_files.append(f"{file_name}.png")

        if not os.path.exists(file_path):
            nodes_to_download.append((node_id, file_name))
        else:
            print(f"      ⚡ Ảnh đã tồn tại (Skip): {file_name}.png")

    if not nodes_to_download:
        return final_files

    # 3. Gọi API lấy URL
    node_ids = ",".join([node[0] for node in nodes_to_download])
    url = f"https://api.figma.com/v1/images/{file_key}?ids={node_ids}&format=png&use_absolute_bounds=true"

    try:
        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            print(f"      🚨 Lỗi API Figma ({response.status_code}): {response.text}")
            return final_files

        res = response.json()
        image_urls = res.get("images", {})

        # 4. Tải ảnh bằng ThreadPool (Bắt lỗi ngay bên trong luồng)
        def _download_single(n_id, f_name, i_url):
            try:
                if not i_url: return
                img_data = requests.get(i_url, timeout=15).content # Thêm timeout an toàn
                f_path = os.path.join(target_dir, f"{f_name}.png")
                with open(f_path, "wb") as f:
                    f.write(img_data)
                print(f"      📸 Đã tải: {f_name}.png")
            except Exception as e:
                print(f"      ⚠️ Lỗi tải ảnh {f_name}: {e}") # Bắt lỗi nội bộ, không làm sập luồng chính

        # Khối with sẽ tự động chờ tất cả các luồng chạy xong mà không cần future.result()
        with ThreadPoolExecutor(max_workers=5) as executor: # Giảm xuống 5 luồng để ổn định hơn
            for node_id, file_name in nodes_to_download:
                img_url = image_urls.get(node_id)
                executor.submit(_download_single, node_id, file_name, img_url)

        return final_files
    except Exception as e:
        print(f"      🚨 Lỗi: {e}")
        return final_files


def download_figma_icons(file_key, icon_nodes, target_dir):
    """Tải file SVG, khử trùng lặp và dùng Đa luồng (Multi-threading)"""
    token = os.environ.get("FIGMA_TOKEN")
    headers = {"X-Figma-Token": token}

    if not icon_nodes: return []

    # 1. Khử trùng lặp
    unique_icons = {}
    for node_id, rel_path in icon_nodes:
        if rel_path not in unique_icons:
            unique_icons[rel_path] = node_id

    # 2. Kiểm tra Cache
    nodes_to_download = []
    final_files = []

    for rel_path, node_id in unique_icons.items():
        file_path = os.path.join(target_dir, f"{rel_path}.svg")
        final_files.append(f"{rel_path}.svg")

        if not os.path.exists(file_path):
            nodes_to_download.append((node_id, rel_path))
        else:
            print(f"      ⚡ Icon đã tồn tại (Skip): {rel_path}.svg")

    if not nodes_to_download:
        return final_files

    # 3. Gọi API lấy URL
    node_ids = ",".join([node[0] for node in nodes_to_download])
    url = f"https://api.figma.com/v1/images/{file_key}?ids={node_ids}&format=svg"

    try:
        response = requests.get(url, headers=headers)
        if response.status_code != 200:
            print(f"      🚨 Lỗi API Figma Icons ({response.status_code}): {response.text}")
            return final_files

        res = response.json()
        image_urls = res.get("images", {})

        # 4. Tải Icon bằng ThreadPool (Bắt lỗi ngay bên trong luồng)
        def _download_single(n_id, r_path, i_url):
            try:
                if not i_url: return
                img_data = requests.get(i_url, timeout=15).content # Thêm timeout an toàn
                f_path = os.path.join(target_dir, f"{r_path}.svg")
                os.makedirs(os.path.dirname(f_path), exist_ok=True)
                with open(f_path, "wb") as f:
                    f.write(img_data)
                print(f"      ✨ Đã tải icon: {r_path}.svg")
            except Exception as e:
                print(f"      ⚠️ Lỗi tải icon {r_path}: {e}") # Bắt lỗi nội bộ

        with ThreadPoolExecutor(max_workers=5) as executor:
            for node_id, rel_path in nodes_to_download:
                img_url = image_urls.get(node_id)
                executor.submit(_download_single, node_id, rel_path, img_url)

        return final_files
    except Exception as e:
        print(f"      🚨 Lỗi khi tải icons: {e}")
        return final_files

def find_fonts(node, fonts_set=None):
    """Tìm tất cả các FontFamily duy nhất từ các node TEXT"""
    if fonts_set is None: fonts_set = set()

    # Kiểm tra nếu là node TEXT và có thông tin typography
    if node.get("type") == "TEXT" and "typography" in node:
        font_family = node["typography"].get("fontFamily")
        if font_family:
            fonts_set.add(font_family)

    # Đệ quy tìm trong các con cái
    for child in node.get("children", []):
        find_fonts(child, fonts_set)
    return list(fonts_set)

def get_all_texts(node, text_set=None):
    """Đệ quy quét toàn bộ text trong một node"""
    if text_set is None:
        text_set = set()

    if node.get("type") == "TEXT":
        text = node.get("text", "").strip()
        # Bỏ qua các chuỗi quá ngắn hoặc rỗng
        if text and len(text) > 1:
            text_set.add(text)

    for child in node.get("children", []):
        get_all_texts(child, text_set)

    return text_set

def extract_languages_from_figma(figma_data):
    """
    Tự động nhận diện và phân loại ngôn ngữ chính/phụ bằng AI.
    """
    target_node = figma_data
    for child in figma_data.get("children", []):
        if "language" in child.get("name", "").lower():
            target_node = child
            break

    raw_texts = list(get_all_texts(target_node))
    if not raw_texts:
        return [{"name": "English", "code": "en"}]

    from agents import _call_ai_json

    prompt = f"""
    Bạn là một chuyên gia Localization cho ứng dụng Flutter.
    Dưới đây là danh sách văn bản lấy từ giao diện chọn ngôn ngữ:
    {raw_texts}

    NHIỆM VỤ:
    1. Lọc ra các tên ngôn ngữ thực sự.
    2. Xác định mã ISO 639-1 (2 chữ cái) tương ứng.
    3. QUY TẮC CHÍNH/PHỤ: Nếu có nhiều biến thể của cùng một ngôn ngữ (VD: Português cho Bồ Đào Nha và Brasil, hoặc Tiếng Trung Phồn thể và Giản thể):
       - Ngôn ngữ CHÍNH/Gốc: CHỈ dùng mã 2 chữ cái (VD: "pt", "zh").
       - Ngôn ngữ PHỤ/Biến thể: Nối thêm mã quốc gia bằng dấu gạch dưới (VD: "pt_BR", "zh_TW").

    YÊU CẦU ĐỊNH DẠNG (BẮT BUỘC):
    Trả về một JSON Object duy nhất có key "languages".
    Ví dụ mẫu:
    {{
        "languages": [
            {{"name": "English", "code": "en"}},
            {{"name": "中文 (简体)", "code": "zh"}},
            {{"name": "中文 (繁體)", "code": "zh_TW"}},
            {{"name": "Português (Portugal)", "code": "pt"}},
            {{"name": "Português (Brasil)", "code": "pt_BR"}}
        ]
    }}
    """

    try:
        print("      🧠 Đang phân tích ngôn ngữ và phân loại chính/phụ...")
        result = _call_ai_json(prompt)
        languages = result.get("languages", [])
        if languages: return languages
    except Exception as e:
        print(f"      ⚠️ Lỗi khi AI phân tích ngôn ngữ động: {e}")

    return [{"name": "English", "code": "en"}]

def find_icon_nodes(node, found_list=None):
    """Tìm node [Icon] và xử lý đường dẫn thư mục con"""
    if found_list is None: found_list = []

    name = node.get("name", "")
    node_id = node.get("id")

    if "[Icon]" in name and node_id:
        # Lấy phần đường dẫn sau [Icon]
        # Ví dụ: "[Icon]/Setting/Back" -> "Setting/Back"
        raw_path = name.split("[Icon]")[-1].strip(" /")

        # Chuyển đổi các thành phần thư mục/file thành snake_case
        # VD: "Setting/Back" -> ["setting", "back"]
        parts = [re.sub(r'(?<!^)(?=[A-Z])', '_', p).lower() for p in raw_path.split("/")]

        # Nối lại thành đường dẫn tương đối (VD: "setting/back")
        rel_path = "/".join(parts)

        found_list.append((str(node_id), rel_path))

    for child in node.get("children", []):
        find_icon_nodes(child, found_list)

    return found_list
