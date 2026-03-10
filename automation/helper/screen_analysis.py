import json
import re


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

def group_complex_screens(screens):
    """
    Gom các frame cùng base screen thành 1 logical screen có nhiều variants.
    Mỗi variant giữ state_tags riêng để AI hiểu state machine của màn hình.
    """
    grouped = {}
    result = []

    for s in screens:
        raw_name = (s.get("raw_name") or s.get("name") or "Unknown").strip()
        base_name = (s.get("name") or "Unknown").strip()
        state_tags = s.get("state_tags", {}) or {}

        # Nếu là frame có metadata state -> gom theo base_name
        if state_tags:
            if base_name not in grouped:
                grouped[base_name] = {
                    "name": base_name,
                    "raw_name": raw_name,
                    "type": s.get("type"),
                    "visible": s.get("visible", True),
                    "layout": s.get("layout"),
                    "children": s.get("children", []),
                    "all_texts": sorted(get_screen_texts(s)),
                    "variants": [],
                    "is_complex": True,
                }

            grouped[base_name]["variants"].append({
                "raw_name": raw_name,
                "state_tags": state_tags,
                "children": s.get("children", []),
                "layout": s.get("layout"),
                "all_texts": sorted(get_screen_texts(s)),
            })
        else:
            # frame thường, không có metadata state
            if "all_texts" not in s:
                s["all_texts"] = list(get_screen_texts(s))
            result.append(s)

    # Đưa grouped screens vào result
    for _, item in grouped.items():
        # hợp nhất text của các variant
        all_texts = set(item.get("all_texts", []))
        for v in item.get("variants", []):
            for t in v.get("all_texts", []):
                all_texts.add(t)
        item["all_texts"] = sorted(all_texts)
        result.append(item)

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

def group_screen_variants(screens):
    """
    Gom các frame cùng base screen thành 1 logical screen.
    Các frame có state_tags sẽ trở thành variants của cùng 1 màn.
    """
    grouped = {}
    normal_screens = []

    for s in screens:
        base_name = (s.get("name") or "Unknown").strip()
        raw_name = (s.get("raw_name") or base_name).strip()
        state_tags = s.get("state_tags", {}) or {}

        if state_tags:
            if base_name not in grouped:
                grouped[base_name] = {
                    "name": base_name,
                    "raw_name": raw_name,
                    "type": s.get("type"),
                    "visible": s.get("visible", True),
                    "children": s.get("children", []),
                    "layout": s.get("layout"),
                    "all_texts": sorted(get_screen_texts(s)),
                    "variants": [],
                }

            grouped[base_name]["variants"].append({
                "raw_name": raw_name,
                "state_tags": state_tags,
                "children": s.get("children", []),
                "layout": s.get("layout"),
                "all_texts": sorted(get_screen_texts(s)),
            })
        else:
            if "all_texts" not in s:
                s["all_texts"] = sorted(get_screen_texts(s))
            normal_screens.append(s)

    result = normal_screens[:]
    for _, item in grouped.items():
        merged_texts = set(item.get("all_texts", []))
        for variant in item.get("variants", []):
            for t in variant.get("all_texts", []):
                merged_texts.add(t)
        item["all_texts"] = sorted(merged_texts)
        result.append(item)

    return result