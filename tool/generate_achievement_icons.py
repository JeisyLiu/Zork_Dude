#!/usr/bin/env python3
"""Generate 512x512 PNG achievement icons for Play Console upload."""

from __future__ import annotations

from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Run: pip install pillow")
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "flutter_app" / "assets" / "images"
OUT = ROOT / "store" / "achievement_icons"

# local_id -> relative path under assets/images
SOURCES = {
    "awaken": "home/mist_tower_hero.png",
    "first_victory": "fx/combat_victory.png",
    "first_recruit": "exploration/bg_surface.png",
    "first_quest": "exploration/bg_site.png",
    "enter_cave": "exploration/bg_cave.png",
    "enter_tower": "exploration/bg_tower.png",
    "site_gate": "ending/site_clear.png",
    "enter_site": "exploration/bg_site.png",
    "explore_20": "exploration/bg_surface.png",
    "explore_40": "exploration/bg_tower.png",
    "battles_10": "fx/battle_start_banner.png",
    "battles_25": "fx/encounter_banner.png",
    "ending_dragon": "ending/dragon_clear.png",
    "ending_main": "ending/journey_complete.png",
    "ending_site": "ending/site_clear.png",
    "full_party": "fx/combat_victory.png",
    "ng_plus": "ending/journey_complete.png",
    "score_1000": "home/mist_tower_hero.png",
    "high_score": "fx/combat_victory.png",
}

SIZE = 512


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for local_id, rel in SOURCES.items():
        src = ASSETS / rel
        if not src.exists():
            print(f"skip {local_id}: missing {src}")
            continue
        img = Image.open(src).convert("RGBA")
        img.thumbnail((SIZE, SIZE), Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", (SIZE, SIZE), (18, 16, 12, 255))
        x = (SIZE - img.width) // 2
        y = (SIZE - img.height) // 2
        canvas.paste(img, (x, y), img)
        out = OUT / f"{local_id}.png"
        canvas.save(out, "PNG")
        print(f"wrote {out.name}")
    print(f"done -> {OUT}")


if __name__ == "__main__":
    main()
