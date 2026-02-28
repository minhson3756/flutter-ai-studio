import anthropic
import os
from dotenv import load_dotenv

load_dotenv()
client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

def generate_feature_code(feature_name, screens_json, lazy_spec_text, architecture_rules):
    prompt = f"""
    --- BASE RULES ---
    {architecture_rules}
    
    --- UI ELEMENTS ---
    {screens_json}
    
    --- FEATURE REQUIREMENT ---
    {lazy_spec_text}
    
    Hãy viết code cho feature: {feature_name}.
    Yêu cầu trả về đúng định dạng JSON có 3 key: 'screen', 'cubit', 'state'.
    Chỉ trả về JSON hợp lệ, không markdown, không giải thích.
    """

    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4000,
        temperature=0.1,
        messages=[{"role": "user", "content": prompt}]
    )

    import json
    return json.loads(response.content[0].text.strip())