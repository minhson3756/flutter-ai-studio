import os
import re
from concurrent.futures import ThreadPoolExecutor

import requests


def find_image_nodes(node, found_list=None):
    """Tìm node [Image] - Xử lý cả dấu / và dấu :
    Hỗ trợ cả raw Figma data (name chứa [Image]) và simplified data (raw_name chứa [Image])
    """
    if found_list is None: found_list = []

    # Kiểm tra cả name và raw_name (simplify_node lưu tên gốc vào raw_name)
    name = node.get("raw_name") or node.get("name", "")
    node_id = node.get("id")

    if "[Image]" in name and node_id:
        # Lấy phần tên sau dấu / hoặc :
        clean_name = name.split('/')[-1].split(':')[-1].replace("[Image]", "").strip()
        # Chuyển sang snake_case, xử lý acronym (QRCode -> qr_code, không phải q_r_code)
        file_name = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', clean_name)
        file_name = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', file_name).lower()
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

def find_icon_nodes(node, found_list=None):
    """Tìm node [Icon] và xử lý đường dẫn thư mục con
    Hỗ trợ cả raw Figma data và simplified data (raw_name)
    """
    if found_list is None: found_list = []

    # Kiểm tra cả name và raw_name
    name = node.get("raw_name") or node.get("name", "")
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