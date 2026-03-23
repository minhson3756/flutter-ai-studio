import os
import re


def _get_pkg_name(app_path: str) -> str:
    """Đọc tên package từ pubspec.yaml."""
    pubspec_path = os.path.join(app_path, "pubspec.yaml")
    if os.path.exists(pubspec_path):
        with open(pubspec_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.strip().startswith("name:"):
                    return line.split(":", 1)[1].strip()
    return "flutter_base"


def extract_flutter_models(app_path: str) -> str:
    """
    Quét thư mục shared/models để trích xuất cấu trúc model ngắn gọn cho AI.
    Chỉ đưa vào prompt những gì cần thiết: tên class, field, import path.
    """
    models_dir = os.path.join(app_path, "lib", "src", "shared", "models")
    if not os.path.exists(models_dir):
        return ""

    lines = [
        "🚨 [DATA MODELS ĐANG CÓ TRONG HỆ THỐNG]:",
        "CHỈ được dùng các model dưới đây. Không tự bịa model hoặc field mới.",
        "",
    ]

    found_models = False

    for root, _, files in os.walk(models_dir):
        for file in files:
            if not file.endswith(".dart"):
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
            except Exception:
                continue

            class_matches = re.finditer(
                r'class\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:extends|implements|\{)',
                content,
            )

            for match in class_matches:
                class_name = match.group(1)

                fields = re.findall(
                    r'(?:final\s+)?([A-Za-z0-9_<>,? ]+)\s+([A-Za-z0-9_]+)\s*;',
                    content,
                )

                if not fields:
                    continue

                fields_str = ", ".join(
                    [f"{type_name.strip()} {field_name}" for type_name, field_name in fields]
                )
                rel_import = f"package:{_get_pkg_name(app_path)}/src/shared/models/{file}"

                lines.append(f"- {class_name}({fields_str})")
                lines.append(f"  import: {rel_import}")
                found_models = True

    return "\n".join(lines).strip() if found_models else ""


def extract_generated_constructors(app_path: str) -> str:
    """
    Quét Screen/Widget đã gen để tạo contract constructor.
    Hỗ trợ:
    - const / non-const
    - named params
    - positional params
    - constructor nhiều dòng
    """
    presentation_dir = os.path.join(app_path, "lib", "src", "presentation")
    if not os.path.exists(presentation_dir):
        return ""

    lines = [
        "🚨 [HỢP ĐỒNG CONSTRUCTOR CỦA CÁC WIDGET/SCREEN ĐÃ GEN]:",
        "Khi bạn nhúng widget hoặc gọi screen đã tồn tại, CHỈ được truyền đúng tham số xuất hiện trong constructor dưới đây.",
        "Nếu constructor rỗng thì CẤM truyền bất kỳ tham số nào.",
        "",
    ]

    found = False

    for root, _, files in os.walk(presentation_dir):
        for file in files:
            if not file.endswith(".dart"):
                continue
            if "_screen" not in file and "_widget" not in file:
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
            except Exception:
                continue

            class_matches = re.finditer(
                r'class\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:extends|with|implements|\{)',
                content,
            )

            for class_match in class_matches:
                class_name = class_match.group(1)

                ctor_match = re.search(
                    rf'((?:const\s+)?{re.escape(class_name)}\s*\((.*?)\)\s*;)',
                    content,
                    re.DOTALL,
                )

                if not ctor_match:
                    continue

                ctor_full = re.sub(r"\s+", " ", ctor_match.group(1)).strip()
                params_raw = (ctor_match.group(2) or "").strip()

                lines.append(f"- {class_name}: `{ctor_full}`")

                if not params_raw:
                    lines.append("  => Constructor rỗng. CẤM truyền tham số.")
                else:
                    allowed_named, _ = _extract_named_params_from_signature(params_raw)
                    if allowed_named:
                        lines.append(
                            f"  => Named params hợp lệ: {', '.join(sorted(allowed_named))}"
                        )
                    else:
                        lines.append(
                            "  => Có positional params hoặc pattern đặc biệt. Phải bám đúng constructor ở trên, không được tự đổi tên biến."
                        )

                lines.append("")
                found = True

    return "\n".join(lines).strip() if found else ""


def extract_route_contracts(app_path: str) -> str:
    """
    Suy ra route contract từ constructor của Screen.
    Quy ước:
    - XxxScreen -> XxxRoute
    """
    presentation_dir = os.path.join(app_path, "lib", "src", "presentation")
    if not os.path.exists(presentation_dir):
        return ""

    lines = [
        "🚨 [ROUTE CONTRACTS]:",
        "Dưới đây là contract gọi Route được suy ra từ constructor của các Screen đã tồn tại.",
        "CHỈ được gọi Route với đúng các tham số dưới đây. Nếu Route rỗng thì CẤM truyền tham số.",
        "",
    ]

    found = False

    for root, _, files in os.walk(presentation_dir):
        for file in files:
            if not file.endswith("_screen.dart"):
                continue

            file_path = os.path.join(root, file)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
            except Exception:
                continue

            class_match = re.search(
                r'class\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:extends|with|implements|\{)',
                content,
            )
            if not class_match:
                continue

            screen_class = class_match.group(1)
            if not screen_class.endswith("Screen"):
                continue

            route_name = screen_class.replace("Screen", "Route")

            ctor_match = re.search(
                rf'(?:const\s+)?{re.escape(screen_class)}\s*\((.*?)\)\s*;',
                content,
                re.DOTALL,
            )
            if not ctor_match:
                continue

            params_raw = re.sub(r"\s+", " ", (ctor_match.group(1) or "")).strip()

            if not params_raw:
                lines.append(f"- `{route_name}()`")
                lines.append("  => Route rỗng. CẤM truyền tham số.")
            else:
                allowed_named, _ = _extract_named_params_from_signature(params_raw)
                lines.append(f"- `{route_name}({params_raw})`")
                if allowed_named:
                    lines.append(
                        f"  => Named params hợp lệ: {', '.join(sorted(allowed_named))}"
                    )
                else:
                    lines.append(
                        "  => Có positional params hoặc pattern đặc biệt. Phải bám đúng chữ ký ở trên."
                    )

            lines.append("")
            found = True

    return "\n".join(lines).strip() if found else ""


def _extract_named_params_from_signature(params_raw: str):
    """
    Hỗ trợ cả:
    - const A({required this.id})
    - const factory A({required String id, required bool isSaved}) = _A;
    """
    allowed_named = set()
    required_named = set()

    if not params_raw:
        return allowed_named, required_named

    cleaned = re.sub(r"\s+", " ", params_raw).strip()

    # Strip annotations như @QueryParam('...'), @Default(...), @pathParam, v.v.
    cleaned = re.sub(r'@\w+(?:\([^)]*\))?\s*', '', cleaned)

    # Strip super.xxx patterns (ví dụ: super.key) — không phải named param của caller
    cleaned = re.sub(r'super\.\w+', '', cleaned)

    # Bắt kiểu this.foo
    this_params = re.findall(
        r'(?:required\s+)?(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
        cleaned,
    )
    allowed_named.update(this_params)

    this_required = re.findall(
        r'required\s+(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
        cleaned,
    )
    required_named.update(this_required)

    # Bắt kiểu freezed / named params không có this.
    # Ví dụ: required String barcodeValue
    plain_params = re.findall(
        r'(?:^|,)\s*(?:required\s+)?(?:final\s+)?([A-Za-z0-9_<>, ?\[\]]+)\s+([A-Za-z0-9_]+)\s*(?=,|$)',
        cleaned,
    )
    for _type_name, param_name in plain_params:
        if param_name not in {"this"}:
            allowed_named.add(param_name)

    plain_required = re.findall(
        r'(?:^|,)\s*required\s+(?:final\s+)?([A-Za-z0-9_<>, ?\[\]]+)\s+([A-Za-z0-9_]+)\s*(?=,|$)',
        cleaned,
    )
    for _type_name, param_name in plain_required:
        if param_name not in {"this"}:
            required_named.add(param_name)

    return allowed_named, required_named


def _extract_contracts(app_path: str) -> dict:
    """
    Xây map contract từ toàn bộ code hiện có trong presentation.
    Bao gồm:
    - Widget/Screen constructors
    - Route contracts suy ra từ Screen constructors
    """
    contracts = {}
    presentation_dir = os.path.join(app_path, "lib", "src", "presentation")
    if not os.path.exists(presentation_dir):
        return contracts

    for root, _, files in os.walk(presentation_dir):
        for file in files:
            if not file.endswith(".dart"):
                continue

            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8") as f:
                    content = f.read()
            except Exception:
                continue

            class_iter = re.finditer(
                r'class\s+([A-Za-z_][A-Za-z0-9_]*)\s*(?:extends|with|implements|\{)',
                content,
            )

            for class_match in class_iter:
                class_name = class_match.group(1)

                ctor_match = re.search(
                    rf'(?:const\s+)?{re.escape(class_name)}\s*\((.*?)\)\s*;',
                    content,
                    re.DOTALL,
                )

                # fallback cho freezed factory
                if not ctor_match:
                    ctor_match = re.search(
                        rf'const\s+factory\s+{re.escape(class_name)}\s*\((.*?)\)\s*=',
                        content,
                        re.DOTALL,
                    )

                if not ctor_match:
                    continue

                params_raw = (ctor_match.group(1) or "").strip()
                params_raw = re.sub(r"\s+", " ", params_raw).strip()

                allowed_named, required_named = _extract_named_params_from_signature(params_raw)

                contracts[class_name] = {
                    "allowed_named": allowed_named,
                    "required_named": required_named,
                    "raw_params": params_raw,
                }

                if class_name.endswith("Screen"):
                    route_name = class_name.replace("Screen", "Route")
                    contracts[route_name] = {
                        "allowed_named": allowed_named,
                        "required_named": required_named,
                        "raw_params": params_raw,
                    }

    return contracts


def _find_calls(code: str):
    """
    Tìm lời gọi dạng:
    SomeWidget(...)
    SomeRoute(...)

    Đây là heuristic parser, không phải Dart AST parser đầy đủ.
    """
    pattern = r'([A-Z][A-Za-z0-9_]*)\s*\('
    for match in re.finditer(pattern, code):
        callee = match.group(1)
        start = match.end() - 1  # vị trí '('
        depth = 0
        end = None

        for idx in range(start, len(code)):
            ch = code[idx]
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
                if depth == 0:
                    end = idx
                    break

        if end is None:
            continue

        args_raw = code[start + 1:end]
        yield callee, args_raw


def validate_constructor_and_route_usage(
        app_path: str,
        screen_code: str,
        feature_name: str,
        allowed_route_names: set[str] | None = None,
) -> bool:
    """
    Kiểm tra code mới sinh có gọi sai tham số vào widget/route đã tồn tại hay không.

    Bắt các lỗi chính:
    - truyền named param không tồn tại
    - thiếu required named param
    - route/widget rỗng nhưng vẫn truyền param
    - gọi Route không nằm trong allowlist toàn app

    Lưu ý:
    - Một số route hợp lệ có thể chưa được generate ở thời điểm hiện tại.
      Nếu route đó nằm trong allowed_route_names thì KHÔNG báo lỗi "không tồn tại".
    - Bỏ qua framework routes của Flutter như Route, MaterialPageRoute...
    """
    contracts = _extract_contracts(app_path)
    if not contracts:
        contracts = {}

    if allowed_route_names is None:
        allowed_route_names = set()

    framework_routes = {
        "Route",
        "PageRoute",
        "ModalRoute",
        "MaterialPageRoute",
        "CupertinoPageRoute",
    }

    errors = []

    for callee, args_raw in _find_calls(screen_code):
        # Bỏ qua framework routes
        if callee in framework_routes:
            continue

        # Route không có trong codebase hiện tại:
        # - nếu có trong allowlist toàn app -> cho qua
        # - nếu không có trong allowlist -> lỗi cứng
        if callee.endswith("Route") and callee not in contracts:
            if callee in allowed_route_names:
                continue

            errors.append(
                f"`{callee}` không tồn tại trong route contracts."
            )
            continue

        if callee not in contracts:
            continue

        allowed_named = contracts[callee]["allowed_named"]
        required_named = contracts[callee]["required_named"]
        signature = contracts[callee]["raw_params"]

        passed_named = set(re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\s*:', args_raw))

        unknown_named = passed_named - allowed_named
        missing_required = required_named - passed_named if required_named else set()

        if unknown_named:
            errors.append(
                f"`{callee}` nhận tham số lạ {sorted(unknown_named)}. "
                f"Allowed: {sorted(allowed_named)}. Signature: ({signature})"
            )

        if required_named and missing_required:
            errors.append(
                f"`{callee}` thiếu required params {sorted(missing_required)}. "
                f"Allowed: {sorted(allowed_named)}. Signature: ({signature})"
            )

        if not allowed_named and passed_named:
            errors.append(
                f"`{callee}` là constructor/route rỗng nhưng đang bị truyền params {sorted(passed_named)}."
            )

    if errors:
        # Phân loại: Route errors nghiêm trọng hơn widget errors
        route_errors = [e for e in errors if "Route" in e]
        widget_errors = [e for e in errors if "Route" not in e]

        if widget_errors:
            joined_w = "\n- ".join(widget_errors)
            print(f"      ⚠️ {feature_name}: cảnh báo contract widget:\n- {joined_w}")

        if route_errors:
            joined_r = "\n- ".join(route_errors)
            raise ValueError(
                f"{feature_name}: phát hiện gọi sai contract route:\n- {joined_r}"
            )

    return True