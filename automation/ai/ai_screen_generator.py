import re
import time

import anthropic

from automation.ai.ai_client import _call_ai_code, client, model_name


def _is_complex_screen(feature_name: str, screen_json: str) -> bool:
    """Detect màn hình phức tạp cần chia nhỏ widget."""
    indicators = ["bottomTab", "subTab", "BottomNavigationBar", "TabBar"]
    name_lower = feature_name.lower()
    has_tabs = any(ind.lower() in name_lower or ind.lower() in screen_json.lower() for ind in indicators)
    # Cũng check nếu Figma JSON quá lớn (>15000 chars)
    is_large = len(screen_json) > 15000
    return has_tabs or is_large


def _build_split_widget_instruction(is_complex: bool) -> str:
    if not is_complex:
        return ""
    return """
🚨 [QUY TẮC CHIA NHỎ WIDGET - BẮT BUỘC CHO MÀN HÌNH PHỨC TẠP]:
- Screen file PHẢI được chia thành nhiều private widget classes nhỏ.
- Mỗi tab content / section lớn PHẢI là 1 private StatelessWidget riêng biệt (VD: `class _ScanTab extends StatelessWidget`).
- Screen chính chỉ chứa scaffold + navigation logic + switch giữa các tab widget.
- KHÔNG viết toàn bộ UI vào 1 hàm build() duy nhất.
- Pattern mẫu:
  ```
  class _HomeView extends StatelessWidget {
    Widget build(context) => Scaffold(
      body: _buildBody(context, state),
      bottomNavigationBar: _buildBottomNav(context, state),
    );
  }
  class _ScanTabContent extends StatelessWidget { ... }
  class _HistoryTabContent extends StatelessWidget { ... }
  class _CreateTabContent extends StatelessWidget { ... }
  ```
- Mỗi private widget class nên dưới 100 dòng code.
- TUYỆT ĐỐI KHÔNG viết file >800 dòng. Nếu cần nhiều hơn, ưu tiên đơn giản hóa.
"""


def generate_feature_code(feature_name, screen_json, dynamic_context, rules):
    is_complex = _is_complex_screen(feature_name, screen_json)
    split_instructions = _build_split_widget_instruction(is_complex)

    prompt = f"""
    {rules}
    {dynamic_context}

    MÀN HÌNH: {feature_name}
    DỮ LIỆU FIGMA: {screen_json}

    Nhiệm vụ: Đóng vai trò là Senior Fullstack Flutter. Viết code TRỌN GÓI và HOÀN HẢO.
    {split_instructions}
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
    1. CẤM SỬ DỤNG TODO HOẶC CODE TƯỢNG TRƯNG: BẮT BUỘC phải viết 100% logic và UI. Không được bỏ trống hàm nào. Mọi button/action PHẢI có thân hàm thực.
    2. PIXEL-PERFECT VÀ SUY LUẬN LOGIC: Tự suy luận State (Loading/Error/Empty). Bám sát từng pixel của Figma.
    3. ROUTE VÀ CONSTRUCTOR THỰC TẾ: Tự thêm biến final vào Constructor nếu cần nhận dữ liệu, và truyền đúng param khi đẩy Route.

    🚨 CRITICAL - PHẢI ĐỌC KỸ:
    - Text trong Figma JSON là DỮ LIỆU MẪU THIẾT KẾ (VD: "Wade Warren", "0123456789"). KHÔNG dùng làm giá trị cố định.
    - Result screens PHẢI nhận data qua constructor param và lưu vào State. KHÔNG hiển thị dữ liệu tĩnh.
    - share()/copy() PHẢI dùng dữ liệu từ state, KHÔNG dùng literal string.
    - Nếu screen import cubit/state thì <cubit> và <state> tags PHẢI có code, KHÔNG được trả rỗng.
    - Camera/Scanner screens PHẢI dùng `MobileScanner` widget thật, KHÔNG dùng Container đen giả.

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
    # Complex screens bắt đầu với tokens cao hơn để tránh truncation
    if is_complex:
        print(f"      🏗️ Phát hiện màn hình phức tạp, yêu cầu chia nhỏ widgets...")
    return _call_ai_code(prompt)

def fix_flutter_code_agent(file_content, error_log):
    """
    Đặc vụ Fixer: Tự động đọc lỗi từ terminal và sửa lại code Dart.
    Tự động điều chỉnh max_tokens dựa trên độ dài file.
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

    🚨 QUY TẮC FIX:
    - KHÔNG được dùng `as dynamic` để cast — sử dụng đúng kiểu dữ liệu.
    - Với Freezed state: KHÔNG dùng `clearXxx: true` pattern — để clear nullable field, set nó = null trực tiếp.
      VD SAI: `state.copyWith(clearOpenMenuItemId: true)`
      VD ĐÚNG: `state.copyWith(openMenuItemId: null)`
    - Import PHẢI nằm ở ĐẦU file, TRƯỚC mọi class/enum declaration.
    - KHÔNG thêm enum value mới (.other, .unknown) nếu enum đã được định nghĩa ở file khác.
    - PHẢI giữ nguyên toàn bộ code khi không liên quan đến lỗi. CHỈ sửa phần bị lỗi.
    """

    # Tính max_tokens dựa trên độ dài file (1 token ~ 4 chars, nhân 1.5 để dư)
    estimated_tokens = max(8192, int(len(file_content) / 4 * 1.5))
    max_tokens = min(estimated_tokens, 32000)  # Cap ở 32k

    from automation.ai.ai_client import _call_ai_with_network_retry
    response = _call_ai_with_network_retry(prompt, max_tokens)

    text = response.content[0].text

    # Trích xuất code mới
    match = re.search(r'```dart(.*?)```', text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return text.strip()