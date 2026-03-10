import os

import requests
import time
import json  # BỔ SUNG THƯ VIỆN NÀY
from dotenv import load_dotenv

from automation.figma_extractor.figma_parser import simplify_node

load_dotenv()



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

