import os

def read_file(path):
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f: return f.read()
    return ""

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f: f.write(content)