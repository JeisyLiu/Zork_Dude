import ast
with open("zork_game.py", "r", encoding="utf-8") as f:
    code = f.read()
print(f"File size: {len(code)} chars")
try:
    ast.parse(code)
    print("✅ Syntax OK!")
except SyntaxError as e:
    print(f"❌ Syntax error at line {e.lineno}: {e.msg}")
    print(f"   Text: {e.text}")
