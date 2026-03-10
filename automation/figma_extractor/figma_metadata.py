from automation.ai.ai_client import call_ai_json


def get_all_texts(node, text_set=None):
    """Đệ quy quét toàn bộ text trong một node"""
    if text_set is None:
        text_set = set()

    if node.get("type") == "TEXT":
        text = node.get("text", "").strip()
        # Bỏ qua các chuỗi quá ngắn hoặc rỗng
        if text and len(text) > 1:
            text_set.add(text)

    for child in node.get("children", []):
        get_all_texts(child, text_set)

    return text_set

def extract_languages_from_figma(figma_data):
    """
    Tự động nhận diện và phân loại ngôn ngữ chính/phụ bằng AI.
    """
    target_node = figma_data
    for child in figma_data.get("children", []):
        if "language" in child.get("name", "").lower():
            target_node = child
            break

    raw_texts = list(get_all_texts(target_node))
    if not raw_texts:
        return [{"name": "English", "code": "en"}]


    prompt = f"""
    Bạn là một chuyên gia Localization cho ứng dụng Flutter.
    Dưới đây là danh sách văn bản lấy từ giao diện chọn ngôn ngữ:
    {raw_texts}

    NHIỆM VỤ:
    1. Lọc ra các tên ngôn ngữ thực sự.
    2. Xác định mã ISO 639-1 (2 chữ cái) tương ứng.
    3. QUY TẮC CHÍNH/PHỤ: Nếu có nhiều biến thể của cùng một ngôn ngữ (VD: Português cho Bồ Đào Nha và Brasil, hoặc Tiếng Trung Phồn thể và Giản thể):
       - Ngôn ngữ CHÍNH/Gốc: CHỈ dùng mã 2 chữ cái (VD: "pt", "zh").
       - Ngôn ngữ PHỤ/Biến thể: Nối thêm mã quốc gia bằng dấu gạch dưới (VD: "pt_BR", "zh_TW").

    YÊU CẦU ĐỊNH DẠNG (BẮT BUỘC):
    Trả về một JSON Object duy nhất có key "languages".
    Ví dụ mẫu:
    {{
        "languages": [
            {{"name": "English", "code": "en"}},
            {{"name": "中文 (简体)", "code": "zh"}},
            {{"name": "中文 (繁體)", "code": "zh_TW"}},
            {{"name": "Português (Portugal)", "code": "pt"}},
            {{"name": "Português (Brasil)", "code": "pt_BR"}}
        ]
    }}
    """

    try:
        print("      🧠 Đang phân tích ngôn ngữ và phân loại chính/phụ...")
        result = call_ai_json(prompt)
        languages = result.get("languages", [])
        if languages: return languages
    except Exception as e:
        print(f"      ⚠️ Lỗi khi AI phân tích ngôn ngữ động: {e}")

    return [{"name": "English", "code": "en"}]

