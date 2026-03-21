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

def _call_ai_code(prompt, max_retries=3):
    last_raw_text = ""

    for attempt in range(max_retries):
        try:
            response = client.messages.create(
                model=model_name,
                max_tokens=10000,
                temperature=0.2,
                messages=[{"role": "user", "content": prompt}],
            )
        except anthropic.RateLimitError:
            wait_time = 20 * (attempt + 1)
            print(f"\n      ⏳ Đụng trần Token. Đang đợi {wait_time}s... (Lần {attempt + 1}/{max_retries})")
            time.sleep(wait_time)
            continue
        except anthropic.APIError as e:
            if "overloaded" in str(e).lower() or getattr(e, 'status_code', 500) in [529, 502, 503, 504]:
                wait_time = 15
                print(f"\n      ⚠️ Máy chủ AI quá tải. Đang đợi {wait_time}s... (Lần {attempt + 1}/{max_retries})")
                time.sleep(wait_time)
                continue
            raise

        raw_text = response.content[0].text.strip()
        last_raw_text = raw_text

        def extract_tag(tag, text):
            match = re.search(rf"<{tag}>\s*(.*?)\s*</{tag}>", text, re.DOTALL)
            if not match:
                return None
            return match.group(1).strip().replace("```dart", "").replace("```", "").strip()

        screen_code = extract_tag("screen", raw_text)
        cubit_code = extract_tag("cubit", raw_text)
        state_code = extract_tag("state", raw_text)
        packages_code = extract_tag("packages", raw_text)

        if screen_code is not None:
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
                prompt = (
                        prompt
                        + "\n\nRESPONSE WAS TRUNCATED. "
                          "Return AGAIN with the SAME content but shorter, compact, and fully closed XML tags. "
                          "You MUST finish </screen></cubit></state></packages>."
                )
                continue

            raise ValueError(
                f"AI response was truncated before </screen>:\n{raw_text[:1000]}"
            )

        if attempt < max_retries - 1:
            prompt = (
                    prompt
                    + "\n\nRESPONSE FORMAT ERROR: previous response missing valid XML tags. "
                      "Return ONLY valid XML with fully closed tags: "
                      "<screen></screen><cubit></cubit><state></state><packages></packages>"
            )
            continue

    raise ValueError(f"AI response missing valid <screen> block:\n{last_raw_text[:1000]}")
