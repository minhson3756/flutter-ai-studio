import os
import re

def to_snake_case(name):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

def update_app_router(app_path, feature_name, snake_name):
    router_path = os.path.join(app_path, "lib", "src", "config", "navigation", "app_router.dart")

    if not os.path.exists(router_path):
        print(f"⚠️ Cảnh báo: Không tìm thấy {router_path}. Bỏ qua tự động thêm Route.")
        return

    with open(router_path, "r", encoding="utf-8") as f:
        content = f.read()

    # TỰ ĐỘNG THÊM IMPORT VÀO ĐẦU FILE
    import_stmt = f"import 'package:flutter_base/src/presentation/{snake_name}/{snake_name}_screen.dart';\n"
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


def inject_to_flutter(app_path, feature_name, generated_code, is_sub_tab=False, parent_name=None):
    snake_name = to_snake_case(feature_name)

    # Đảm bảo parent_snake luôn có giá trị để không bị crash script
    parent_snake = to_snake_case(parent_name) if parent_name else "shared"

    # 🌟 ĐỊNH TUYẾN THƯ MỤC: Tách biệt Màn hình chính và Widget con
    if is_sub_tab:
        # Bỏ vào thư mục: presentation/parent_name/widgets/
        feature_dir = os.path.join(app_path, "lib", "src", "presentation", parent_snake, "widgets")
        # FIX LỖI NHÂN ĐÔI WIDGET: Nếu tên gốc đã có chữ widget thì chỉ nối đuôi .dart
        file_suffix = ".dart" if snake_name.endswith("_widget") else "_widget.dart"
    else:
        # Bỏ vào thư mục gốc: presentation/feature_name/
        feature_dir = os.path.join(app_path, "lib", "src", "presentation", snake_name)
        # FIX LỖI NHÂN ĐÔI SCREEN
        file_suffix = ".dart" if snake_name.endswith("_screen") else "_screen.dart"

    cubit_dir = os.path.join(feature_dir, "cubit")
    os.makedirs(cubit_dir, exist_ok=True)

    screen_code = generated_code.get("screen")
    cubit_code = generated_code.get("cubit")
    state_code = generated_code.get("state")

    if screen_code:
        screen_path = os.path.join(feature_dir, f"{snake_name}{file_suffix}")
        with open(screen_path, "w", encoding="utf-8") as f:
            f.write(screen_code)

    if cubit_code and str(cubit_code).strip() != "None" and str(cubit_code).strip() != "":
        cubit_path = os.path.join(cubit_dir, f"{snake_name}_cubit.dart")
        with open(cubit_path, "w", encoding="utf-8") as f:
            f.write(cubit_code)

    if state_code and str(state_code).strip() != "None" and str(state_code).strip() != "":
        state_path = os.path.join(cubit_dir, f"{snake_name}_state.dart")
        with open(state_path, "w", encoding="utf-8") as f:
            f.write(state_code)

    # 🌟 KIỂM SOÁT ROUTE: Chỉ cấu hình Route cho màn hình chính
    if not is_sub_tab:
        update_app_router(app_path, feature_name, snake_name)
        print(f"   ✅ Đã tạo Screen và tự động cấu hình {feature_name}Route vào app_router.dart")
    else:
        print(f"   ✅ Đã tạo Widget con tại: presentation/{parent_snake}/widgets/{snake_name}{file_suffix}")