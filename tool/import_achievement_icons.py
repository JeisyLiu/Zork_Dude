#!/usr/bin/env python3
"""Move staged AI achievement icons from assets/images to store/achievement_icons at 512x512."""

from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "flutter_app" / "assets" / "images"
OUT = ROOT / "store" / "achievement_icons"
SIZE = 512
IDS = [
    "first_recruit",
    "first_quest",
    "explore_40",
    "battles_10",
    "battles_25",
    "full_party",
    "ng_plus",
    "score_1000",
    "high_score",
]


def to_square_512(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    cropped = img.crop((left, top, left + side, top + side))
    scale = side / SIZE
    resample = (
        Image.Resampling.NEAREST
        if abs(scale - round(scale)) < 0.05
        else Image.Resampling.LANCZOS
    )
    return cropped.resize((SIZE, SIZE), resample)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for local_id in IDS:
        src = SRC / f"{local_id}.png"
        if not src.exists():
            print(f"MISS {src}")
            continue
        img = Image.open(src)
        out_img = to_square_512(img)
        dest = OUT / f"{local_id}.png"
        out_img.save(dest, "PNG", optimize=True)
        src.unlink()
        print(
            f"OK {local_id}: {img.size[0]}x{img.size[1]} -> 512x512  "
            f"{dest.relative_to(ROOT)}  (removed staging)"
        )

    leftover = [p.name for p in SRC.glob("*.png") if p.stem in IDS]
    print("leftover staging:", leftover or "none")


if __name__ == "__main__":
    main()
