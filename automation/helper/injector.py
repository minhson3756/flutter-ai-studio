import os
import re


def _get_package_name(app_path: str) -> str:
    """Đọc tên package từ pubspec.yaml thay vì hardcode flutter_base."""
    pubspec_path = os.path.join(app_path, "pubspec.yaml")
    if os.path.exists(pubspec_path):
        with open(pubspec_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.strip().startswith("name:"):
                    return line.split(":", 1)[1].strip()
    return "flutter_base"


def to_snake_case(name):
    # Xử lý acronym (QR, URL, API) → giữ nguyên cụm viết tắt
    s1 = re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', name)
    s2 = re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', s1)
    return s2.lower()

def _ensure_router_base_imports(content: str, app_path: str) -> str:
    """Đảm bảo app_router.dart luôn có import flutter/material.dart (cho Key class trong .gr.dart)."""
    if "package:flutter/material.dart" not in content and "package:flutter/foundation.dart" not in content:
        # Chèn import flutter/material.dart sau import auto_route
        auto_route_idx = content.find("import 'package:auto_route/auto_route.dart';")
        if auto_route_idx != -1:
            end_line = content.find("\n", auto_route_idx)
            if end_line != -1:
                content = content[:end_line + 1] + "import 'package:flutter/material.dart';\n" + content[end_line + 1:]
        else:
            content = "import 'package:flutter/material.dart';\n" + content
    return content


def _ensure_router_model_imports(content: str, screen_code: str, app_path: str) -> str:
    """
    Scan screen constructor để tìm types từ shared models.
    Nếu screen dùng types như QRCodeType, HistoryItemModel, etc. trong constructor,
    auto_route sẽ cần import chúng trong app_router.dart.
    """
    pkg = _get_package_name(app_path)
    models_dir = os.path.join(app_path, "lib", "src", "shared", "models")

    if not os.path.isdir(models_dir):
        return content

    # Lấy danh sách tất cả model files và các class/enum chúng export
    model_types = {}  # type_name -> import_path
    for fname in os.listdir(models_dir):
        if not fname.endswith(".dart") or fname.endswith(".g.dart") or fname.endswith(".freezed.dart"):
            continue
        model_path = os.path.join(models_dir, fname)
        try:
            with open(model_path, "r", encoding="utf-8") as f:
                model_content = f.read()
            # Tìm tất cả class và enum declarations
            for match in re.finditer(r'(?:class|enum)\s+(\w+)', model_content):
                type_name = match.group(1)
                model_types[type_name] = f"package:{pkg}/src/shared/models/{fname}"
        except Exception:
            continue

    # Scan screen code để tìm types được dùng
    needed_imports = set()
    for type_name, import_path in model_types.items():
        # Check nếu type xuất hiện trong screen constructor (required TypeName param)
        if re.search(rf'\b{re.escape(type_name)}\b', screen_code):
            if import_path not in content:
                needed_imports.add(import_path)

    # Thêm missing imports
    for imp in sorted(needed_imports):
        import_stmt = f"import '{imp}';\n"
        if imp not in content:
            last_import_idx = content.rfind("import ")
            if last_import_idx != -1:
                end_of_last_import = content.find(";\n", last_import_idx)
                if end_of_last_import != -1:
                    insert_pos = end_of_last_import + 2
                    content = content[:insert_pos] + import_stmt + content[insert_pos:]

    return content


def update_app_router(app_path, feature_name, snake_name):
    router_path = os.path.join(app_path, "lib", "src", "config", "navigation", "app_router.dart")

    if not os.path.exists(router_path):
        print(f"⚠️ Cảnh báo: Không tìm thấy {router_path}. Bỏ qua tự động thêm Route.")
        return

    with open(router_path, "r", encoding="utf-8") as f:
        content = f.read()

    # 🌟 ĐẢM BẢO BASE IMPORTS (flutter/material.dart cho Key class)
    content = _ensure_router_base_imports(content, app_path)

    # TỰ ĐỘNG THÊM IMPORT VÀO ĐẦU FILE
    pkg = _get_package_name(app_path)
    import_stmt = f"import 'package:{pkg}/src/presentation/{snake_name}/{snake_name}_screen.dart';\n"
    # Kiểm tra an toàn hơn để tránh import trùng lặp
    if f"/{snake_name}/{snake_name}_screen.dart" not in content:
        last_import_idx = content.rfind("import ")
        if last_import_idx != -1:
            end_of_last_import = content.find(";\n", last_import_idx)
            if end_of_last_import != -1:
                insert_pos = end_of_last_import + 2
                content = content[:insert_pos] + import_stmt + content[insert_pos:]
        else:
            # Nếu chưa có bất kỳ import nào, chèn lên đầu tiên
            content = import_stmt + content

    # 🌟 THÊM IMPORT SHARED MODELS NẾU SCREEN DÙNG TYPES TỪ MODELS
    screen_path = os.path.join(
        app_path, "lib", "src", "presentation", snake_name, f"{snake_name}_screen.dart"
    )
    if os.path.exists(screen_path):
        with open(screen_path, "r", encoding="utf-8") as f:
            screen_code = f.read()
        content = _ensure_router_model_imports(content, screen_code, app_path)

    # 🌟 FIX REGEX: TỰ ĐỘNG THÊM ROUTE VÀO DANH SÁCH (Hỗ trợ cả <AutoRoute>[ và [ )
    route_stmt = f"\n    AutoRoute(page: {feature_name}Route.page),"
    if f"{feature_name}Route.page" not in content:
        # Dùng Regex để tìm vị trí mảng routes linh hoạt hơn
        match = re.search(r'get\s+routes\s*=>\s*(?:<AutoRoute>)?\s*\[', content)
        if match:
            insert_pos = match.end()
            content = content[:insert_pos] + route_stmt + content[insert_pos:]

    with open(router_path, "w", encoding="utf-8") as f:
        f.write(content)

def validate_generated_code(code_dict, feature_name):
    screen = (code_dict.get("screen") or "").strip()
    cubit = (code_dict.get("cubit") or "").strip()
    state = (code_dict.get("state") or "").strip()

    if not screen:
        raise ValueError(f"{feature_name}: missing screen code")

    # Check: nếu screen import cubit/state nhưng AI không return code → lỗi
    if "cubit/" in screen and "_cubit.dart" in screen and not cubit:
        raise ValueError(f"{feature_name}: screen imports cubit nhưng <cubit> tag trống! AI phải sinh đủ cả cubit.")
    if "cubit/" in screen and "_state.dart" in screen and not state:
        raise ValueError(f"{feature_name}: screen imports state nhưng <state> tag trống! AI phải sinh đủ cả state.")

    # Check: nếu state dùng freezed thì part directive phải khớp
    if state and "freezed" in state:
        import re as _re
        _part_match = _re.search(r"part\s+'([^']+)'", state)
        if _part_match:
            _part_name = _part_match.group(1)
            # Tên file state nên là feature_name_state.freezed.dart
            _snake = _re.sub(r'([A-Z]+)([A-Z][a-z])', r'\1_\2', feature_name)
            _snake = _re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', _snake).lower()
            _expected = f"{_snake}_state.freezed.dart"
            if _part_name != _expected:
                print(f"      ⚠️ Freezed part mismatch: got '{_part_name}', expected '{_expected}'")

    banned_patterns = [
        "<plan>", "</plan>", "###", "**", "Final decision", "Thực ra", "Let me now"
    ]

    all_parts = "\n".join([screen, cubit, state])
    for p in banned_patterns:
        if p in all_parts:
            raise ValueError(f"{feature_name}: AI leaked commentary into code: {p}")

    if "class " not in screen and "@RoutePage()" not in screen:
        raise ValueError(f"{feature_name}: screen file does not look like Dart screen")

    # Check + Auto-fix: import nằm giữa file thay vì đầu file
    import re as _re

    def _auto_fix_misplaced_imports(code: str) -> str:
        """Di chuyển tất cả import và part statements lên đầu file."""
        lines = code.split("\n")
        imports = []
        parts = []
        other_lines = []
        for line in lines:
            stripped = line.strip()
            if stripped.startswith("import "):
                imports.append(line)
            elif stripped.startswith("part "):
                parts.append(line)
            else:
                other_lines.append(line)
        if not imports:
            return code
        # Rebuild: imports → parts → rest
        result_lines = imports + [""] + parts + [""] + other_lines if parts else imports + [""] + other_lines
        return "\n".join(result_lines)

    # Check + Auto-fix cho từng phần code riêng
    for _label, _code_key in [("screen", "screen"), ("cubit", "cubit"), ("state", "state")]:
        _code = code_dict.get(_code_key, "") or ""
        if not _code:
            continue
        _lines_check = _code.split("\n")
        _found_non_import = False
        _has_misplaced = False
        for _line in _lines_check:
            _stripped = _line.strip()
            if not _stripped or _stripped.startswith("//"):
                continue
            if _stripped.startswith("import ") or _stripped.startswith("part "):
                if _found_non_import:
                    _has_misplaced = True
                    break
            elif _stripped.startswith("class ") or _stripped.startswith("@") or _stripped.startswith("enum ") or _stripped.startswith("mixin "):
                _found_non_import = True
        if _has_misplaced:
            print(f"      🔧 {feature_name}/{_label}: import nằm sai vị trí — auto-fixing...")
            code_dict[_code_key] = _auto_fix_misplaced_imports(_code)

    # Check + Auto-fix: file bị truncate (không có closing brace cuối cùng)
    for _label, _code_key in [("screen", "screen"), ("cubit", "cubit"), ("state", "state")]:
        _code = (code_dict.get(_code_key) or "").strip()
        if not _code:
            continue
        _open_braces = _code.count("{")
        _close_braces = _code.count("}")
        if _open_braces > _close_braces:
            _missing = _open_braces - _close_braces
            print(f"      🔧 {feature_name}/{_label}: file bị truncate (thiếu {_missing} '}}') — auto-fixing...")
            code_dict[_code_key] = _code + "\n" + ("}\n" * _missing)

    # Reload sau auto-fix
    screen = (code_dict.get("screen") or "").strip()
    cubit = (code_dict.get("cubit") or "").strip()
    state = (code_dict.get("state") or "").strip()
    all_parts = "\n".join([screen, cubit, state])

    # Check: phantom import (import widget không tồn tại)
    _phantom_imports = [
        "shared/widgets/custom_button",
        "shared/widgets/custom_appbar",
        "shared/widgets/custom_text_field",
        "shared/widgets/button/",
    ]
    for _phantom in _phantom_imports:
        if _phantom in all_parts:
            print(f"      ⚠️ {feature_name}: phantom import detected: {_phantom} — stripping...")
            # Auto-fix: xóa dòng import chứa phantom
            screen = "\n".join(l for l in screen.split("\n") if _phantom not in l)
            cubit = "\n".join(l for l in cubit.split("\n") if _phantom not in l)
            state = "\n".join(l for l in state.split("\n") if _phantom not in l)

    # Cập nhật lại code_dict sau auto-fix
    code_dict["screen"] = screen
    code_dict["cubit"] = cubit
    code_dict["state"] = state

    return True

def inject_to_flutter(app_path, feature_name, generated_code, is_sub_tab=False, parent_name=None):

    snake_name = to_snake_case(feature_name)
    parent_snake = to_snake_case(parent_name) if parent_name else "shared"

    def _clean_code(value):
        if value is None:
            return None
        value = str(value).strip()
        if value == "" or value.lower() == "none":
            return None
        return value

    screen_code = _clean_code(generated_code.get("screen"))
    cubit_code = _clean_code(generated_code.get("cubit"))
    state_code = _clean_code(generated_code.get("state"))

    # 🌟 ĐỊNH TUYẾN THƯ MỤC: Tách biệt Màn hình chính và Widget con
    if is_sub_tab:
        feature_dir = os.path.join(
            app_path, "lib", "src", "presentation", parent_snake, "widgets"
        )
        file_suffix = ".dart" if snake_name.endswith("_widget") else "_widget.dart"
    else:
        feature_dir = os.path.join(
            app_path, "lib", "src", "presentation", snake_name
        )
        file_suffix = ".dart" if snake_name.endswith("_screen") else "_screen.dart"

    os.makedirs(feature_dir, exist_ok=True)

    # 🌟 QUY TẮC BẮT BUỘC:
    # - Màn hình chính phải luôn có screen
    # - Với màn hình chính, nếu có state management thì phải đủ cả cubit + state
    # - Widget con không bắt buộc cubit/state
    #
    # Heuristic đơn giản:
    # - Nếu là sub widget: không bắt buộc cubit/state
    # - Nếu là screen chính: yêu cầu đủ cubit + state
    #   (nếu sau này muốn nới lỏng cho splash/static screen thì thêm allowlist ở đây)
    if not screen_code:
        raise ValueError(f"{feature_name}: missing screen code")

    if not is_sub_tab:
        if bool(cubit_code) != bool(state_code):
            raise ValueError(f"{feature_name}: Thiếu đồng bộ! Nếu dùng State Management thì phải có cả cubit và state.")

    created_files = {}

    # 1) Ghi screen/widget
    screen_path = os.path.join(feature_dir, f"{snake_name}{file_suffix}")
    with open(screen_path, "w", encoding="utf-8") as f:
        f.write(screen_code)
    created_files["screen"] = screen_path

    # 2) Ghi cubit/state nếu có
    #    Tên file được suy ra từ import trong screen code (ưu tiên) hoặc fallback về snake_name
    if cubit_code or state_code:
        cubit_dir = os.path.join(feature_dir, "cubit")
        os.makedirs(cubit_dir, exist_ok=True)

        # Suy tên file từ screen imports để tránh mismatch
        cubit_filename = f"{snake_name}_cubit.dart"
        state_filename = f"{snake_name}_state.dart"
        if screen_code:
            cubit_import_match = re.search(r"import\s+'cubit/([^']+_cubit\.dart)'", screen_code)
            state_import_match = re.search(r"import\s+'cubit/([^']+_state\.dart)'", screen_code)
            if cubit_import_match:
                cubit_filename = cubit_import_match.group(1)
            if state_import_match:
                state_filename = state_import_match.group(1)

        if cubit_code:
            cubit_path = os.path.join(cubit_dir, cubit_filename)
            with open(cubit_path, "w", encoding="utf-8") as f:
                f.write(cubit_code)
            created_files["cubit"] = cubit_path

        if state_code:
            state_path = os.path.join(cubit_dir, state_filename)
            with open(state_path, "w", encoding="utf-8") as f:
                f.write(state_code)
            created_files["state"] = state_path

    # 3) Tự động thêm route cho màn hình chính
    if not is_sub_tab:
        update_app_router(app_path, feature_name, snake_name)
        print(f"   ✅ Đã tạo Screen và tự động cấu hình {feature_name}Route vào app_router.dart")
    else:
        print(f"   ✅ Đã tạo Widget con tại: presentation/{parent_snake}/widgets/{snake_name}{file_suffix}")

    return created_files