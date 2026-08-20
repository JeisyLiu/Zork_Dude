#!/usr/bin/env python3
"""Generate 512x512 PNG achievement icons by square-cropping game art.

Does NOT letterbox whole wide scenes into a strip — crops a 1:1 region first,
then resizes to 512. Crop focus is (fx, fy) in 0..1 normalized image coords
(0.5, 0.5 = center). Optional zoom > 1 crops a smaller square (tighter shot).

Usage:
  python tool/generate_achievement_icons.py
  python tool/generate_achievement_icons.py --only awaken,ending_dragon
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Run: pip install pillow")
    raise SystemExit(1)

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "flutter_app" / "assets" / "images"
OUT = ROOT / "store" / "achievement_icons"
SIZE = 512


@dataclass(frozen=True)
class CropSpec:
    """Source under assets/images + focus + optional zoom."""

    rel: str
    fx: float = 0.5
    fy: float = 0.5
    zoom: float = 1.0  # 1 = largest inscribed square; 1.4 = tighter


# Recommended reuse crops (see image_prompt.md / prior review).
SOURCES: dict[str, CropSpec] = {
    # Tower emblem — already square; slight center
    "awaken": CropSpec("home/mist_tower_hero.png", 0.50, 0.48, 1.05),
    # Sword + gold pile (lower half of victory panel)
    "first_victory": CropSpec("fx/combat_victory.png", 0.52, 0.72, 1.35),
    # Lantern traveler (journey complete left)
    "first_recruit": CropSpec("ending/journey_complete.png", 0.28, 0.62, 1.45),
    # Vault door seal / chamber (site ending doors)
    "first_quest": CropSpec("ending/site_clear.png", 0.22, 0.45, 1.50),
    # Cave fork / tunnel mouth
    "enter_cave": CropSpec("exploration/bg_cave.png", 0.35, 0.48, 1.15),
    # Arch + mist mountains
    "enter_tower": CropSpec("exploration/bg_tower.png", 0.38, 0.42, 1.20),
    # Open gate / door seal
    "site_gate": CropSpec("ending/site_clear.png", 0.72, 0.48, 1.40),
    # Site vault door at corridor end
    "enter_site": CropSpec("exploration/bg_site.png", 0.55, 0.42, 1.25),
    # Distant mist town on surface path
    "explore_20": CropSpec("exploration/bg_surface.png", 0.52, 0.38, 1.30),
    # Tower hall lantern (distinct from enter_tower vista)
    "explore_40": CropSpec("exploration/bg_tower.png", 0.48, 0.35, 1.55),
    # Shadow foe (upper combat victory)
    "battles_10": CropSpec("fx/combat_victory.png", 0.55, 0.28, 1.40),
    # Sword + coins again, slightly wider for “seasoned”
    "battles_25": CropSpec("fx/combat_victory.png", 0.50, 0.55, 1.15),
    # Dragon head + gem
    "ending_dragon": CropSpec("ending/dragon_clear.png", 0.62, 0.55, 1.35),
    # Dissolving tower top
    "ending_main": CropSpec("ending/journey_complete.png", 0.62, 0.32, 1.40),
    # Central glowing crystal
    "ending_site": CropSpec("ending/site_clear.png", 0.50, 0.42, 1.45),
    # Adventurer + tower mist (party stand-in until dedicated art)
    "full_party": CropSpec("fx/combat_victory.png", 0.48, 0.48, 1.10),
    # Clearing mist tower (second cycle)
    "ng_plus": CropSpec("ending/journey_complete.png", 0.58, 0.35, 1.25),
    # Hero tower emblem
    "score_1000": CropSpec("home/mist_tower_hero.png", 0.50, 0.42, 1.25),
    # Gold pile for high score
    "high_score": CropSpec("fx/combat_victory.png", 0.55, 0.82, 1.60),
}


def square_crop(img: Image.Image, fx: float, fy: float, zoom: float) -> Image.Image:
    w, h = img.size
    side = min(w, h) / max(zoom, 1.0)
    cx = fx * w
    cy = fy * h
    left = cx - side / 2
    top = cy - side / 2
    # Clamp inside image
    left = max(0.0, min(left, w - side))
    top = max(0.0, min(top, h - side))
    box = (int(left), int(top), int(left + side), int(top + side))
    return img.crop(box)


def render(spec: CropSpec) -> Image.Image:
    src = ASSETS / spec.rel
    if not src.exists():
        raise FileNotFoundError(src)
    img = Image.open(src).convert("RGBA")
    cropped = square_crop(img, spec.fx, spec.fy, spec.zoom)
    return cropped.resize((SIZE, SIZE), Image.Resampling.NEAREST)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--only",
        help="Comma-separated local ids to regenerate",
        default="",
    )
    args = parser.parse_args()
    only = {s.strip() for s in args.only.split(",") if s.strip()}

    OUT.mkdir(parents=True, exist_ok=True)
    for local_id, spec in SOURCES.items():
        if only and local_id not in only:
            continue
        try:
            out_img = render(spec)
        except FileNotFoundError as e:
            print(f"skip {local_id}: missing {e}")
            continue
        out = OUT / f"{local_id}.png"
        out_img.save(out, "PNG")
        print(f"wrote {out.name}  <- {spec.rel}  focus=({spec.fx:.2f},{spec.fy:.2f}) zoom={spec.zoom}")
    print(f"done -> {OUT}")


if __name__ == "__main__":
    main()
