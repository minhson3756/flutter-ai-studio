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
    # figma_data có dạng {"screens": [...], ...}, không có "children" trực tiếp
    target_node = None
    for screen in figma_data.get("screens", []):
        if "language" in screen.get("name", "").lower():
            target_node = screen
            break

    # Nếu tìm thấy screen language → quét text từ đó, ngược lại quét tất cả screens
    raw_texts = set()
    if target_node:
        get_all_texts(target_node, raw_texts)
    else:
        for screen in figma_data.get("screens", []):
            get_all_texts(screen, raw_texts)
    raw_texts = list(raw_texts)
    if not raw_texts:
        return [{"name": "English", "code": "en"}]


    prompt = f"""
    Bạn là một chuyên gia Localization cho ứng dụng Flutter.
    Dưới đây là danh sách văn bản lấy từ giao diện chọn ngôn ngữ:
    {raw_texts}

    NHIỆM VỤ:
    1. Lọc ra các tên ngôn ngữ thực sự.
    2. Xác định mã locale chuẩn IETF BCP 47 cho từng ngôn ngữ.

    QUY TẮC MÃ LOCALE BẮT BUỘC:
    - Ngôn ngữ không có biến thể: chỉ dùng mã 2 ký tự (VD: "en", "fr", "ar", "hi", "de")
    - Biến thể theo Script (chữ viết): dùng mã script 4 ký tự PascalCase (VD: "zh_Hans", "zh_Hant")
      + Tiếng Trung Giản thể: "zh_Hans"
      + Tiếng Trung Phồn thể: "zh_Hant"
    - Biến thể theo Quốc gia: dùng mã quốc gia 2 ký tự VIẾT HOA (VD: "pt_BR", "pt_PT")
      + Português Brasil: "pt_BR"
      + Português Portugal: "pt_PT"
    - KHÔNG ĐƯỢC dùng mã quốc gia cho tiếng Trung. BẮT BUỘC dùng script code (Hans/Hant).

    YÊU CẦU ĐỊNH DẠNG (BẮT BUỘC):
    Trả về một JSON Object duy nhất có key "languages".
    Ví dụ mẫu:
    {{
        "languages": [
            {{"name": "English", "code": "en"}},
            {{"name": "中文（简体）", "code": "zh_Hans"}},
            {{"name": "中文（繁體）", "code": "zh_Hant"}},
            {{"name": "Português (Portugal)", "code": "pt_PT"}},
            {{"name": "Português (Brasil)", "code": "pt_BR"}},
            {{"name": "عربي", "code": "ar"}}
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

