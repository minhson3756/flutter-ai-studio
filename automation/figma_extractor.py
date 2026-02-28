import os
import requests
from dotenv import load_dotenv

load_dotenv()

def get_figma_screens(file_key):
    # Lấy thông tin từ Figma API
    token = os.environ.get("FIGMA_PERSONAL_ACCESS_TOKEN")
    headers = {"X-Figma-Token": token}
    url = f"https://api.figma.com/v1/files/{file_key}"

    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        # Ở đây bạn sẽ viết logic duyệt qua cây JSON của Figma
        # để trích xuất ra file screens.json tối giản.
        # Tạm thời trả về mock data để test luồng:
        return {
            "HomeScreen": {
                "elements": ["btn_play", "btn_favorite", "list_items"]
            }
        }
    else:
        raise Exception("Không thể kết nối Figma API")