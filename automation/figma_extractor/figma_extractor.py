import os

import requests
import time
import json  # BỔ SUNG THƯ VIỆN NÀY
from dotenv import load_dotenv

from automation.figma_extractor.figma_parser import simplify_node

load_dotenv()

def get_figma_screens(figma_key: str) -> dict:
    """
    Tải dữ liệu từ Figma và chuẩn hóa về format thống nhất:

    {
      "screens": [...],
      "styles": {...},
      "page_meta": {...}
    }

    Hỗ trợ cả cache cũ lẫn format cũ.
    """
    import json
    import os
    import requests

    if not figma_key:
        raise ValueError("Thiếu FIGMA_KEY trong environment.")

    cache_file = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        f".cache_figma_{figma_key}.json",
    )

    def _normalize_figma_result(raw_data: dict) -> dict:
        """
        Chuẩn hóa mọi dạng output về cùng một contract:
        {
          "screens": [...],
          "styles": {...},
          "page_meta": {...}
        }
        """
        if not isinstance(raw_data, dict):
            return {
                "screens": [],
                "styles": {},
                "page_meta": {},
            }

        # Case 1: đã là format mới
        if "screens" in raw_data:
            return {
                "screens": raw_data.get("screens", []) or [],
                "styles": raw_data.get("styles", {}) or {},
                "page_meta": raw_data.get("page_meta", {}) or {},
            }

        # Case 2: format root/page cũ với children
        if "children" in raw_data:
            return {
                "screens": raw_data.get("children", []) or [],
                "styles": raw_data.get("styles", {}) or {},
                "page_meta": {
                    "id": raw_data.get("id"),
                    "name": raw_data.get("name"),
                    "raw_name": raw_data.get("raw_name"),
                    "state_tags": raw_data.get("state_tags", {}) or {},
                },
            }

        # fallback
        return {
            "screens": [],
            "styles": raw_data.get("styles", {}) or {},
            "page_meta": {},
        }

    # ==========================================================
    # 1. ƯU TIÊN ĐỌC CACHE
    # ==========================================================
    if os.path.exists(cache_file):
        try:
            with open(cache_file, "r", encoding="utf-8") as f:
                cached_data = json.load(f)
            normalized = _normalize_figma_result(cached_data)
            return normalized
        except Exception:
            # cache lỗi thì bỏ qua, tải mới
            pass

    # ==========================================================
    # 2. GỌI FIGMA API
    # ==========================================================
    figma_token = os.environ.get("FIGMA_TOKEN")
    if not figma_token:
        raise ValueError("Thiếu FIGMA_TOKEN trong environment.")

    print(f"   -> 🌐 Đang kết nối với máy chủ Figma (File Key: {figma_key})...")

    url = f"https://api.figma.com/v1/files/{figma_key}"
    headers = {
        "X-Figma-Token": figma_token,
    }

    response = requests.get(url, headers=headers, timeout=60)
    response.raise_for_status()

    data = response.json()
    print("   -> Đã tải xong data. Đang bóc tách giao diện...")

    document = data.get("document", {})
    pages = document.get("children", [])

    if not pages:
        result = {
            "screens": [],
            "styles": data.get("styles", {}) or {},
            "page_meta": {},
        }
        with open(cache_file, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        return result

    # Lấy page đầu tiên
    first_page = pages[0]

    # simplify_node phải được import sẵn trong file này
    simplified_page = simplify_node(first_page)

    result = {
        "screens": simplified_page.get("children", []) or [],
        "styles": data.get("styles", {}) or {},
        "page_meta": {
            "id": simplified_page.get("id"),
            "name": simplified_page.get("name"),
            "raw_name": simplified_page.get("raw_name"),
            "state_tags": simplified_page.get("state_tags", {}) or {},
        },
    }

    with open(cache_file, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    return result
