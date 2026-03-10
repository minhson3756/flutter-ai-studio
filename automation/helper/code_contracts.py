import os
import re


def extract_flutter_models(app_path):
    """
    Quét thư mục models để trích xuất cấu trúc Class ngắn gọn hơn,
    tránh làm prompt quá dài gây thiếu code.
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
                r'class\s+([A-Za-z0-9_]+)\s*(?:extends|implements|\{)',
                content
            )

            for match in class_matches:
                class_name = match.group(1)

                fields = re.findall(
                    r'(?:final\s+)?([a-zA-Z0-9_<>,? ]+)\s+([a-zA-Z0-9_]+)\s*;',
                    content
                )

                if not fields:
                    continue

                fields_str = ", ".join([f"{t.strip()} {n}" for t, n in fields])
                rel_import = f"package:flutter_base/src/shared/models/{file}"

                lines.append(f"- {class_name}({fields_str})")
                lines.append(f"  import: {rel_import}")
                found_models = True

    return "\n".join(lines).strip() if found_models else ""

def extract_generated_constructors(app_path):
    """
    Quét các Screen/Widget đã gen trong presentation để tạo CONTRACT constructor
    cho các màn hình sinh sau. Bản này hỗ trợ:
    - có/không có const
    - named params
    - positional params
    - constructor xuống nhiều dòng
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

                ctor_full = re.sub(r'\s+', ' ', ctor_match.group(1)).strip()
                params_raw = (ctor_match.group(2) or "").strip()

                lines.append(f"- {class_name}: `{ctor_full}`")

                if not params_raw:
                    lines.append("  => Constructor rỗng. CẤM truyền tham số.")
                else:
                    named_params = re.findall(
                        r'(?:required\s+)?(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
                        params_raw,
                    )
                    if named_params:
                        lines.append(
                            f"  => Named params hợp lệ: {', '.join(named_params)}"
                        )
                    else:
                        lines.append(
                            "  => Có positional params hoặc pattern đặc biệt. Phải bám đúng constructor ở trên, không được tự đổi tên biến."
                        )

                lines.append("")

    return "\n".join(lines).strip() if found else ""

def extract_route_contracts(app_path):
    """
    Suy ra ROUTE CONTRACT từ constructor của các Screen.
    Quy ước:
    - XxxScreen -> XxxRoute
    - constructor của Screen chính là contract tham số cho Route tương ứng trong AutoRoute
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

            params_raw = re.sub(r'\s+', ' ', (ctor_match.group(1) or "")).strip()

            if not params_raw:
                lines.append(f"- `{route_name}()`")
                lines.append("  => Route rỗng. CẤM truyền tham số.")
            else:
                named_params = re.findall(
                    r'(?:required\s+)?(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
                    params_raw,
                )
                if named_params:
                    lines.append(f"- `{route_name}({params_raw})`")
                    lines.append(
                        f"  => Named params hợp lệ: {', '.join(named_params)}"
                    )
                else:
                    lines.append(f"- `{route_name}({params_raw})`")
                    lines.append(
                        "  => Có positional params hoặc pattern đặc biệt. Phải bám đúng chữ ký ở trên."
                    )

            lines.append("")
            found = True

    return "\n".join(lines).strip() if found else ""

def validate_constructor_and_route_usage(app_path, screen_code, feature_name):
    """
    Kiểm tra code màn hình mới sinh có gọi sai tham số vào:
    - Widget / Screen đã tồn tại
    - Route đã tồn tại

    Chỉ bắt named params vì đây là lỗi phổ biến nhất của AI:
    - truyền title, qrType, parsedFields... không tồn tại
    - gọi SomeRoute(foo: ...) trong khi route rỗng
    """

    def _extract_contracts():
        contracts = {}
        presentation_dir = os.path.join(app_path, "lib", "src", "presentation")
        if not os.path.exists(presentation_dir):
            return contracts

        for root, _, files in os.walk(presentation_dir):
            for file in files:
                # 🌟 FIX 1: Chỉ đọc Screen và Widget, BỎ QUA các file State và Cubit
                if not (file.endswith("_screen.dart") or file.endswith("_widget.dart")):
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

                    # 🌟 FIX 2: Bỏ qua các class là State hoặc Cubit (tránh check nhầm State Machine)
                    if class_name.endswith("State") or class_name.endswith("Cubit"):
                        continue

                    ctor_match = re.search(
                        rf'(?:const\s+)?{re.escape(class_name)}\s*\((.*?)\)\s*;',
                        content,
                        re.DOTALL,
                    )
                    if not ctor_match:
                        continue

                    params_raw = ctor_match.group(1) or ""

                    named_params = set(
                        re.findall(
                            r'(?:required\s+)?(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
                            params_raw,
                        )
                    )

                    required_named = set(
                        re.findall(
                            r'required\s+(?:final\s+)?[A-Za-z0-9_<>, ?\[\]]+\s+this\.([A-Za-z0-9_]+)',
                            params_raw,
                        )
                    )

                    contracts[class_name] = {
                        "allowed_named": named_params,
                        "required_named": required_named,
                        "raw_params": re.sub(r"\s+", " ", params_raw).strip(),
                    }

                    if class_name.endswith("Screen"):
                        route_name = class_name.replace("Screen", "Route")
                        contracts[route_name] = {
                            "allowed_named": named_params,
                            "required_named": required_named,
                            "raw_params": re.sub(r"\s+", " ", params_raw).strip(),
                        }

        return contracts

    def _find_calls(code):
        """
        Tìm lời gọi kiểu:
        SomeWidget(...)
        SomeRoute(...)
        Không parse full Dart AST, chỉ dùng heuristic đủ mạnh cho named params.
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

    contracts = _extract_contracts()
    if not contracts:
        return True

    errors = []

    for callee, args_raw in _find_calls(screen_code):
        if callee not in contracts:
            continue

        allowed_named = contracts[callee]["allowed_named"]
        required_named = contracts[callee]["required_named"]
        signature = contracts[callee]["raw_params"]

        passed_named = set(re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\s*:', args_raw))

        unknown_named = passed_named - allowed_named
        missing_required = required_named - passed_named if allowed_named else set()

        if unknown_named:
            errors.append(
                f"`{callee}` nhận tham số lạ {sorted(unknown_named)}. "
                f"Allowed: {sorted(allowed_named)}. Signature: ({signature})"
            )

        # Chỉ check thiếu required khi constructor dùng named params
        if required_named and missing_required:
            errors.append(
                f"`{callee}` thiếu required params {sorted(missing_required)}. "
                f"Allowed: {sorted(allowed_named)}. Signature: ({signature})"
            )

        # Constructor/Route rỗng mà vẫn truyền named param
        if not allowed_named and passed_named:
            errors.append(
                f"`{callee}` là constructor/route rỗng nhưng đang bị truyền params {sorted(passed_named)}."
            )

    if errors:
        joined = "\n- ".join(errors)
        raise ValueError(
            f"{feature_name}: phát hiện gọi sai contract widget/route:\n- {joined}"
        )

    return True
