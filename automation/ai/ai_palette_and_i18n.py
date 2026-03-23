import json

from automation.ai.ai_client import call_ai_json, _call_ai_code


def analyze_global_styles(colors_list_json):
    prompt = f"""
Bạn là System Architect.

Dưới đây là danh sách màu/gradient trích từ Figma:
{colors_list_json}

NHIỆM VỤ:
- CHỈ tạo token cho những màu/gradient CÓ TÊN rõ ràng trong dữ liệu nguồn (ví dụ style name, token name, variable name).
- Nếu một màu chỉ là màu xuất hiện ngẫu nhiên trong node nhưng KHÔNG có tên rõ ràng, thì KHÔNG được thêm vào Palette.
- Nếu một gradient không có tên rõ ràng, thì KHÔNG được thêm vào Palette.
- KHÔNG được tự đặt tên màu dựa trên cảm tính như hotPink, burntOrange, softLavender, mintGreen...
- KHÔNG được tự suy luận tên semantic nếu dữ liệu nguồn không có tên.

FORMAT TRẢ VỀ:
Trả về MỘT JSON object duy nhất như sau:
{{
  "palette_updates": "chuỗi các dòng static const ...",
  "allowed_hexes": ["0xFF123456", "0xFFEFEFEF"],
  "allowed_gradients": ["gradientName1", "gradientName2"]
}}

KỶ LUẬT CHO `palette_updates`:
1. Chỉ chứa các dòng `static const ...`
2. Không bọc trong `class Palette`
3. Không markdown, không giải thích
4. Màu thường:
   static const Color tokenName = Color(0xFF......);
5. Gradient:
   static const LinearGradient tokenName = LinearGradient(...);
   static const RadialGradient tokenName = RadialGradient(...);

QUY TẮC QUAN TRỌNG:
- Nếu không có tên -> KHÔNG thêm vào `palette_updates`
- `allowed_hexes` phải chứa toàn bộ mã màu HEX không tên nhưng hợp lệ để UI được phép dùng trực tiếp.
- TUYỆT ĐỐI CẤM dùng `Paint`, `Map`, comment giả hoặc token tên bịa.
"""
    return call_ai_json(prompt)

def generate_language_enum(languages_list):
    prompt = f"""
Bạn là chuyên gia Flutter/Dart. Hãy tạo file `language.dart` dựa trên danh sách ngôn ngữ: {languages_list}

TUYỆT ĐỐI KHÔNG TRẢ VỀ JSON. Trả về mã nguồn Dart thuần túy bọc trong thẻ XML <screen> ... </screen>.

CẤU TRÚC BẮT BUỘC:
```dart
import 'dart:ui';

enum Language {{
  english(languageName: 'English', languageCode: 'en'),
  // ... các ngôn ngữ khác
  ;

  const Language({{
    required this.languageName,
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  }});

  final String languageName;
  final String languageCode;
  final String? scriptCode;
  final String? countryCode;

  @override
  String toString() => languageName;

  Locale get locale => Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: scriptCode,
        countryCode: countryCode,
      );
}}
```

QUY TẮC ÁNH XẠ LOCALE BẮT BUỘC:
- Code dạng "xx" (2 ký tự): languageCode='xx', không cần scriptCode/countryCode
- Code dạng "xx_YY" (với YY là mã quốc gia 2 HOA): countryCode='YY', VD: pt_BR → countryCode: 'BR'
- Code dạng "xx_Yyyy" (với Yyyy là script 4 ký tự): scriptCode='Yyyy', VD: zh_Hans → scriptCode: 'Hans'
- TRƯỜNG HỢP ĐẶC BIỆT BẮT BUỘC:
  + zh hoặc zh_Hans → languageCode: 'zh', scriptCode: 'Hans' (Giản thể)
  + zh_TW hoặc zh_Hant → languageCode: 'zh', scriptCode: 'Hant' (Phồn thể)
  + pt hoặc pt_PT → languageCode: 'pt', countryCode: 'PT'
  + pt_BR → languageCode: 'pt', countryCode: 'BR'
  + ar → languageCode: 'ar' (không cần thêm gì)

KHÔNG được tạo getter `locale` dùng switch/case cũ, BẮT BUỘC dùng `Locale.fromSubtags`.
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

    result = call_ai_json(prompt)

    final_keys_mapping = {}
    ai_mapping = result.get("keys_mapping", {})

    for item in indexed_texts:
        text_id = item["id"]
        orig_text = item["text"]
        if text_id in ai_mapping:
            final_keys_mapping[orig_text] = ai_mapping[text_id]

    result["keys_mapping"] = final_keys_mapping
    return result
