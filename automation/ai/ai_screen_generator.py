import re

from automation.ai.ai_client import _call_ai_code, client, model_name


def generate_feature_code(feature_name, screen_json, dynamic_context, rules):
    prompt = f"""
    {rules}
    {dynamic_context}
    
    MÀN HÌNH: {feature_name}
    DỮ LIỆU FIGMA: {screen_json}

    Nhiệm vụ: Đóng vai trò là Senior Fullstack Flutter. Viết code TRỌN GÓI và HOÀN HẢO.
    
    🚨 BẮT BUỘC TRẢ VỀ XML HỢP LỆ, KHÔNG GIẢI THÍCH, KHÔNG VĂN BẢN NGOÀI XML.

    PHẢI LUÔN TRẢ ĐỦ 4 TAG:
    <screen>...</screen>
    <cubit>...</cubit>
    <state>...</state>
    <packages>...</packages>
    
    🚨 [KỶ LUẬT THÉP DÀNH CHO SENIOR DEVELOPER]:
    - Nếu không cần cubit/state/packages thì vẫn phải trả tag rỗng:
      <cubit></cubit>
      <state></state>
      <packages></packages>
    - KHÔNG được viết bất kỳ câu nào như:
      "I'll analyze...", "Here is the code...", "Done", ...
    - KHÔNG được dùng markdown
    - XML phải đóng tag đầy đủ, hợp lệ
    - THIẾU <screen> là response không hợp lệ
    OUTPUT MẪU BẮT BUỘC:
    <screen>
    ...dart code...
    </screen>
    <cubit>
    ...dart code hoặc rỗng...
    </cubit>
    <state>
    ...dart code hoặc rỗng...
    </state>
    <packages>
    flutter_svg
    share_plus
    </packages>
    - GIỮ CODE NGẮN GỌN, KHÔNG VIẾT THỪA COMMENT, KHÔNG GIẢI THÍCH.
    - KHÔNG lặp lại cùng một layout nhiều lần nếu có thể render động theo page/state.
    - Nếu màn hình có nhiều variant như page=barcode, page=contact..., PHẢI dùng 1 screen duy nhất và render theo enum/state.
    - ƯU TIÊN code ngắn nhưng compile được.
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