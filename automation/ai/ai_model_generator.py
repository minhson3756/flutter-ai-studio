import re

from automation.ai.ai_client import model_name, client


def generate_global_models(spec_content, screens_info):
    """
    AI Architect: Tự động suy luận và thiết kế Data Models theo NHIỀU FILE,
    tránh nhồi toàn bộ model vào 1 file khiến thiếu code / cắt output.
    """
    prompt = f"""
    Bạn là một Software Architect (Tech Lead) của dự án Flutter.
    Dựa vào Yêu cầu nghiệp vụ và Danh sách màn hình bên dưới, hãy tự suy luận
    các Data Models dùng chung cho toàn app.

    YÊU CẦU NGHIỆP VỤ:
    {spec_content}

    DANH SÁCH MÀN HÌNH TỪ FIGMA:
    {screens_info}

    🚨 KỶ LUẬT THÉP:
    1. KHÔNG được dồn tất cả model vào một file duy nhất.
    2. PHẢI chia model thành NHIỀU FILE theo domain/chức năng.
    3. CHỈ sinh code Dart model, enum, helper model.
    4. KHÔNG dùng UI imports như material.dart.
    5. Chỉ dùng kiểu dữ liệu thô: String, int, double, bool, DateTime, List, Map.
    6. Mỗi file phải có tên rõ nghĩa, ví dụ:
       - history_item_model.dart
       - user_settings_model.dart
       - language_model.dart
       - qr_data_models.dart
    7. Nếu có enum liên quan chặt với model thì có thể để cùng file domain.
    8. Không giải thích, không markdown ngoài XML.

    TRẢ VỀ XML ĐÚNG CẤU TRÚC SAU:

    <models>
      <file name="history_item_model.dart">
        ...dart code...
      </file>
      <file name="user_settings_model.dart">
        ...dart code...
      </file>
      <file name="qr_data_models.dart">
        ...dart code...
      </file>
    </models>

    🚨 BẮT BUỘC:
    - Mỗi <file> phải có attribute name
    - KHÔNG dùng ```dart
    - KHÔNG giải thích
    """

    response = client.messages.create(
        model=model_name,
        max_tokens=5000,
        messages=[{"role": "user", "content": prompt}]
    )

    raw_text = response.content[0].text.strip()

    file_matches = re.findall(
        r'<file\s+name="([^"]+)">\s*(.*?)\s*</file>',
        raw_text,
        re.DOTALL
    )

    if not file_matches:
        raise ValueError(f"AI model response invalid, missing <file> tags:\n{raw_text[:1500]}")

    result = []
    for file_name, file_code in file_matches:
        clean_code = file_code.strip().replace("```dart", "").replace("```", "").strip()
        if clean_code:
            result.append({
                "name": file_name.strip(),
                "content": clean_code,
            })

    if not result:
        raise ValueError("AI model response parsed but no model files found.")

    return result
