import hashlib
import json
import os
import re
import shutil
import time

from dotenv import load_dotenv

from automation.ai.ai_palette_and_i18n import analyze_global_styles
from automation.ai.ai_screen_generator import generate_feature_code
from automation.figma_extractor.figma_assets import (
    download_figma_icons,
    download_figma_images,
    find_fonts,
    find_icon_nodes,
    find_image_nodes,
)
from automation.figma_extractor.figma_extractor import get_figma_screens
from automation.figma_extractor.figma_parser import strip_for_prompt
from automation.figma_extractor.figma_metadata import extract_languages_from_figma
from automation.helper.injector import to_snake_case, inject_to_flutter
from automation.helper.pipeline_steps import (
    build_asset_instructions,
    build_l10n_instructions,
    build_screen_context,
    build_special_logic_instructions,
    build_variant_instructions,
    finalize_project,
    install_ai_packages,
    load_dynamic_ai_context,
    prepare_global_models,
    prepare_global_translations,
    refresh_dynamic_ai_context,
    validate_generated_bundle,
)
from automation.helper.project_setup import (
    download_font,
    update_arb_files,
    update_localization,
    update_palette_file,
)
from automation.helper.screen_analysis import group_screen_variants
from automation.helper.utils import read_file

load_dotenv()


def to_camel_case(snake_str: str) -> str:
    components = snake_str.split("_")
    return components[0] + "".join(x.title() for x in components[1:])


def build_asset_lookup_maps(image_nodes, icon_nodes):
    """
    Chuẩn hóa về dạng node_id -> filename để get_used_assets dùng ổn định.
    """
    img_dict = {node_id: f"{file_name}.png" for node_id, file_name in image_nodes}
    icon_dict = {node_id: f"{rel_path}.svg" for node_id, rel_path in icon_nodes}
    return img_dict, icon_dict


def get_sort_priority(screen_node: dict) -> int:
    name = (screen_node.get("name") or "").lower()

    if screen_node.get("is_sub_tab"):
        return 0

    if any(kw in name for kw in ["complete", "result", "detail", "history", "view"]):
        return 1

    if any(kw in name for kw in ["home", "main", "splash", "root", "nav"]):
        return 3

    return 2


def build_route_list(screens: list[dict]) -> str:
    route_names = []

    for screen in screens:
        raw = (screen.get("raw_name") or screen.get("name") or "").strip()
        if not raw:
            continue

        if screen.get("is_sub_tab", False):
            continue

        base_name = (screen.get("name") or "").strip()
        safe_name = re.sub(r"[^a-zA-Z0-9]", "", base_name)

        # Tạo PascalCase chuẩn cho Route class
        feature = to_camel_case(to_snake_case(safe_name))
        feature = feature[:1].upper() + feature[1:]
        feature = feature.replace("Screen", "")

        if feature:
            route_names.append(f"{feature}Route")

    return ", ".join(sorted(set(route_names))) if route_names else "Không có route nào"


def maybe_clear_old_figma_cache(current_dir: str, figma_key: str) -> None:
    """
    Dùng khi cần ép refresh cache.
    Bật bằng env CLEAR_FIGMA_CACHE=1
    """
    if os.environ.get("CLEAR_FIGMA_CACHE") != "1":
        return

    cache_file = os.path.join(
        current_dir,
        f".cache_figma_{figma_key}.json",
    )

    if os.path.exists(cache_file):
        try:
            os.remove(cache_file)
            print(f"   -> 🧹 Đã xóa cache Figma cũ: {cache_file}")
        except Exception as e:
            print(f"   -> ⚠️ Không thể xóa cache Figma: {e}")


def debug_figma_shape(figma_data: dict) -> None:
    if not isinstance(figma_data, dict):
        print("DEBUG figma_data type:", type(figma_data))
        return

    print("DEBUG figma top-level keys:", list(figma_data.keys()))

    screens_val = figma_data.get("screens")
    children_val = figma_data.get("children")
    page_meta_val = figma_data.get("page_meta", {})

    print(
        "DEBUG screens len:",
        len(screens_val) if isinstance(screens_val, list) else "not-list-or-none",
    )
    print(
        "DEBUG children len:",
        len(children_val) if isinstance(children_val, list) else "not-list-or-none",
    )

    if isinstance(page_meta_val, dict):
        print("DEBUG page_meta keys:", list(page_meta_val.keys()))


def extract_screens_from_figma_data(figma_data: dict) -> list[dict]:
    """
    Hỗ trợ cả format mới:
      {"screens": [...]}

    và format cũ:
      {"children": [...]}
    """
    if not isinstance(figma_data, dict):
        return []

    screens = figma_data.get("screens")

    if screens is None:
        screens = figma_data.get("children", [])

    if not screens:
        page_meta = figma_data.get("page_meta", {}) or {}
        if isinstance(page_meta, dict):
            screens = page_meta.get("children", []) or []

    if not isinstance(screens, list):
        return []

    screens = [
        s for s in screens
        if isinstance(s, dict) and s.get("visible", True)
    ]
    return screens


def extract_colors_from_figma_data(figma_data: dict) -> list:
    if not isinstance(figma_data, dict):
        return []

    styles = figma_data.get("styles", {})
    if not isinstance(styles, dict):
        return []

    colors = styles.get("colors", [])
    if isinstance(colors, list):
        return colors

    return []

def validate_route_names_against_route_list(code: dict, route_list: str, raw_name: str) -> None:
    """
    Bắt nhanh các route bị AI bịa trước khi vào validator sâu hơn.
    Chỉ check app routes, bỏ qua framework routes.
    """
    allowed_routes = {
        r.strip() for r in route_list.split(",")
        if r.strip() and r.strip() != "Không có route nào"
    }

    framework_routes = {
        "Route",
        "PageRoute",
        "ModalRoute",
        "MaterialPageRoute",
        "CupertinoPageRoute",
    }

    generated_bundle = "\n".join([
        code.get("screen", "") or "",
        code.get("cubit", "") or "",
        code.get("state", "") or "",
        ])

    used_routes = set(re.findall(r'\b([A-Z][A-Za-z0-9_]*Route)\s*\(', generated_bundle))
    used_routes = {r for r in used_routes if r not in framework_routes}

    unknown_routes = sorted([r for r in used_routes if r not in allowed_routes])

    if unknown_routes:
        raise ValueError(
            f"{raw_name}: AI đang dùng route không hợp lệ: {unknown_routes}. "
            f"Allowed routes: {sorted(allowed_routes)}"
        )

def main():
    # ==========================================================
    # 0. CẤU HÌNH MÔI TRƯỜNG VÀ ĐƯỜNG DẪN
    # ==========================================================
    app_name = os.environ.get("APP_NAME", "TestApp")
    figma_key = os.environ.get("FIGMA_KEY")

    current_dir = os.path.dirname(os.path.abspath(__file__))
    new_app_path = os.path.normpath(os.path.join(current_dir, f"../apps/{app_name}"))
    base_project_path = os.path.normpath(os.path.join(current_dir, "../base_flutter_project"))

    maybe_clear_old_figma_cache(current_dir, figma_key)

    # ==========================================================
    # 1. KHỞI TẠO PROJECT: COPY TỪ BASE
    # ==========================================================
    print(f"1. Đang chuẩn bị App: {app_name}...")
    if not os.path.exists(new_app_path):
        print("   -> 📂 Đang sao chép mã nguồn cơ bản từ Base Project...")
        shutil.copytree(
            base_project_path,
            new_app_path,
            ignore=shutil.ignore_patterns(".git", "build"),
        )
    else:
        print("   -> ✅ Thư mục App đã tồn tại.")

    # ==========================================================
    # 2. KHỞI TẠO CACHE
    # ==========================================================
    cache_path = os.path.join(new_app_path, ".ai_build_cache.json")
    build_cache = {}

    if os.path.exists(cache_path):
        try:
            with open(cache_path, "r", encoding="utf-8") as f:
                build_cache = json.load(f)
        except Exception:
            build_cache = {}

    # ==========================================================
    # 3. BÓC TÁCH DỮ LIỆU FIGMA + ĐỌC RULE/SPEC
    # ==========================================================
    print("3. Đang bóc tách dữ liệu từ Figma...")
    figma_data = get_figma_screens(figma_key)
    debug_figma_shape(figma_data)

    rules_content = read_file(os.path.join(current_dir, "prompts/ai_architecture_rules.md"))
    spec_content = read_file(os.path.join(current_dir, "app_spec"))

    # Dynamic package name: thay flutter_base bằng tên package thực
    from automation.helper.injector import _get_package_name
    _actual_pkg = _get_package_name(new_app_path)
    if _actual_pkg != "flutter_base":
        rules_content = rules_content.replace("flutter_base", _actual_pkg)

    # ==========================================================
    # 4. LOCALIZATION
    # ==========================================================
    print("4. Đang xử lý đa ngôn ngữ (Localization)...")
    detected_languages = extract_languages_from_figma(figma_data)
    update_localization(new_app_path, detected_languages)

    # ==========================================================
    # 5. XỬ LÝ ASSETS: IMAGES + ICONS
    # ==========================================================
    print("5. Đang quét và tải Hình ảnh & Icon...")
    # Quét image/icon từ TẤT CẢ screens (figma_data.screens là list, không có "children")
    image_nodes = []
    icon_nodes = []
    for screen in figma_data.get("screens", []):
        find_image_nodes(screen, image_nodes)
        find_icon_nodes(screen, icon_nodes)

    images_dir = os.path.join(new_app_path, "assets/images")
    downloaded_images = download_figma_images(figma_key, image_nodes, images_dir)
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_images)} hình ảnh.")

    icons_dir = os.path.join(new_app_path, "assets/icons")
    downloaded_icons = download_figma_icons(figma_key, icon_nodes, icons_dir)
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_icons)} icons.")

    img_dict, icon_dict = build_asset_lookup_maps(image_nodes, icon_nodes)

    # ==========================================================
    # 6. XỬ LÝ FONT
    # ==========================================================
    print("6. Đang kiểm tra và tải Fonts...")
    # Quét fonts từ tất cả screens (figma_data không có "children" trực tiếp)
    _fonts_set = set()
    for screen in figma_data.get("screens", []):
        find_fonts(screen, _fonts_set)
    font_families = list(_fonts_set)
    fonts_dir = os.path.join(new_app_path, "assets/fonts")
    os.makedirs(fonts_dir, exist_ok=True)

    downloaded_fonts = []
    for font_family in sorted(font_families):
        try:
            font_path = download_font(font_family, fonts_dir)
            if font_path:
                downloaded_fonts.append(font_path)
        except Exception as e:
            print(f"   ⚠️ Lỗi tải font '{font_family}': {e}")

    print(f"   ✅ Hoàn tất xử lý {len(downloaded_fonts)} fonts.")

    # ==========================================================
    # 7. PHÂN TÍCH MÀU / PALETTE
    # ==========================================================
    print("7. Đang phân tích màu sắc và cập nhật Palette...")
    palette_rules = ""

    colors_list = extract_colors_from_figma_data(figma_data)
    if colors_list:
        try:
            palette_result = analyze_global_styles(json.dumps(colors_list, ensure_ascii=False))
            palette_updates = palette_result.get("palette_updates", "")
            allowed_hexes = palette_result.get("allowed_hexes", [])
            allowed_gradients = palette_result.get("allowed_gradients", [])

            if palette_updates:
                update_palette_file(new_app_path, palette_updates)
                print("   ✅ Đã cập nhật palette.dart")

            palette_rules = f"""
[QUY TẮC SỬ DỤNG PALETTE]:
- CHỈ được dùng các token đã có thật trong class Palette.
- Nếu màu/gradient KHÔNG có token trong Palette thì phải dùng trực tiếp:
  + Color(0xFF......) cho màu thường
  + LinearGradient(...) / RadialGradient(...) trực tiếp nếu thật sự cần và không có token tên sẵn
- TUYỆT ĐỐI KHÔNG tự bịa tên mới trong Palette.

[CÁC MÀU HEX ĐƯỢC PHÉP DÙNG TRỰC TIẾP]:
{chr(10).join(f"- {x}" for x in allowed_hexes)}

[CÁC GRADIENT TOKEN ĐƯỢC PHÉP DÙNG]:
{chr(10).join(f"- {x}" for x in allowed_gradients)}
"""
        except Exception as e:
            print(f"   ⚠️ Lỗi cập nhật palette: {e}")
    else:
        print("   -> Không tìm thấy styles/colors trong Figma.")

    # ==========================================================
    # 8. PHÂN TÍCH MÀN HÌNH
    # ==========================================================
    print("8. Đang phân tích cấu trúc các màn hình...")
    screens = extract_screens_from_figma_data(figma_data)

    if not screens:
        top_keys = list(figma_data.keys()) if isinstance(figma_data, dict) else []
        raise ValueError(
            f"Không tìm thấy screen nào trong dữ liệu Figma. Top-level keys: {top_keys}"
        )

    screens = group_screen_variants(screens)
    screens.sort(key=get_sort_priority)

    route_list = build_route_list(screens)
    print("DEBUG route_list:", route_list)

    # ==========================================================
    # 9. DỮ LIỆU TOÀN CỤC CHO AI
    # ==========================================================
    print("9. Đang chuẩn bị dữ liệu toàn cục cho AI...")

    global_keys_mapping, _, build_cache = prepare_global_translations(
        new_app_path=new_app_path,
        screens=screens,
        detected_languages=detected_languages,
        build_cache=build_cache,
        cache_path=cache_path,
        update_arb_files_fn=update_arb_files,
    )

    prepare_global_models(
        new_app_path=new_app_path,
        spec_content=spec_content,
        screens=screens,
    )

    dynamic_ai_context = load_dynamic_ai_context(new_app_path)

    # ==========================================================
    # 10. SINH CODE CHO TỪNG MÀN HÌNH
    # ==========================================================
    # RESUME MODE: Bật bằng env RESUME=1
    # Khi bật: skip các screen đã có file trên disk, chỉ gen screen chưa có.
    # Dùng khi pipeline crash giữa chừng hoặc khi chỉ sửa spec cho 1 screen cụ thể.
    # Để ép gen lại 1 screen cụ thể, set FORCE_SCREENS="SettingScreen,LanguageScreen"
    resume_mode = os.environ.get("RESUME", "0") == "1"
    force_screens_env = os.environ.get("FORCE_SCREENS", "").strip()
    force_screens = set(s.strip() for s in force_screens_env.split(",") if s.strip()) if force_screens_env else set()

    if resume_mode:
        print("   🔄 RESUME MODE: Bật. Chỉ gen các screen chưa có file hoặc nằm trong FORCE_SCREENS.")
    if force_screens:
        print(f"   🎯 FORCE_SCREENS: {force_screens}")

    print(f"\n🚀 BẮT ĐẦU GEN {len(screens)} MÀN HÌNH THEO SPEC...")

    for i, screen_node in enumerate(screens):
        raw_name = (screen_node.get("raw_name") or screen_node.get("name") or "Unknown").strip()
        base_name = (screen_node.get("name") or "Unknown").strip()

        safe_feature_name = re.sub(r"[^a-zA-Z0-9]", "", base_name)
        feature_name = safe_feature_name.replace("View", "").replace("Screen", "").strip()

        print(f"\n   ⚙️ [{i + 1}/{len(screens)}] Đang xử lý: {raw_name}...")

        # --- RESUME CHECK: skip screen đã có file trên disk ---
        if resume_mode and base_name not in force_screens and raw_name not in force_screens:
            snake_name = to_snake_case(feature_name)
            is_sub = screen_node.get("is_sub_tab", False)
            parent_name = screen_node.get("parent_name")

            if is_sub:
                parent_snake = to_snake_case(parent_name) if parent_name else "shared"
                check_path = os.path.join(
                    new_app_path, "lib", "src", "presentation",
                    parent_snake, "widgets",
                    snake_name + ("_widget.dart" if not snake_name.endswith("_widget") else ".dart"),
                )
            else:
                check_path = os.path.join(
                    new_app_path, "lib", "src", "presentation",
                    snake_name,
                    snake_name + ("_screen.dart" if not snake_name.endswith("_screen") else ".dart"),
                )

            if os.path.exists(check_path):
                print(f"      ⏩ [RESUME] File đã tồn tại, bỏ qua: {os.path.basename(check_path)}")
                # Vẫn refresh context để các screen sau thấy constructor của screen này
                dynamic_ai_context = refresh_dynamic_ai_context(
                    new_app_path=new_app_path,
                    current_context=dynamic_ai_context,
                )
                continue

        # --- CACHE CHECK: skip screen chưa thay đổi ---
        screen_fingerprint = (
                json.dumps(screen_node, sort_keys=True, ensure_ascii=False)
                + rules_content
                + spec_content
        )
        screen_hash = hashlib.md5(screen_fingerprint.encode("utf-8")).hexdigest()

        if build_cache.get(raw_name) == screen_hash:
            print("      ⚡ [CACHE HIT] Màn hình không đổi, bỏ qua gọi AI để tiết kiệm Token!")
            # Vẫn refresh context để các screen sau thấy constructor của screen này
            dynamic_ai_context = refresh_dynamic_ai_context(
                new_app_path=new_app_path,
                current_context=dynamic_ai_context,
            )
            continue

        asset_instructions = build_asset_instructions(
            screen_node=screen_node,
            img_dict=img_dict,
            icon_dict=icon_dict,
        )

        l10n_instructions = build_l10n_instructions(
            screen_node=screen_node,
            global_keys_mapping=global_keys_mapping,
        )

        special_logic_instructions = build_special_logic_instructions(
            screen_node=screen_node,
            base_name=base_name,
        )

        variant_instructions = build_variant_instructions(screen_node)

        # Đọc palette.dart thực tế để inject vào prompt (chống hallucination)
        _palette_path = os.path.join(new_app_path, "lib", "src", "config", "theme", "palette.dart")
        _palette_content = ""
        if os.path.exists(_palette_path):
            with open(_palette_path, "r", encoding="utf-8") as _pf:
                _palette_content = _pf.read()

        ctx = build_screen_context(
            spec_content=spec_content,
            dynamic_ai_context=dynamic_ai_context,
            asset_instructions=asset_instructions,
            l10n_instructions=l10n_instructions,
            special_logic_instructions=special_logic_instructions,
            variant_instructions=variant_instructions,
            route_list=route_list,
            palette_rules=palette_rules,
            palette_content=_palette_content,
        )

        screen_payload = dict(screen_node)
        if screen_node.get("state_tags"):
            screen_payload["variants"] = []

        code = generate_feature_code(
            base_name,
            json.dumps(strip_for_prompt(screen_payload), ensure_ascii=False, separators=(',', ':')),
            ctx,
            rules_content,
        )

        # Pre-check route: nếu AI bịa route thì retry 1 lần
        try:
            validate_route_names_against_route_list(
                code=code,
                route_list=route_list,
                raw_name=raw_name,
            )
        except ValueError as e:
            print(f"      ⚠️ Route không hợp lệ, đang retry 1 lần: {e}")

            retry_ctx = ctx + """

[ROUTE ERROR TỪ RESPONSE TRƯỚC]:
- Response trước đã dùng route không hợp lệ.
- TUYỆT ĐỐI KHÔNG dùng các route ngoài danh sách cho phép.
- Nếu không có route đích phù hợp thì không điều hướng.
"""

            code = generate_feature_code(
                base_name,
                json.dumps(strip_for_prompt(screen_payload), ensure_ascii=False, separators=(',', ':')),
                retry_ctx,
                rules_content,
            )

            try:
                validate_route_names_against_route_list(
                    code=code,
                    route_list=route_list,
                    raw_name=raw_name,
                )
            except ValueError as e2:
                print(f"      ⚠️ Route vẫn không hợp lệ sau retry, bỏ qua validation: {e2}")

        used_packages = install_ai_packages(
            code=code,
            new_app_path=new_app_path,
        )

        # TODO: bước sau có thể gọi initialize_required_packages(new_app_path, used_packages)

        validate_generated_bundle(
            new_app_path=new_app_path,
            code=code,
            raw_name=raw_name,
            route_list=route_list,
        )

        created_files = inject_to_flutter(
            new_app_path,
            feature_name,
            code,
            is_sub_tab=screen_node.get("is_sub_tab", False),
            parent_name=screen_node.get("parent_name"),
        )

        for key, value in created_files.items():
            print(f"      📄 {key}: {value}")

        build_cache[raw_name] = screen_hash
        with open(cache_path, "w", encoding="utf-8") as f:
            json.dump(build_cache, f, ensure_ascii=False, indent=2)

        dynamic_ai_context = refresh_dynamic_ai_context(
            new_app_path=new_app_path,
            current_context=dynamic_ai_context,
        )

        if i < len(screens) - 1:
            print("      ⏸️ Đang nghỉ 8 giây để dàn đều token...")
            time.sleep(8)

    # ==========================================================
    # 11. HOÀN THIỆN PROJECT
    # ==========================================================
    finalize_project(new_app_path)


if __name__ == "__main__":
    main()