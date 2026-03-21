import hashlib
import json
import os
import re
import shutil
import time

from dotenv import load_dotenv

from automation.ai.ai_palette_and_i18n import analyze_global_styles
from automation.ai.ai_screen_generator import generate_feature_code
from automation.figma_extractor.figma_assets import find_image_nodes, download_figma_images, \
    find_icon_nodes, download_figma_icons, find_fonts
from automation.figma_extractor.figma_extractor import get_figma_screens
from automation.figma_extractor.figma_parser import strip_for_prompt
from automation.figma_extractor.figma_metadata import extract_languages_from_figma
from automation.helper.injector import to_snake_case, inject_to_flutter
from automation.helper.pipeline_steps import prepare_global_translations, prepare_global_models, \
    load_dynamic_ai_context, build_asset_instructions, build_l10n_instructions, \
    build_special_logic_instructions, build_variant_instructions, build_screen_context, \
    install_ai_packages, validate_generated_bundle, analyze_and_fix_screen, \
    refresh_dynamic_ai_context, finalize_project
from automation.helper.project_setup import update_localization, download_font, update_palette_file, \
    update_arb_files
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

        base_name = screen.get("name", "") or ""
        feature = to_camel_case(to_snake_case(re.sub(r"[^a-zA-Z0-9]", "", base_name)))
        feature = feature.replace("Screen", "")
        if feature:
            route_names.append(f"{feature}Route")

    return ", ".join(sorted(set(route_names))) if route_names else "Không có route nào"


def main():
    # ==========================================================
    # 0. CẤU HÌNH MÔI TRƯỜNG VÀ ĐƯỜNG DẪN
    # ==========================================================
    app_name = os.environ.get("APP_NAME", "TestApp")
    figma_key = os.environ.get("FIGMA_KEY")
    current_dir = os.path.dirname(os.path.abspath(__file__))
    new_app_path = os.path.normpath(os.path.join(current_dir, f"../apps/{app_name}"))
    base_project_path = os.path.normpath(os.path.join(current_dir, "../base_flutter_project"))

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
    rules_content = read_file(os.path.join(current_dir, "prompts/ai_architecture_rules.md"))
    spec_content = read_file(os.path.join(current_dir, "app_spec"))

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
    image_nodes = find_image_nodes(figma_data)
    images_dir = os.path.join(new_app_path, "assets/images")
    downloaded_images = download_figma_images(figma_key, image_nodes, images_dir)
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_images)} hình ảnh.")

    icon_nodes = find_icon_nodes(figma_data)
    icons_dir = os.path.join(new_app_path, "assets/icons")
    downloaded_icons = download_figma_icons(figma_key, icon_nodes, icons_dir)
    print(f"   ✅ Hoàn tất xử lý {len(downloaded_icons)} icons.")

    img_dict, icon_dict = build_asset_lookup_maps(image_nodes, icon_nodes)

    # ==========================================================
    # 6. XỬ LÝ FONT
    # ==========================================================
    print("6. Đang kiểm tra và tải Fonts...")
    font_families = find_fonts(figma_data)
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
    colors_list = figma_data.get("styles", {}).get("colors", [])
    if colors_list:
        try:
            palette_result = analyze_global_styles(json.dumps(colors_list, ensure_ascii=False))
            palette_updates = palette_result.get("palette_updates", "")
            if palette_updates:
                update_palette_file(new_app_path, palette_updates)
                print("   ✅ Đã cập nhật palette.dart")
        except Exception as e:
            print(f"   ⚠️ Lỗi cập nhật palette: {e}")
    else:
        print("   -> Không tìm thấy styles/colors trong Figma.")

    # ==========================================================
    # 8. PHÂN TÍCH MÀN HÌNH
    # ==========================================================
    print("8. Đang phân tích cấu trúc các màn hình...")
    screens = figma_data.get("screens")
    if screens is None:
        screens = figma_data.get("children", [])

    if not screens:
        raise ValueError(
            f"Không tìm thấy screen nào trong dữ liệu Figma. "
            f"Top-level keys: {list(figma_data.keys())}"
        )

    screens = group_screen_variants(screens)
    screens.sort(key=get_sort_priority)
    route_list = build_route_list(screens)

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
    print(f"\n🚀 BẮT ĐẦU GEN {len(screens)} MÀN HÌNH THEO SPEC...")

    for i, screen_node in enumerate(screens):
        raw_name = (screen_node.get("raw_name") or screen_node.get("name") or "Unknown").strip()
        base_name = (screen_node.get("name") or "Unknown").strip()

        safe_feature_name = re.sub(r"[^a-zA-Z0-9]", "", base_name)
        feature_name = safe_feature_name.replace("View", "").replace("Screen", "").strip()

        print(f"\n   ⚙️ [{i + 1}/{len(screens)}] Đang xử lý: {raw_name}...")

        screen_fingerprint = (
                json.dumps(screen_node, sort_keys=True, ensure_ascii=False)
                + rules_content
                + spec_content
        )
        screen_hash = hashlib.md5(screen_fingerprint.encode("utf-8")).hexdigest()

        if build_cache.get(raw_name) == screen_hash:
            print("      ⚡ [CACHE HIT] Màn hình không đổi, bỏ qua gọi AI để tiết kiệm Token!")
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

        ctx = build_screen_context(
            spec_content=spec_content,
            dynamic_ai_context=dynamic_ai_context,
            asset_instructions=asset_instructions,
            l10n_instructions=l10n_instructions,
            special_logic_instructions=special_logic_instructions,
            variant_instructions=variant_instructions,
            route_list=route_list,
        )

        code = generate_feature_code(
            base_name,
            json.dumps(strip_for_prompt(screen_node), ensure_ascii=False, separators=(',', ':')),
            ctx,
            rules_content,
        )

        install_ai_packages(
            code=code,
            new_app_path=new_app_path,
        )

        validate_generated_bundle(
            new_app_path=new_app_path,
            code=code,
            raw_name=raw_name,
        )

        created_files = inject_to_flutter(
            new_app_path,
            feature_name,
            code,
            is_sub_tab=screen_node.get("is_sub_tab", False),
            parent_name=screen_node.get("parent_name"),
        )

        # analyze_and_fix_screen(
        #     new_app_path=new_app_path,
        #     target_file=created_files.get("screen"),
        # )

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
