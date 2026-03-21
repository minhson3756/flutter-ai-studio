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
        "name": meta["base_name"],
        "raw_name": meta["raw_name"],
        "state_tags": meta["state_tags"],
        "type": node.get("type", "UNKNOWN"),
        "visible": node.get("visible", True),
    }

    # Bỏ qua node ẩn
    if simplified["visible"] is False:
        return simplified

    # Layout cơ bản
    for key in [
        "absoluteBoundingBox",
        "constraints",
        "layoutMode",
        "primaryAxisAlignItems",
        "counterAxisAlignItems",
        "itemSpacing",
        "paddingLeft",
        "paddingRight",
        "paddingTop",
        "paddingBottom",
    ]:
        if key in node:
            simplified[key] = node[key]

    # Border radius
    if node.get("cornerRadius") is not None:
        simplified["cornerRadius"] = node.get("cornerRadius")

    if node.get("rectangleCornerRadii") is not None:
        simplified["rectangleCornerRadii"] = node.get("rectangleCornerRadii")

    # Fill / color
    fills = node.get("fills", [])
    fill_color = extract_color(fills)
    if fill_color:
        simplified["fillColor"] = fill_color

    # Border / stroke
    strokes = node.get("strokes", [])
    visible_strokes = [
        s for s in strokes
        if isinstance(s, dict) and s.get("visible", True) and s.get("type") == "SOLID"
    ]
    if visible_strokes:
        simplified["strokes"] = visible_strokes
        simplified["strokeWeight"] = node.get("strokeWeight", 1)

    # Effects / shadow
    effects = node.get("effects", [])
    visible_effects = [
        e for e in effects
        if isinstance(e, dict) and e.get("visible", True)
    ]
    if visible_effects:
        simplified["effects"] = visible_effects

    # Text
    if node.get("type") == "TEXT":
        chars = node.get("characters", "")
        if chars:
            simplified["text"] = chars

        style = node.get("style", {}) or {}
        text_style = {}
        for key in [
            "fontFamily",
            "fontPostScriptName",
            "fontWeight",
            "fontSize",
            "textAlignHorizontal",
            "textAlignVertical",
            "letterSpacing",
            "lineHeightPx",
        ]:
            if key in style:
                text_style[key] = style[key]

        if text_style:
            simplified["textStyle"] = text_style

    # Image/icon hints
    if node.get("type") == "RECTANGLE" and fills:
        for fill in fills:
            if isinstance(fill, dict) and fill.get("type") == "IMAGE":
                simplified["isImage"] = True
                break

    if "icon" in name.lower():
        simplified["isIconHint"] = True

    # Children
    children = node.get("children", [])
    if children:
        simplified_children = []
        for child in children:
            child_simple = simplify_node(child)
            if child_simple and child_simple.get("visible", True):
                simplified_children.append(child_simple)
        if simplified_children:
            simplified["children"] = simplified_children

    return simplified