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

def parse_frame_name_metadata(name: str):
    """
    Ví dụ:
    HomeCreateScreen__bottomTab=create_qr__subTab=qr_code
    HomeHistoryScreen__bottomTab=history__subTab=generated__dataState=empty
    """

    raw_name = (name or "").strip()
    if not raw_name:
        return {
            "raw_name": "",
            "base_name": "Unnamed",
            "state_tags": {},
        }

    parts = [p.strip() for p in raw_name.split("__") if p.strip()]
    base_name = parts[0] if parts else raw_name
    state_tags = {}

    for token in parts[1:]:
        if "=" in token:
            key, value = token.split("=", 1)
            key = key.strip()
            value = value.strip()
            if key and value:
                state_tags[key] = value

    return {
        "raw_name": raw_name,
        "base_name": base_name,
        "state_tags": state_tags,
    }

def strip_for_prompt(node):
    """
    Loại bỏ các field không cần thiết cho AI để giảm token count.
    Gọi SAU KHI get_used_assets() đã chạy xong (vì id vẫn cần cho asset matching).

    Những gì bị bỏ:
    - id: chỉ dùng nội bộ cho asset matching
    - visible: luôn True vì node ẩn đã bị lọc
    - all_texts: flat list trùng lặp với text trong children tree
    - layout.x, layout.y: tọa độ tuyệt đối, Flutter không cần
    - state_tags: {} khi rỗng
    - typography: bỏ các field None
    """
    if not isinstance(node, dict):
        return node

    _SKIP = {"id", "visible", "all_texts"}
    result = {}

    for key, value in node.items():
        if key in _SKIP:
            continue

        if key == "state_tags" and not value:
            continue

        if key == "layout" and isinstance(value, dict):
            size = {k: v for k, v in value.items() if k in ("width", "height")}
            if size:
                result["layout"] = size
            continue

        if key == "typography" and isinstance(value, dict):
            typo = {k: v for k, v in value.items() if v is not None}
            if typo:
                result["typography"] = typo
            continue

        if key == "children" and isinstance(value, list):
            stripped = [strip_for_prompt(c) for c in value]
            if stripped:
                result["children"] = stripped
            continue

        if key == "variants" and isinstance(value, list):
            result["variants"] = [strip_for_prompt(v) for v in value]
            continue

        result[key] = value

    return result


def simplify_node(node):
    """Bóc tách dữ liệu Figma thành JSON rút gọn cho AI"""
    name = node.get("name", "Unnamed")
    meta = parse_frame_name_metadata(name)

    simplified = {
        "id": node.get("id"),
        "name": meta["base_name"],         # tên logic của screen
        "raw_name": meta["raw_name"],      # tên đầy đủ trong Figma
        "state_tags": meta["state_tags"],  # metadata parse từ __key=value
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