import os
import shutil
import subprocess
from figma_extractor import get_figma_screens
from agents import generate_feature_code
from injector import inject_to_flutter

def main():
    # Đọc dữ liệu từ biến môi trường (do GitHub Actions truyền vào)
    app_name = os.environ.get("APP_NAME", "BaseApp")
    feature_name = os.environ.get("FEATURE_NAME", "Home")
    figma_file_key = os.environ.get("FIGMA_KEY", "")
    lazy_spec = os.environ.get("SPEC", "Màn hình trắng")

    base_project_path = "../base_flutter_project" # Trỏ đến base Android của bạn
    new_app_path = f"../apps/{app_name}"

    print("1. Đang clone Base Project...")
    if not os.path.exists(new_app_path):
        shutil.copytree(base_project_path, new_app_path)

    print("2. Đang đọc Figma...")
    screens = get_figma_screens(figma_file_key)

    print("3. Đang gọi AI Agent sinh code...")
    with open("prompts/ai_architecture_rules.md", "r") as f:
        rules = f.read()

    spec = "Màn hình chính, load danh sách từ API. Có nút play và nút yêu thích."
    code = generate_feature_code(feature_name, screens, spec, rules)

    print("4. Đang bơm code vào Flutter...")
    inject_to_flutter(new_app_path, feature_name, code)

    print("5. Đang chạy Build Runner để gen file Freezed & AutoRoute...")
    subprocess.run(
        ["flutter", "pub", "run", "build_runner", "build", "--delete-conflicting-outputs"],
        cwd=new_app_path
    )

    print(f"🎉 Hoàn tất! Source code đã sẵn sàng tại {new_app_path}")

if __name__ == "__main__":
    main()