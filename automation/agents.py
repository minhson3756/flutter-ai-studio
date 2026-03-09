import os
import json
import re
import time

import anthropic
from dotenv import load_dotenv

from utils import read_file

load_dotenv()

# Khởi tạo client Anthropic
client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
model_name = "claude-sonnet-4-6"

def _call_ai_json(prompt, max_retries=6):
    """HÀM 1: Dùng riêng cho các tác vụ phân tích JSON (Palette, Translation, Enum)"""
    for attempt in range(max_retries):
        try:
            response = client.messages.create(
                model=model_name,
                max_tokens=8000,
                messages=[{"role": "user", "content": prompt}]
            )
            break
        except anthropic.RateLimitError as e:
            wait_time = 20 * (attempt + 1)
            print(f"\n      ⏳ Đụng trần Token. Đang đợi {wait_time}s... (Lần {attempt + 1}/{max_retries})")
            time.sleep(wait_time)
        except anthropic.APIError as e:
            if "overloaded" in str(e).lower() or getattr(e, 'status_code', 500) in [529, 502, 503, 504]:
                wait_time = 15
                print(f"\n      ⚠️ Máy chủ AI quá tải. Đang đợi {wait_time}s... (Lần {attempt + 1}/{max_retries})")
                time.sleep(wait_time)
            else:
                raise e
    else:
        raise Exception("🚨 Đã hết kiên nhẫn! Hãy thử lại sau vài phút.")

    raw_text = response.content[0].text.strip()
    start_idx = raw_text.find('{')
    end_idx = raw_text.rfind('}')

    if start_idx == -1 or end_idx == -1:
        return {"palette_updates": raw_text, "screen": raw_text}

    json_str = raw_text[start_idx:end_idx+1]
    try:
        return json.loads(json_str, strict=False)
    except json.JSONDecodeError:
        fixed = re.sub(r'([{,]\s*)([a-zA-Z0-9_]+):', r'\1"\2":', json_str)
        try:
            return json.loads(fixed, strict=False)
        except:
            raise ValueError(f"🚨 Lỗi JSON từ AI:\n{raw_text[:200]}...")

def _call_ai_code(prompt, max_retries=6):
    """HÀM DÙNG ĐỂ SINH MÃ NGUỒN VÀ QUẢN LÝ THƯ VIỆN BẰNG XML TAGS"""
    for attempt in range(max_retries):
        try:
            response = client.messages.create(
                model=model_name,
                max_tokens=8192,
                extra_headers={"anthropic-beta": "max-tokens-3-5-sonnet-2024-07-15"},
                messages=[{"role": "user", "content": prompt}]
            )
            break
        except anthropic.RateLimitError as e:
            wait_time = 20 * (attempt + 1)
            print(f"\n      ⏳ Đụng trần Token. Đang đợi {wait_time}s...")
            time.sleep(wait_time)
        except Exception as e:
            wait_time = 15
            print(f"\n      ⚠️ Máy chủ AI lỗi. Đang đợi {wait_time}s...")
            time.sleep(wait_time)
    else:
        raise Exception("🚨 Đã hết kiên nhẫn!")

    raw_text = response.content[0].text.strip()

    def extract_tag(tag, text):
        start_tag = f"<{tag}>"
        end_tag = f"</{tag}>"
        start_idx = text.find(start_tag)
        if start_idx == -1: return None
        start_idx += len(start_tag)
        end_idx = text.find(end_tag, start_idx)

        content = text[start_idx:] if end_idx == -1 else text[start_idx:end_idx]
        return content.replace("```dart", "").replace("```", "").strip()

    screen_code = extract_tag("screen", raw_text)
    cubit_code = extract_tag("cubit", raw_text)
    state_code = extract_tag("state", raw_text)
    # 🌟 ĐỌC THÊM THẺ PACKAGES TỪ AI
    packages_code = extract_tag("packages", raw_text)

    if not screen_code and "import " in raw_text and ("class " in raw_text or "enum " in raw_text):
        screen_code = raw_text.replace("```dart", "").replace("```", "").strip()

    return {
        "screen": screen_code,
        "cubit": cubit_code,
        "state": state_code,
        "packages": packages_code
    }

def analyze_global_styles(colors_list_json):
    prompt = f"""
    Bạn là System Architect. Hãy suy luận tên biến có ý nghĩa cho các màu: {colors_list_json}
    Trả về MỘT JSON Object có key "palette_updates" chứa chuỗi code Dart.
    """
    return _call_ai_json(prompt)

def generate_language_enum(languages_list):
    # 🌟 SỬA LỖI ENUM: Ép dùng XML thay vì JSON để tránh gãy code
    prompt = f"""
    Bạn là chuyên gia Flutter/Dart. Hãy tạo file enum Language dựa trên danh sách: {languages_list}
    
    YÊU CẦU BẮT BUỘC: 
    TUYỆT ĐỐI KHÔNG TRẢ VỀ JSON. Trả về mã nguồn Dart thuần túy bọc trong thẻ XML <screen> ... </screen>.
    Giữ nguyên cấu trúc enum chuẩn của Dart, hỗ trợ extension lấy `Locale`.
    """
    return _call_ai_code(prompt)

def generate_screen_translations(texts_list, lang_codes):
    """Nhờ AI tạo key và dịch text sang các ngôn ngữ (ID Mapping chuẩn & Chống Keyword)"""
    indexed_texts = [{"id": str(i), "text": txt} for i, txt in enumerate(texts_list)]
    safe_texts = json.dumps(indexed_texts, ensure_ascii=False)

    prompt = f"""
    Bạn là chuyên gia i18n Localization.
    Danh sách văn bản gốc từ UI (đã được gắn ID): {safe_texts}
    Danh sách mã ngôn ngữ đích (ISO): {lang_codes}

    NHIỆM VỤ:
    1. Tạo một 'key' (định dạng camelCase, tiếng Anh, không dấu, viết liền) cho mỗi văn bản dựa trên nội dung.
    2. Dịch văn bản đó sang tất cả các mã ngôn ngữ đích.

    YÊU CẦU ĐỊNH DẠNG (BẮT BUỘC TRẢ VỀ JSON NHƯ MẪU DƯỚI ĐÂY):
    {{
        "keys_mapping": {{
            "0": "camelCaseKey1",
            "1": "camelCaseKey2"
        }},
        "translations": {{
            "en": {{"camelCaseKey1": "Translated text 1"}},
            "vi": {{"camelCaseKey1": "Bản dịch tiếng Việt 1"}}
        }}
    }}
    
    🚨 KỶ LUẬT JSON VÀ NAMING BẮT BUỘC: 
    - Ở phần `keys_mapping`, TUYỆT ĐỐI KHÔNG chép lại text gốc làm key. BẮT BUỘC dùng "id" (0, 1, 2...) làm key.
    - Trả về MỘT JSON Object duy nhất, không có văn bản giải thích bên ngoài.
    - ⚠️ CẤM DÙNG TỪ KHÓA DART (RESERVED KEYWORDS): TUYỆT ĐỐI KHÔNG tạo key trùng với các từ khóa hệ thống của Flutter/Dart (VD: default, class, enum, switch, for, in, is, as, return, var, final, const, continue, break, factory, late...). 
    - NẾU TEXT GỐC LÀ "Default", "Class", "Enum"... BẮT BUỘC phải thêm hậu tố "Text" hoặc "Label" vào key (Ví dụ: `defaultText`, `classLabel`).
    """

    result = _call_ai_json(prompt)

    final_keys_mapping = {}
    ai_mapping = result.get("keys_mapping", {})

    for item in indexed_texts:
        text_id = item["id"]
        orig_text = item["text"]
        if text_id in ai_mapping:
            final_keys_mapping[orig_text] = ai_mapping[text_id]

    result["keys_mapping"] = final_keys_mapping
    return result

def generate_feature_code(feature_name, screen_json, dynamic_context, rules):
    prompt = f"""
    {rules}
    {dynamic_context}
    
    MÀN HÌNH: {feature_name}
    DỮ LIỆU FIGMA: {screen_json}

    Nhiệm vụ: Đóng vai trò là Senior Fullstack Flutter. Viết code TRỌN GÓI và HOÀN HẢO.
    
    TUYỆT ĐỐI KHÔNG DÙNG JSON. Bọc mã nguồn vào các thẻ XML:
    <screen>...</screen>
    <cubit>...</cubit>
    <state>...</state>
    <packages>...</packages>
    
    🚨 [KỶ LUẬT THÉP DÀNH CHO SENIOR DEVELOPER]:
    1. CẤM SỬ DỤNG TODO HOẶC CODE TƯỢNG TRƯNG: BẮT BUỘC phải viết 100% logic và UI. Không được bỏ trống hàm nào.
    2. PIXEL-PERFECT VÀ SUY LUẬN LOGIC: Tự suy luận State (Loading/Error/Empty). Bám sát từng pixel của Figma.
    3. ROUTE VÀ CONSTRUCTOR THỰC TẾ: Tự thêm biến final vào Constructor nếu cần nhận dữ liệu, và truyền đúng param khi đẩy Route.
    
    4. NHẬN DIỆN TRẠNG THÁI (OVERLAYS / DROPDOWNS): 
       - Nếu dữ liệu Figma chứa NHIỀU FRAME (tên chứa dấu "/"), đó là CÁC TRẠNG THÁI của 1 màn hình.
       - Tự suy luận logic Component ẩn/hiện (Dialog, BottomSheet, Menu) dựa trên sự khác biệt giữa các Frame.
       
    5. 🌟 PATTERN XỬ LÝ NESTED LOGIC (DÙNG CHUNG CHO MỌI APP):
       - PATTERN SUB-TABS: Nếu UI có các Tab/Segmented Control lồng bên trong, BẮT BUỘC tạo `enum` (VD: `TabType`) và biến state (VD: `currentTab`) trong Cubit để switch giao diện.
       - PATTERN LIST ITEM MENU: Nếu thiết kế có Menu/Dropdown mở ra từ MỘT PHẦN TỬ CỤ THỂ trong một Danh sách (List/Grid):
         + ƯU TIÊN 1: Dùng `PopupMenuButton` mặc định của Flutter gắn vào từng Item.
         + ƯU TIÊN 2: Nếu Menu quá Custom (phải tự build UI overlay), TUYỆT ĐỐI KHÔNG dùng biến `bool isMenuOpen` chung (sẽ làm lỗi mở tất cả Item cùng lúc). BẮT BUỘC phải lưu trữ Định danh (ID hoặc Index) của phần tử đang mở vào State (VD: `String? openItemId;`). Khi render, chỉ hiển thị menu nếu `item.id == state.openItemId`.
    6. 🌟 ĐỒNG BỘ CONSTRUCTOR VÀ IMPORT (CHỐNG LỖI BIÊN DỊCH):
       - IMPORT ĐỘC LẬP: Tuyệt đối CHỈ import những đường dẫn đã được hệ thống dặn dò trong Prompt. CẤM tự bịa ra đường dẫn import tới các Widget/Cubit của màn hình khác.
       - BÊN GỌI (CALLER): NẾU `app_spec` yêu cầu chuyển trang (pushRoute) kèm dữ liệu, BẮT BUỘC phải truyền đúng tên biến (Ví dụ: `context.pushRoute(ScanCompleteRoute(scannedData: data));`).
       - BÊN NHẬN (RECEIVER): NẾU `app_spec` yêu cầu màn hình này nhận tham số, BẮT BUỘC phải khai báo biến `final` và định nghĩa trong Constructor (Ví dụ: `const ScanCompleteScreen({{super.key, required this.scannedData}});`). TUYỆT ĐỐI không được bỏ sót tham số đã thỏa thuận.
    """
    return _call_ai_code(prompt)

def generate_global_models(spec_content, screens_info):
    """
    AI Architect: Tự động suy luận và thiết kế Data Models từ yêu cầu mập mờ.
    """
    prompt = f"""
    Bạn là một Software Architect (Tech Lead) của dự án Flutter.
    Dựa vào Yêu cầu nghiệp vụ ngắn gọn và Danh sách các màn hình dưới đây, hãy TỰ ĐỘNG SUY LUẬN và thiết kế các Data Models cần thiết dùng chung cho toàn bộ App (Ví dụ: HistoryItemModel, UserModel...).

    YÊU CẦU NGHIỆP VỤ:
    {spec_content}

    DANH SÁCH MÀN HÌNH TỪ FIGMA:
    {screens_info}

    🚨 KỶ LUẬT THÉP:
    1. CHỈ sinh ra code Dart chứa các `class` Data Model.
    2. TUYỆT ĐỐI KHÔNG chứa các thư viện UI (không import material.dart, KHÔNG dùng Color, IconData). Chỉ dùng kiểu dữ liệu thô (String, int, bool, DateTime).
    3. Tự động thêm constructor `const` với `required` đầy đủ.
    
    Hãy trả về DUY NHẤT một khối code Dart (bọc trong ```dart ... ```), không giải thích gì thêm.
    """

    # Sử dụng client Anthropic có sẵn trong file của bạn
    response = client.messages.create(
        model=model_name,
        max_tokens=2000,
        messages=[{"role": "user", "content": prompt}]
    )

    text = response.content[0].text
    # Trích xuất code Dart
    match = re.search(r'```dart(.*?)```', text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return text.strip()

def fix_flutter_code_agent(file_content, error_log):
    """
    Đặc vụ Fixer: Tự động đọc lỗi từ terminal và sửa lại code Dart.
    """
    prompt = f"""
    Bạn là một Senior Flutter Developer chuyên đi fix bug (Debugger).
    Dưới đây là một file code đang bị báo lỗi khi chạy `flutter analyze`:
    
    ```dart
    {file_content}
    ```
    
    Và đây là log lỗi từ Terminal:
    {error_log}
    
    NHIỆM VỤ CỦA BẠN:
    1. Đọc log lỗi, tìm ra dòng code sai (Thường là gọi sai tên biến, thiếu tham số, import sai...).
    2. Viết lại TOÀN BỘ file code này sau khi đã sửa hết các lỗi trên.
    3. CỰC KỲ QUAN TRỌNG: CHỈ TRẢ VỀ code Dart (bọc trong ```dart ... ```). KHÔNG giải thích, KHÔNG nói chuyện, KHÔNG dùng TODO.
    """

    response = client.messages.create(
        model=model_name,
        max_tokens=8192,
        messages=[{"role": "user", "content": prompt}]
    )
    text = response.content[0].text

    # Trích xuất code mới
    match = re.search(r'```dart(.*?)```', text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return text.strip()