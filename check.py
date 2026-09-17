import json
import glob

print("--- ipynb 파일 손상 검사 시작 ---")
for filepath in glob.glob(r'C:\ai\**\*.ipynb', recursive=True):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            json.load(f)
    except Exception as e:
        print(f"\n[손상된 파일] {filepath}")
        print(f"[에러 원인] {e}")
print("\n--- 검사 완료 ---")