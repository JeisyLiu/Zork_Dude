import ast
from pathlib import Path

path = Path(__file__).with_name("zork_game.py")
code = path.read_text(encoding="utf-8")
print(f"File size: {len(code)} chars")
try:
    ast.parse(code)
    print("Syntax OK!")
except SyntaxError as e:
    print(f"Syntax error at line {e.lineno}: {e.msg}")
    print(f"   Text: {e.text}")
