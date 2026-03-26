import json
import os
import re
import shutil
import subprocess
from typing import Dict, List, Tuple, Any

from automation.ai.ai_model_generator import generate_global_models
from automation.ai.ai_palette_and_i18n import generate_screen_translations
from automation.ai.ai_screen_generator import fix_flutter_code_agent
from automation.helper.code_contracts import (
    extract_flutter_models,
    extract_generated_constructors,
    extract_route_contracts,
    validate_constructor_and_route_usage,
)
from automation.helper.injector import validate_generated_code
from automation.helper.screen_analysis import get_used_assets
from automation.helper.utils import read_file, write_file


def prepare_global_translations(
        new_app_path: str,
        screens: List[dict],
        detected_languages: List[dict],
        build_cache: Dict[str, Any],
        cache_path: str,
        update_arb_files_fn,
) -> Tuple[Dict[str, str], Dict[str, Dict[str, str]], Dict[str, Any]]:
    """
    Dịch toàn bộ text của app, cache theo hash, và cập nhật file ARB.
    """
    all_app_texts = set()
    for screen in screens:
        for txt in screen.get("all_texts", []) or []:
            clean_txt = str(txt).strip()
            if clean_txt:
                all_app_texts.add(clean_txt)

    global_keys_mapping = {}
    translations_merged = {}

    if not all_app_texts:
        print("   -> Không có text nào để dịch.")
        return global_keys_mapping, translations_merged, build_cache

    text_list = sorted(list(all_app_texts))
    texts_hash = __import__("hashlib").md5(
        json.dumps(text_list, ensure_ascii=False).encode("utf-8")
    ).hexdigest()

    if build_cache.get("global_texts_hash") == texts_hash and "translations" in build_cache:
        print("   ⚡ [CACHE HIT] Không có text mới, bỏ qua gọi AI dịch thuật.")
        global_keys_mapping = build_cache["translations"].get("keys_mapping", {})
        translations_merged = build_cache["translations"].get("merged", {})

        if translations_merged:
            update_arb_files_fn(new_app_path, translations_merged)

        print(f"   ✅ Đã tạo/cập nhật {len(global_keys_mapping)} keys dịch thuật cho toàn App.")
        return global_keys_mapping, translations_merged, build_cache

    lang_codes = [lang.get("code") for lang in detected_languages if lang.get("code")]
    batch_size = 10
    total_batches = (len(text_list) - 1) // batch_size + 1

    for i in range(0, len(text_list), batch_size):
        batch = text_list[i:i + batch_size]
        print(f"   🔄 Đang dịch batch {i // batch_size + 1}/{total_batches} ({len(batch)} texts)...")
        try:
            trans_result = generate_screen_translations(batch, lang_codes)
            global_keys_mapping.update(trans_result.get("keys_mapping", {}))

            for lang_code, lang_data in trans_result.get("translations", {}).items():
                if lang_code not in translations_merged:
                    translations_merged[lang_code] = {}
                translations_merged[lang_code].update(lang_data)
        except Exception as e:
            print(f"   ⚠️ Lỗi dịch batch: {e}")

    if translations_merged:
        update_arb_files_fn(new_app_path, translations_merged)

    build_cache["global_texts_hash"] = texts_hash
    build_cache["translations"] = {
        "keys_mapping": global_keys_mapping,
        "merged": translations_merged,
    }
    with open(cache_path, "w", encoding="utf-8") as f:
        json.dump(build_cache, f, ensure_ascii=False, indent=2)

    print(f"   ✅ Đã tạo/cập nhật {len(global_keys_mapping)} keys dịch thuật cho toàn App.")
    return global_keys_mapping, translations_merged, build_cache


def prepare_global_models(
        new_app_path: str,
        spec_content: str,
        screens: List[dict],
) -> None:
    """
    Tạo các file model dùng chung theo nhiều file.
    """
    models_dir = os.path.join(new_app_path, "lib", "src", "shared", "models")
    os.makedirs(models_dir, exist_ok=True)

    existing_model_files = [f for f in os.listdir(models_dir) if f.endswith(".dart")]
    if existing_model_files:
        print(f"   -> ✅ Models đã tồn tại: {len(existing_model_files)} file.")
        return

    print("\n🧠 AI Architect đang tự suy luận và chia Data Models thành nhiều file...")
    screen_names = [s.get("raw_name") or s.get("name") for s in screens]
    model_files = generate_global_models(spec_content, str(screen_names))

    written_count = 0
    for item in model_files:
        file_name = os.path.basename((item.get("name") or "").strip())
        file_content = (item.get("content") or "").strip()

        if not file_name or not file_content:
            continue

        model_path = os.path.join(models_dir, file_name)
        with open(model_path, "w", encoding="utf-8") as f:
            f.write(file_content)

        written_count += 1
        print(f"   ✅ Đã tạo model file: shared/models/{file_name}")

    print(f"   ✅ Hoàn tất tạo {written_count} file model.")


def load_dynamic_ai_context(new_app_path: str) -> Dict[str, str]:
    """
    Đọc context động từ codebase hiện tại để nhét vào prompt AI.
    """
    print("\n🔍 Đang quét Data Models để nạp vào bộ nhớ AI UI...")
    dynamic_models_context = extract_flutter_models(new_app_path)
    if dynamic_models_context:
        print("   ✅ Đã nạp thành công các Data Models vào bộ nhớ chung.")

    return {
        "models_context": dynamic_models_context,
        "constructors_context": extract_generated_constructors(new_app_path),
        "route_contracts": extract_route_contracts(new_app_path),
    }


def refresh_dynamic_ai_context(new_app_path: str, current_context: Dict[str, str]) -> Dict[
    str, str]:
    """
    Refresh context sau khi đã sinh thêm screen mới.
    """
    current_context["constructors_context"] = extract_generated_constructors(new_app_path)
    current_context["route_contracts"] = extract_route_contracts(new_app_path)
    return current_context


def build_asset_instructions(
        screen_node: dict,
        img_dict: dict[str, str],
        icon_dict: dict[str, str],
) -> str:
    used_imgs, used_icns = get_used_assets(screen_node, img_dict, icon_dict)

    # Cũng quét assets trong variant secondary frames
    for variant in screen_node.get("variants", []):
        v_imgs, v_icns = get_used_assets(variant, img_dict, icon_dict)
        used_imgs.update(v_imgs)
        used_icns.update(v_icns)

    asset_instructions = ""
    if used_imgs:
        img_lines = "\n".join([f"- assets/images/{img}" for img in sorted(used_imgs)])
        asset_instructions += f"\n[HÌNH ẢNH ĐƯỢC PHÉP DÙNG TRONG SCREEN NÀY]:\n{img_lines}\n"

    if used_icns:
        icon_lines = "\n".join([f"- assets/icons/{icon}" for icon in sorted(used_icns)])
        asset_instructions += f"\n[ICONS ĐƯỢC PHÉP DÙNG TRONG SCREEN NÀY]:\n{icon_lines}\n"

    asset_instructions += """
[QUY TẮC ASSET]:
- CHỈ được dùng đúng asset path đã liệt kê ở trên.
- TUYỆT ĐỐI KHÔNG tự đoán tên getter của flutter_gen.
- Nếu không chắc getter generated tồn tại, hãy dùng trực tiếp path string:
  + SvgPicture.asset('assets/icons/xxx.svg')
  + Image.asset('assets/images/xxx.png')
- KHÔNG được tự đổi tên file asset.
- KHÔNG được dùng asset nào không xuất hiện trong danh sách được phép.
"""

    return asset_instructions


def build_l10n_instructions(
        screen_node: dict,
        global_keys_mapping: dict[str, str],
) -> str:
    if not global_keys_mapping:
        return ""

    # Lọc keys liên quan đến screen này (exact match + case-insensitive match)
    screen_texts = screen_node.get("all_texts", []) or []
    screen_texts_lower = {t.strip().lower() for t in screen_texts if t and t.strip()}

    matched_keys = {}
    for raw_text, key_name in global_keys_mapping.items():
        if raw_text in screen_texts:
            matched_keys[raw_text] = key_name
        elif raw_text.strip().lower() in screen_texts_lower:
            matched_keys[raw_text] = key_name

    l10n_instructions = """
🚨 [QUY TẮC ĐA NGÔN NGỮ - BẮT BUỘC]:
- CẤM TUYỆT ĐỐI hardcode text trên UI. Mọi text hiển thị cho người dùng PHẢI dùng localization.
- Sử dụng: AppLocalizations.of(context)!.keyName
- Khai báo biến: final l10n = AppLocalizations.of(context)!; rồi dùng l10n.keyName
- Import: import 'package:flutter_base/src/gen/l18n/app_localizations.dart';
- Nếu text KHÔNG có trong mapping bên dưới → vẫn PHẢI tạo key hợp lý và dùng localization.
"""

    if matched_keys:
        l10n_instructions += "\n[MAPPING TEXT → KEY cho màn hình này]:\n"
        for txt in sorted(matched_keys.keys()):
            l10n_instructions += f'- "{txt}" => l10n.{matched_keys[txt]}\n'
    else:
        l10n_instructions += "\n⚠️ Không tìm thấy mapping cụ thể cho screen này, nhưng VẪN PHẢI dùng localization cho mọi text.\n"

    # Cung cấp danh sách keys phổ biến (giới hạn 50 keys, tiết kiệm token)
    common_keys = {k: v for k, v in global_keys_mapping.items()
                   if len(k) < 50 and not k[0].isdigit()}
    if common_keys:
        limited = dict(sorted(common_keys.items())[:50])
        l10n_instructions += f"\n[LOCALIZATION KEYS CÓ SẴN (top {len(limited)} keys, tham khảo)]:\n"
        for txt in sorted(limited.keys()):
            l10n_instructions += f'- "{txt}" => l10n.{limited[txt]}\n'
        if len(common_keys) > 50:
            l10n_instructions += f"... và {len(common_keys) - 50} keys khác.\n"

    return l10n_instructions


def build_special_logic_instructions(
        screen_node: dict,
        base_name: str,
) -> str:
    special_logic_instructions = """
[CONTRACT APP CÓ SẴN]:
- App ĐÃ CÓ sẵn LanguageCubit / cơ chế đổi ngôn ngữ toàn app.
- TUYỆT ĐỐI KHÔNG tạo LanguageCubit mới, LanguageState mới, hay logic quản lý locale mới.
- Nếu màn hình cần đổi ngôn ngữ, chỉ được dùng cubit/service ngôn ngữ đã tồn tại của app.
- Với enum Language: chỉ cập nhật số lượng ngôn ngữ trong file enum hiện có. Không tạo model/cubit ngôn ngữ mới.
- Với các thư viện cần khởi tạo trước app (ví dụ hive_ce), KHÔNG được tự khởi tạo trong screen.
- KHÔNG được tạo bootstrap/app-init logic bên trong UI screen.
"""

    if screen_node.get("is_shell_screen"):
        special_logic_instructions += f"""
[KỶ LUẬT SHELL SCREEN]:
- Đây là màn hình cha chứa tab/widget con.
- TÊN CLASS BẮT BUỘC: `{base_name}`
- Nếu cần nhúng widget con, CHỈ được truyền các tham số xuất hiện trong CONTRACT hệ thống.
- Nếu constructor widget con rỗng thì CẤM truyền bất kỳ param nào.
- TUYỆT ĐỐI KHÔNG tự bịa tên param như: title, item, data, model, scannedData, parsedFields...
- Có thể dùng Scaffold nếu đây là màn hình cha thực sự.
"""

    is_sub = screen_node.get("is_sub_tab", False)
    parent_name = screen_node.get("parent_name")

    if is_sub:
        special_logic_instructions += f"""
[KỶ LUẬT TAB CON / WIDGET CON]:
- Đây là Component con nằm trong `widgets` của màn hình `{parent_name}`.
- TÊN CLASS BẮT BUỘC: `{base_name}`
- KHÔNG ĐƯỢC THÊM `@RoutePage()` vào file này.
- KHÔNG tạo `Scaffold`, `AppBar`, `BottomNavigationBar`.
- Chỉ return nội dung widget.
- CHỈ được nhận các tham số nằm trong CONTRACT hệ thống.
- Nếu chưa có contract rõ ràng thì constructor phải để rỗng.
- NẾU constructor rỗng thì màn hình cha CẤM truyền bất kỳ param nào.
- TUYỆT ĐỐI KHÔNG tự bịa tên param như: title, item, data, model, scannedData, parsedFields...
"""

    return special_logic_instructions


def build_variant_instructions(screen_node: dict) -> str:
    """
    Nếu màn đang là 1 variant cụ thể như __page=barcode thì chỉ implement variant đó,
    tránh AI sinh toàn bộ các page trong một response.
    """
    variant_instructions = ""

    raw_name = (screen_node.get("raw_name") or screen_node.get("name") or "").strip()
    state_tags = screen_node.get("state_tags", {}) or {}
    variants = screen_node.get("variants", []) or []

    if state_tags:
        tag_text = ", ".join([f"{k}={v}" for k, v in state_tags.items()])
        variant_instructions += "\n[CURRENT UI VARIANT TO IMPLEMENT]:\n"
        variant_instructions += f"- raw_name: {raw_name}\n"
        variant_instructions += f"- state_tags: {tag_text}\n"
        variant_instructions += (
            "- CHỈ implement đúng variant hiện tại này.\n"
            "- KHÔNG implement tất cả page/variant khác trong cùng một response.\n"
            "- KHÔNG render 9 màn hình trong 1 file.\n"
            "- Nếu đây là form động hoặc màn kết quả động, chỉ build UI đúng cho variant hiện tại.\n"
            "- ƯU TIÊN code ngắn, đúng, compile được.\n"
        )
        return variant_instructions

    if variants:
        variant_instructions += "\n[UI VARIANTS / STATES CỦA MÀN HÌNH NÀY]:\n"
        variant_instructions += (
            "- Đây là CÙNG MỘT SCREEN với nhiều trạng thái nội bộ.\n"
            "- KHÔNG tạo route mới cho từng variant.\n"
            "- Nếu số variant lớn, CHỈ implement logic gọn cho variant hiện tại hoặc logic tối giản.\n"
            "- Nếu khác nhau ở bottomTab, subTab, dataState, menuState, selectionState, overlayState thì đó là state của cùng một màn.\n"
        )

        max_show = 4
        for idx, variant in enumerate(variants[:max_show], start=1):
            tags = variant.get("state_tags", {}) or {}
            tag_text = ", ".join([f"{k}={v}" for k, v in tags.items()]) if tags else "no_state_tags"
            variant_instructions += f"  {idx}. {variant.get('raw_name', 'Unnamed')} -> {tag_text}\n"

        if len(variants) > max_show:
            variant_instructions += f"  ... và còn {len(variants) - max_show} variants khác.\n"
            variant_instructions += "- KHÔNG cần viết full UI chi tiết cho tất cả variants trong một response.\n"

    return variant_instructions


def build_screen_context(
        spec_content: str,
        dynamic_ai_context: dict[str, str],
        asset_instructions: str,
        l10n_instructions: str,
        special_logic_instructions: str,
        variant_instructions: str,
        route_list: str,
        palette_rules: str = "",
        palette_content: str = "",
) -> str:
    UI_FIDELITY_RULES = """
[QUY TẮC ĐỘ CHÍNH XÁC UI]:
- BẮT BUỘC bám sát border, border radius, shadow, spacing, opacity, stroke nếu dữ liệu Figma có cung cấp.
- Không được bỏ qua border/shadow chỉ vì UI vẫn nhìn gần giống.
- Nếu node có effects/strokes/cornerRadius thì phải phản ánh vào Flutter UI.
"""

    CONTRACT_HARD_RULES = """
[QUY TẮC CONTRACT]:
- Screen chỉ được dùng các field thực sự tồn tại trong State/Cubit contract.
- Nếu cần field mới trong State thì phải đồng thời cập nhật file state và cubit tương ứng.
- Không được tự bịa getter như value, dateDisplay, timeDisplay, isCopySuccess nếu chưa có trong contract.
- KHÔNG được tự bịa route không có trong route contracts.
- CHỈ được navigate tới route nằm trong [DANH SÁCH ROUTE HỢP LỆ].
- Nếu không chắc route đích tồn tại, KHÔNG được điều hướng.
"""

    COMPLEX_SCREEN_RULES = """
[QUY TẮC CHO MÀN HÌNH NHIỀU VARIANT]:
- Nếu raw_name hoặc state_tags chỉ ra 1 variant cụ thể (ví dụ page=barcode), thì CHỈ implement variant đó.
- KHÔNG được code toàn bộ 9 page/variant trong cùng một response.
- ƯU TIÊN code ngắn gọn, compile được, đúng variant hiện tại.
"""

    NAVIGATION_RULES = f"""
[QUY TẮC ĐIỀU HƯỚNG]:
- DANH SÁCH ROUTE HỢP LỆ DUY NHẤT:
{route_list}

- CHỈ được dùng đúng các route ở danh sách trên.
- Nếu hành động trên UI không có route hợp lệ tương ứng, hãy:
  + giữ callback trống an toàn, hoặc
  + gọi pop/back nếu phù hợp,
  + nhưng KHÔNG được tạo route mới.
"""

    return f"""
YÊU CẦU NGHIỆP VỤ (BẮT BUỘC TUÂN THỦ):
{spec_content}

{dynamic_ai_context.get("models_context", "")}
{dynamic_ai_context.get("constructors_context", "")}
{dynamic_ai_context.get("route_contracts", "")}

{UI_FIDELITY_RULES}
{CONTRACT_HARD_RULES}
{COMPLEX_SCREEN_RULES}
{NAVIGATION_RULES}

{variant_instructions}

{asset_instructions}
{l10n_instructions}
{special_logic_instructions}
{palette_rules}
{('[NỘI DUNG THỰC TẾ CỦA palette.dart - CHỈ ĐƯỢC DÙNG CÁC THUỘC TÍNH CÓ TRONG ĐÂY]:' + chr(10) + palette_content) if palette_content else ''}

[CONTRACT PARAMS]:
- CHỈ được gọi Widget/Route bằng các tham số có trong CONTRACT hệ thống đã cung cấp.
- Nếu constructor/route rỗng: CẤM truyền tham số.
- TUYỆT ĐỐI KHÔNG tự bịa tên param như title, qrType, parsedFields, item, data, scannedData, model...

[QUY TẮC STATE MACHINE]:
- Nếu các frame chỉ khác nhau ở bottomTab, subTab, dropdown mở/đóng, selection mode, empty/loading/error
  thì đó là CÙNG MỘT SCREEN với nhiều UI STATE.
- KHÔNG tạo route mới cho các state này.
- PHẢI suy luận state nội bộ từ variants/state_tags đã cung cấp.
"""

def _flutter_cmd() -> List[str]:
    """
    Trả về lệnh flutter phù hợp với môi trường:
    - Nếu có `fvm` trong PATH → dùng ["fvm", "flutter"]
    - Ngược lại → dùng ["flutter"]
    Có thể override bằng env FLUTTER_CMD="fvm flutter" hoặc "flutter".
    """
    env_override = os.environ.get("FLUTTER_CMD", "").strip()
    if env_override:
        return env_override.split()
    if shutil.which("fvm"):
        return ["fvm", "flutter"]
    return ["flutter"]


def install_ai_packages(
        code: dict,
        new_app_path: str,
) -> set[str]:
    """
    Chỉ auto-add runtime packages an toàn.
    Tuyệt đối không add generator/dev packages.
    """
    raw_pkg_text = (code.get("packages") or "").strip()
    raw_pkg_list = [p.strip() for p in raw_pkg_text.splitlines() if p.strip()]
    raw_pkg_list = [p for p in raw_pkg_list if not p.startswith("//")]

    if not raw_pkg_list:
        return set()

    pkg_set = set()
    for p in raw_pkg_list:
        if "package:" in p:
            match = re.search(r"package:([^/]+)", p)
            if match:
                pkg_set.add(match.group(1).strip("';\" "))
        else:
            clean_p = p.split(":")[0].strip().replace("'", "").replace('"', "")
            if re.match(r"^[a-z0-9_+-]+$", clean_p):
                pkg_set.add(clean_p)

    ignore_pkgs = {
        "flutter",
        "flutter_base",
        "flutter_screenutil",
        "google_fonts",
        "flutter_bloc",
        "auto_route",
        "dart",
        "flutter_localizations",
        "shared_preferences_android",
        "shared_preferences_ios",
        "dependencies",
        "dev_dependencies",
        "environment",
        "name",
        "description",
        "version",
        "homepage",
        "dependency_overrides",
        "sdk",
        "build_runner",
        "freezed",
        "freezed_annotation",
        "json_serializable",
        "injectable_generator",
        "auto_route_generator",
        "flutter_gen_runner",
        "flutter_flavorizr",
        "yaml",
        "injectable",
        "get_it",
    }

    allowed_runtime_pkgs = {
        "flutter_svg",
        "share_plus",
        "intl",
        "qr_flutter",
        "barcode_widget",
        "mobile_scanner",
        "permission_handler",
        "image_picker",
        "image_gallery_saver_plus",
        "path_provider",
        "url_launcher",
        "hive_ce",
        "hive_ce_flutter",
        "hive_flutter",
        "video_player",
        "cached_network_image",
        "shimmer",
        "connectivity_plus",
        "package_info_plus",
        "device_info_plus",
        "dio",
        "http",
        "photo_view",
        "webview_flutter",
    }

    installed = set()

    for pkg in pkg_set:
        if pkg in ignore_pkgs:
            print(f"      ⏭️ Bỏ qua package bị cấm/không cần auto-add: {pkg}")
            continue

        if pkg not in allowed_runtime_pkgs:
            print(f"      ⏭️ Bỏ qua package không nằm trong allowlist: {pkg}")
            continue

        print(f"      📦 Đang tự động cài đặt thư viện: {pkg}...")
        try:
            result = subprocess.run(
                _flutter_cmd() + ["pub", "add", pkg],
                cwd=new_app_path,
                timeout=120,
                capture_output=True,
                text=True,
            )
            if result.returncode == 0:
                installed.add(pkg)
            else:
                print(f"      ⚠️ flutter pub add {pkg} thất bại: {result.stderr.strip()[:200]}")
        except Exception as e:
            print(f"      ⚠️ Lỗi khi cài {pkg}: {e}")

    return installed

def validate_generated_bundle(
        new_app_path: str,
        code: dict,
        raw_name: str,
        route_list: str = "",
) -> None:
    validate_generated_code(code, raw_name)

    # Auto-fix deprecated withOpacity → withValues
    for key in ("screen", "cubit", "state"):
        if code.get(key):
            code[key] = re.sub(
                r'\.withOpacity\(([^)]+)\)',
                r'.withValues(alpha: \1)',
                code[key],
            )

    generated_bundle = "\n".join([
        code.get("screen", "") or "",
        code.get("cubit", "") or "",
        code.get("state", "") or "",
        ])

    validate_constructor_and_route_usage(
        app_path=new_app_path,
        screen_code=generated_bundle,
        feature_name=raw_name,
        allowed_route_names={
            r.strip() for r in route_list.split(",")
            if r.strip() and r.strip() != "Không có route nào"
        },
    )

    # Smart hardcoded text detection: tìm quoted strings > 1 char giống UI text
    _exclude_re = re.compile(
        r"assets/|fonts/|package:|\.dart|\.png|\.svg|\.json|\.ttf|\.otf|"
        r"Route\b|Screen\b|Cubit\b|State\b|http|/|_|\\|"
        r"^\d|^[A-Z_]+$|^0x|^#|cubit|state|context|widget"
    )
    _all_quoted = re.findall(r"'([^']{2,30}?)'", generated_bundle)
    _suspicious = [
        t for t in _all_quoted
        if not _exclude_re.search(t) and any(c.isalpha() for c in t)
    ]
    if _suspicious:
        # Deduplicate
        _suspicious = sorted(set(_suspicious))[:10]
        print(f"      ⚠️ Cảnh báo hardcoded text trong {raw_name}: {_suspicious}")

    # Validate import paths — cảnh báo nếu import tới file không tồn tại
    _import_re = re.compile(r"import\s+'package:(\w+)/(.+?)';")
    _bad_imports = []
    for _m in _import_re.finditer(generated_bundle):
        _pkg, _path = _m.group(1), _m.group(2)
        _full = os.path.join(new_app_path, "lib", _path)
        if not os.path.exists(_full) and "shared/widgets/" in _path:
            _bad_imports.append(_path)
    if _bad_imports:
        print(f"      ⚠️ Import tới file KHÔNG TỒN TẠI: {_bad_imports}")

    print("      ✅ Contract tham số và định tuyến khớp 100%.")


def analyze_and_fix_screen(
        new_app_path: str,
        target_file: str,
) -> None:
    if not target_file:
        return

    analyze_result = subprocess.run(
        _flutter_cmd() + ["analyze", target_file],
        cwd=new_app_path,
        capture_output=True,
        text=True,
    )

    if analyze_result.returncode != 0:
        print("      🛠️ Phát hiện lỗi analyzer, đang yêu cầu AI tự sửa...")
        fixed_code = fix_flutter_code_agent(
            read_file(target_file),
            analyze_result.stdout + "\n" + analyze_result.stderr,
        )

        if fixed_code:
            write_file(target_file, fixed_code)
            print("      ✅ Đã tự sửa file screen.")

    recheck_result = subprocess.run(
        _flutter_cmd() + ["analyze", target_file],
        cwd=new_app_path,
        capture_output=True,
        text=True,
    )

    if recheck_result.returncode != 0:
        raise ValueError(
            f"{os.path.basename(target_file)} vẫn còn lỗi sau auto-fix:\n"
            f"{recheck_result.stdout}\n{recheck_result.stderr}"
        )


def _parse_analyze_errors_by_file(analyze_output: str, app_path: str) -> Dict[str, List[str]]:
    """
    Parse output của `flutter analyze` và nhóm lỗi/warning theo file path tuyệt đối.
    Chỉ lấy error (bỏ qua warning và hint).
    Format dòng lỗi: "   error • message • lib/src/.../file.dart:line:col • code"
    """
    errors_by_file: Dict[str, List[str]] = {}
    # Chỉ xử lý dòng có "error •"
    for line in analyze_output.splitlines():
        stripped = line.strip()
        if not stripped.startswith("error •"):
            continue
        # Tách phần file path: "lib/src/.../file.dart:36:10"
        parts = stripped.split(" • ")
        if len(parts) < 3:
            continue
        file_ref = parts[2].strip()  # VD: "lib/src/presentation/foo/foo_screen.dart:36:10"
        file_path_rel = file_ref.split(":")[0]
        abs_path = os.path.join(app_path, file_path_rel)
        if not os.path.exists(abs_path):
            continue
        if abs_path not in errors_by_file:
            errors_by_file[abs_path] = []
        errors_by_file[abs_path].append(stripped)
    return errors_by_file


def _run_prepare_commands(new_app_path: str) -> None:
    """
    Chạy 3 lệnh chuẩn bị bắt buộc trước khi fix lỗi:
    1. pub get       – đồng bộ dependencies
    2. gen-l10n      – sinh file localization
    3. build_runner  – sinh code freezed/injectable/auto_route
    """
    flutter = _flutter_cmd()
    steps = [
        (flutter + ["pub", "get"],
         "pub get"),
        (flutter + ["gen-l10n"],
         "gen-l10n"),
        (flutter + ["pub", "run", "build_runner", "build", "--delete-conflicting-outputs"],
         "build_runner"),
    ]
    for cmd, label in steps:
        print(f"   ▶️  Đang chạy: {' '.join(cmd)}...")
        result = subprocess.run(cmd, cwd=new_app_path, capture_output=True, text=True)
        if result.returncode == 0:
            print(f"   ✅ {label} hoàn tất.")
        else:
            print(f"   ⚠️  {label} có lỗi:\n{(result.stdout + result.stderr)[:400]}")


def _is_generated_file(file_path: str) -> bool:
    """Kiểm tra file có phải auto-generated (không nên sửa trực tiếp)."""
    base = os.path.basename(file_path)
    return (
        base.endswith(".gr.dart")
        or base.endswith(".g.dart")
        or base.endswith(".freezed.dart")
        or base.endswith(".config.dart")
    )


def fix_all_analyze_errors(new_app_path: str, max_rounds: int = 3) -> bool:
    """
    Sau khi gen xong toàn bộ, chạy pub get + gen-l10n + build_runner trước,
    rồi flutter analyze toàn project, parse lỗi theo từng file, gọi AI sửa,
    lặp tối đa max_rounds vòng.
    Trả về True nếu không còn lỗi, False nếu vẫn còn sau max_rounds.
    """
    print(f"\n🔬 BẮT ĐẦU POST-GEN AUTO-FIX (tối đa {max_rounds} vòng)...")

    # Bước chuẩn bị: pub get → gen-l10n → build_runner
    print("\n   📦 Bước chuẩn bị trước khi fix...")
    _run_prepare_commands(new_app_path)

    flutter = _flutter_cmd()

    for round_num in range(1, max_rounds + 1):
        print(f"\n   🔄 Vòng {round_num}/{max_rounds}: Đang chạy flutter analyze...")
        result = subprocess.run(
            flutter + ["analyze"],
            cwd=new_app_path,
            capture_output=True,
            text=True,
        )

        if result.returncode == 0:
            print(f"   ✅ Không còn lỗi sau vòng {round_num - 1}. Project sạch!")
            return True

        errors_by_file = _parse_analyze_errors_by_file(
            result.stdout + "\n" + result.stderr,
            new_app_path,
        )

        if not errors_by_file:
            # Chỉ còn warning/hint, không có error → coi như OK
            print("   ✅ Không còn error (chỉ còn warning/hint). Project OK!")
            return True

        # Tách generated files ra khỏi danh sách cần fix
        generated_errors = {p: e for p, e in errors_by_file.items() if _is_generated_file(p)}
        source_errors = {p: e for p, e in errors_by_file.items() if not _is_generated_file(p)}

        if generated_errors:
            gen_names = [os.path.basename(p) for p in generated_errors]
            print(f"   ⏭️ Bỏ qua {len(generated_errors)} generated file (sẽ regenerate): {', '.join(gen_names)}")

        if not source_errors:
            if generated_errors:
                # Chỉ còn lỗi ở generated files → re-run build_runner rồi check lại
                print("   🔄 Chỉ còn lỗi ở generated files. Chạy lại build_runner...")
                _run_prepare_commands(new_app_path)
                continue
            print("   ✅ Không còn error source files. Project OK!")
            return True

        print(f"   ⚠️ Phát hiện lỗi trong {len(source_errors)} source file. Đang yêu cầu AI sửa...")

        fixed_count = 0
        for abs_path, file_errors in source_errors.items():
            file_name = os.path.relpath(abs_path, new_app_path)
            error_summary = "\n".join(file_errors)
            print(f"      🛠️ Đang sửa: {file_name} ({len(file_errors)} lỗi)...")

            file_content = read_file(abs_path)
            if not file_content:
                continue

            try:
                fixed_code = fix_flutter_code_agent(file_content, error_summary)
                if fixed_code and fixed_code.strip() != file_content.strip():
                    write_file(abs_path, fixed_code)
                    print(f"         ✅ Đã sửa: {os.path.basename(abs_path)}")
                    fixed_count += 1
                else:
                    print(f"         ⚠️ AI không thay đổi code: {os.path.basename(abs_path)}")
            except Exception as e:
                print(f"         ❌ Lỗi khi fix {os.path.basename(abs_path)}: {e}")

        if fixed_count == 0:
            print("   ⚠️ Không có file nào được sửa trong vòng này. Dừng sớm.")
            break

        # Sau khi fix source files, re-run build_runner để regenerate .gr.dart/.g.dart/.freezed.dart
        if generated_errors:
            print("   🔄 Re-run build_runner sau khi fix source files...")
            _run_prepare_commands(new_app_path)

        print(f"   ✅ Vòng {round_num}: Đã sửa {fixed_count} file. Chạy lại analyze...")

    # Kiểm tra lần cuối
    final = subprocess.run(
        flutter + ["analyze"],
        cwd=new_app_path,
        capture_output=True,
        text=True,
    )
    if final.returncode == 0:
        print("   🎉 Project không còn error!")
        return True

    remaining = _parse_analyze_errors_by_file(
        final.stdout + "\n" + final.stderr, new_app_path
    )
    if remaining:
        print(f"   ⚠️ Vẫn còn {sum(len(v) for v in remaining.values())} lỗi trong {len(remaining)} file sau {max_rounds} vòng fix.")
    return False


def finalize_project(new_app_path: str) -> None:
    flutter = _flutter_cmd()
    print(f"\n🛠️ Sử dụng lệnh Flutter: {' '.join(flutter)}")

    print("\n🛠️ Đang chạy build_runner hoàn thiện project...")
    br_result = subprocess.run(
        flutter + ["pub", "run", "build_runner", "build", "--delete-conflicting-outputs"],
        cwd=new_app_path,
        capture_output=True,
        text=True,
    )
    if br_result.returncode != 0:
        print(f"  ⚠️ build_runner có lỗi:\n{br_result.stderr[:500]}")
    else:
        print("  ✅ build_runner hoàn tất.")

    print("🌐 Đang biên dịch các file ngôn ngữ (gen-l10n)...")
    l10n_result = subprocess.run(
        flutter + ["gen-l10n"],
        cwd=new_app_path,
        capture_output=True,
        text=True,
    )
    if l10n_result.returncode != 0:
        print(f"  ⚠️ gen-l10n có lỗi:\n{l10n_result.stderr[:500]}")
    else:
        print("  ✅ gen-l10n hoàn tất.")

    # Auto-fix toàn bộ lỗi analyze sau khi codegen xong
    success = fix_all_analyze_errors(new_app_path, max_rounds=3)

    if success:
        print(f"\n🎉 THÀNH CÔNG! App của bạn đã sẵn sàng tại: {new_app_path}")
    else:
        print(f"\n⚠️ App đã gen xong nhưng vẫn còn một số lỗi. Kiểm tra Dart Analysis để xem chi tiết.")
        print(f"   Path: {new_app_path}")
