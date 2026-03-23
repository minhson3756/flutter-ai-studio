import html
import os
import re
import time
import json

import anthropic
from dotenv import load_dotenv

load_dotenv()

# Khởi tạo client Anthropic
client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
model_name = "claude-sonnet-4-6"

def call_ai_json(prompt, max_retries=6):
    """HÀM 1: Dùng riêng cho các tác vụ phân tích JSON (Palette, Translation, Enum)"""
    for attempt in range(max_retries):
        try:
            response = client.messages.create(
                model=model_name,
                max_tokens=8000,
                temperature=0.3,
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

_STREAMING_THRESHOLD = 16000  # SDK yêu cầu streaming khi request có thể >10 phút


def _call_ai_with_network_retry(prompt, max_tokens, max_network_retries=6):
    """Gọi API với retry riêng cho network/overload errors. Tự chuyển streaming khi tokens cao."""
    use_stream = max_tokens > _STREAMING_THRESHOLD

    for net_attempt in range(max_network_retries):
        try:
            if use_stream:
                # Streaming mode: collect chunks thành response hoàn chỉnh
                with client.messages.stream(
                    model=model_name,
                    max_tokens=max_tokens,
                    temperature=0.2,
                    messages=[{"role": "user", "content": prompt}],
                ) as stream:
                    return stream.get_final_message()
            else:
                return client.messages.create(
                    model=model_name,
                    max_tokens=max_tokens,
                    temperature=0.2,
                    messages=[{"role": "user", "content": prompt}],
                )
        except anthropic.RateLimitError:
            wait_time = 20 * (net_attempt + 1)
            print(f"\n      ⏳ Đụng trần Token. Đang đợi {wait_time}s... (Lần {net_attempt + 1}/{max_network_retries})")
            time.sleep(wait_time)
        except anthropic.APIError as e:
            if "overloaded" in str(e).lower() or getattr(e, 'status_code', 500) in [529, 502, 503, 504]:
                wait_time = 20 * (net_attempt + 1)
                print(f"\n      ⚠️ Máy chủ AI quá tải. Đang đợi {wait_time}s... (Lần {net_attempt + 1}/{max_network_retries})")
                time.sleep(wait_time)
            else:
                raise
    raise Exception("🚨 Hết retry network sau nhiều lần thử. Hãy thử lại sau.")


def _gen_cubit_state_separately(screen_code: str, original_prompt: str):
    """Khi screen quá lớn khiến cubit/state bị cắt, gen riêng trong 1 call."""
    # Trích tên cubit/state từ screen imports
    cubit_import = re.search(r"import\s+'([^']*_cubit\.dart)'", screen_code)
    state_import = re.search(r"import\s+'([^']*_state\.dart)'", screen_code)

    cubit_file = cubit_import.group(1) if cubit_import else "cubit.dart"
    state_file = state_import.group(1) if state_import else "state.dart"

    # Trích các class/method references từ screen code
    cubit_refs = set(re.findall(r'context\.read<(\w+Cubit)>', screen_code))
    state_refs = set(re.findall(r'(\w+State)', screen_code))
    method_calls = set(re.findall(r'cubit\.(\w+)\(', screen_code))
    state_fields = set(re.findall(r'state\.(\w+)', screen_code))

    prompt = f"""
    Bạn là Senior Flutter Developer. Screen code dưới đây đã được gen nhưng thiếu Cubit và State.
    Hãy viết ĐÚNG Cubit và State cho screen này.

    SCREEN CODE (đã gen):
    ```dart
    {screen_code[:8000]}
    ```

    THÔNG TIN SUY RA TỪ SCREEN:
    - Cubit classes được dùng: {cubit_refs}
    - State classes được dùng: {state_refs}
    - Cubit methods được gọi: {method_calls}
    - State fields được truy cập: {state_fields}
    - Cubit file: {cubit_file}
    - State file: {state_file}

    🚨 BẮT BUỘC:
    1. Cubit PHẢI có @injectable annotation
    2. State PHẢI dùng freezed với đúng part directive
    3. PHẢI implement TẤT CẢ methods mà screen gọi: {method_calls}
    4. State PHẢI có TẤT CẢ fields mà screen truy cập: {state_fields}
    5. KHÔNG giải thích, CHỈ trả XML

    <cubit>
    ...dart code...
    </cubit>
    <state>
    ...dart code...
    </state>
    """

    response = _call_ai_with_network_retry(prompt, 8000)
    raw = response.content[0].text.strip()

    def extract_tag(tag, text):
        match = re.search(rf"<{tag}>\s*(.*?)\s*</{tag}>", text, re.DOTALL)
        if not match:
            return ""
        return html.unescape(match.group(1).strip()).replace("```dart", "").replace("```", "").strip()

    return extract_tag("cubit", raw), extract_tag("state", raw)


def _call_ai_code(prompt, max_retries=3):
    last_raw_text = ""
    original_prompt = prompt
    current_max_tokens = 16000

    for attempt in range(max_retries):
        response = _call_ai_with_network_retry(prompt, current_max_tokens)

        raw_text = response.content[0].text.strip()
        last_raw_text = raw_text
        stop_reason = response.stop_reason

        def extract_tag(tag, text):
            match = re.search(rf"<{tag}>\s*(.*?)\s*</{tag}>", text, re.DOTALL)
            if not match:
                return None
            return html.unescape(match.group(1).strip()).replace("```dart", "").replace("```", "").strip()

        screen_code = extract_tag("screen", raw_text)
        cubit_code = extract_tag("cubit", raw_text)
        state_code = extract_tag("state", raw_text)
        packages_code = extract_tag("packages", raw_text)

        if screen_code is not None:
            # Detect: screen imports cubit/state nhưng tag rỗng → gen riêng
            needs_cubit = ("_cubit.dart" in screen_code and "cubit/" in screen_code)
            needs_state = ("_state.dart" in screen_code and "cubit/" in screen_code)
            missing_cubit = needs_cubit and not cubit_code
            missing_state = needs_state and not state_code

            if missing_cubit or missing_state:
                print(f"\n      🔄 Screen quá lớn, đang gen cubit/state riêng...")
                gen_cubit, gen_state = _gen_cubit_state_separately(screen_code, original_prompt)
                if missing_cubit and gen_cubit:
                    cubit_code = gen_cubit
                if missing_state and gen_state:
                    state_code = gen_state

            return {
                "screen": screen_code,
                "cubit": cubit_code or "",
                "state": state_code or "",
                "packages": packages_code or "",
            }

        has_open_screen = "<screen>" in raw_text
        has_close_screen = "</screen>" in raw_text

        if has_open_screen and not has_close_screen:
            if attempt < max_retries - 1:
                current_max_tokens = min(current_max_tokens * 2, 64000)
                print(f"\n      ⚠️ Response bị truncate (stop_reason={stop_reason}). Retry với {current_max_tokens} tokens...")
                prompt = (
                        original_prompt
                        + "\n\nCRITICAL: Keep code compact. Extract repeated widgets into _buildXxx methods. "
                          "You MUST close </screen></cubit></state></packages>."
                )
                continue

            raise ValueError(
                f"AI response was truncated before </screen>:\n{raw_text[:1000]}"
            )

        if attempt < max_retries - 1:
            prompt = (
                    original_prompt
                    + "\n\nRESPONSE FORMAT ERROR: Return ONLY valid XML with fully closed tags: "
                      "<screen></screen><cubit></cubit><state></state><packages></packages>"
            )
            continue

    raise ValueError(f"AI response missing valid <screen> block:\n{last_raw_text[:1000]}")
