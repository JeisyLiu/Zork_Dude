#!/usr/bin/env python3
"""Build Play Console PGS achievements import ZIP (English default + zh-CN).

Output:
  store/pgs_achievements_import/
    AchievementsMetadata.csv
    AchievementsLocalizations.csv
    AchievementsIconsMappings.csv
    *.png (copies, flat)
    achievements_import.zip

Upload: Play Console → Play Games Services → Achievements → Import achievements
Enable zh-CN under Configuration → Manage Translations before import if needed.
Leaderboard high_score is NOT included (create manually).
"""

from __future__ import annotations

import csv
import shutil
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ICONS = ROOT / "store" / "achievement_icons"
OUT = ROOT / "store" / "pgs_achievements_import"
ZIP_PATH = OUT / "achievements_import.zip"

# Already created manually in Play Console — omit from import ZIP.
SKIP_IDS = frozenset({"awaken"})

# English Name is the join key across CSVs (default locale text).
ACHIEVEMENTS: list[dict[str, object]] = [
    {
        "id": "awaken",
        "en_name": "Awakening",
        "en_desc": "Step into the mist forest and begin your journey.",
        "zh_name": "雾中苏醒",
        "zh_desc": "踏入迷雾森林，开始旅程。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 5,
        "order": 1,
    },
    {
        "id": "first_victory",
        "en_name": "First Victory",
        "en_desc": "Win your first battle.",
        "zh_name": "初战告捷",
        "zh_desc": "赢得第一场战斗。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 10,
        "order": 2,
    },
    {
        "id": "first_recruit",
        "en_name": "Companions",
        "en_desc": "Recruit your first companion.",
        "zh_name": "结伴而行",
        "zh_desc": "招募第一位队友。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 15,
        "order": 3,
    },
    {
        "id": "first_quest",
        "en_name": "Trusted",
        "en_desc": "Complete your first NPC quest.",
        "zh_name": "受托之人",
        "zh_desc": "完成第一个 NPC 委托。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 15,
        "order": 4,
    },
    {
        "id": "enter_cave",
        "en_name": "Into the Deep",
        "en_desc": "Enter the cave layer for the first time.",
        "zh_name": "深入地下",
        "zh_desc": "首次进入洞穴层。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 20,
        "order": 5,
    },
    {
        "id": "enter_tower",
        "en_name": "Tower Ahead",
        "en_desc": "Reach the tower layer for the first time.",
        "zh_name": "塔影将至",
        "zh_desc": "首次登上高塔层。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 25,
        "order": 6,
    },
    {
        "id": "site_gate",
        "en_name": "Stone Gate Opens",
        "en_desc": "Open the path to the containment site with the magic gem.",
        "zh_name": "石门洞开",
        "zh_desc": "持魔法宝石打开通往收容站的石门。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 30,
        "order": 7,
    },
    {
        "id": "enter_site",
        "en_name": "Beneath Containment",
        "en_desc": "Enter the Foundation containment site for the first time.",
        "zh_name": "收容之下",
        "zh_desc": "首次踏入基金会收容站点。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 35,
        "order": 8,
    },
    {
        "id": "explore_20",
        "en_name": "Mist Pages",
        "en_desc": "Explore at least 20 rooms.",
        "zh_name": "迷雾残页",
        "zh_desc": "探索至少 20 个场景。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 25,
        "order": 9,
    },
    {
        "id": "explore_40",
        "en_name": "Charting the Fog",
        "en_desc": "Explore at least 40 rooms.",
        "zh_name": "雾图将满",
        "zh_desc": "探索至少 40 个场景。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 40,
        "order": 10,
    },
    {
        "id": "battles_10",
        "en_name": "Ten Battles",
        "en_desc": "Win 10 battles in total.",
        "zh_name": "十战迷雾",
        "zh_desc": "累计赢得 10 场战斗。",
        "incremental": True,
        "steps": 10,
        "state": "Revealed",
        "points": 20,
        "order": 11,
    },
    {
        "id": "battles_25",
        "en_name": "Seasoned Fighter",
        "en_desc": "Win 25 battles in total.",
        "zh_name": "百战将启",
        "zh_desc": "累计赢得 25 场战斗。",
        "incremental": True,
        "steps": 25,
        "state": "Revealed",
        "points": 40,
        "order": 12,
    },
    {
        "id": "ending_dragon",
        "en_name": "Dragon Fell",
        "en_desc": "Defeat the young dragon atop the tower and claim the magic gem.",
        "zh_name": "幼龙已陨落",
        "zh_desc": "击败塔顶幼龙，取得魔法宝石。",
        "incremental": False,
        "steps": "",
        "state": "Revealed",
        "points": 40,
        "order": 13,
    },
    {
        "id": "ending_main",
        "en_name": "Mist Cleared",
        "en_desc": "Use the magic gem at the tower's peak to restore your memories and break the curse.",
        "zh_name": "迷雾消散",
        "zh_desc": "在塔顶使用魔法宝石，找回记忆并打破迷雾诅咒。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 50,
        "order": 14,
    },
    {
        "id": "ending_site",
        "en_name": "Site Secured",
        "en_desc": "Defeat the containment site's final boss and complete the operation.",
        "zh_name": "站点行动完成",
        "zh_desc": "击败收容站最终 BOSS，完成站点行动。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 50,
        "order": 15,
    },
    {
        "id": "full_party",
        "en_name": "Full Party",
        "en_desc": "Recruit all 7 companions.",
        "zh_name": "全员集结",
        "zh_desc": "招募全部 7 名队友。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 75,
        "order": 16,
    },
    {
        "id": "ng_plus",
        "en_name": "New Cycle",
        "en_desc": "Start a New Game Plus run.",
        "zh_name": "二周目旅人",
        "zh_desc": "开启二周目旅程。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 50,
        "order": 17,
    },
    {
        "id": "score_1000",
        "en_name": "Thousand Mist",
        "en_desc": "Reach a score of 1000 in a single run.",
        "zh_name": "千分迷雾",
        "zh_desc": "单局得分达到 1000。",
        "incremental": False,
        "steps": "",
        "state": "Hidden",
        "points": 50,
        "order": 18,
    },
]


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--with-zh",
        action="store_true",
        help="Include AchievementsLocalizations.csv (zh-CN). "
        "Only use after enabling zh-CN in PGS Manage Translations.",
    )
    parser.add_argument(
        "--include-skipped",
        action="store_true",
        help="Also pack IDs listed in SKIP_IDS (default: omit already-created).",
    )
    args = parser.parse_args()

    rows = list(ACHIEVEMENTS)
    if not args.include_skipped:
        rows = [a for a in rows if a["id"] not in SKIP_IDS]

    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir(parents=True)

    meta_path = OUT / "AchievementsMetadata.csv"
    loc_path = OUT / "AchievementsLocalizations.csv"
    map_path = OUT / "AchievementsIconsMappings.csv"

    with meta_path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        for a in rows:
            w.writerow(
                [
                    a["en_name"],
                    a["en_desc"],
                    "True" if a["incremental"] else "False",
                    a["steps"],
                    a["state"],
                    a["points"],
                    a["order"],
                ]
            )

    # Always write localizations for later; only zip when --with-zh.
    with loc_path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        for a in rows:
            w.writerow([a["en_name"], a["zh_name"], a["zh_desc"], "zh-CN"])

    with map_path.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        for a in rows:
            icon_name = f'{a["id"]}.png'
            src = ICONS / icon_name
            if not src.exists():
                raise FileNotFoundError(f"Missing icon: {src}")
            shutil.copy2(src, OUT / icon_name)
            w.writerow([a["en_name"], icon_name])

    zip_names = {
        "AchievementsMetadata.csv",
        "AchievementsIconsMappings.csv",
        *(f'{a["id"]}.png' for a in rows),
    }
    if args.with_zh:
        zip_names.add("AchievementsLocalizations.csv")

    with zipfile.ZipFile(ZIP_PATH, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(OUT.iterdir()):
            if path.name not in zip_names:
                continue
            zf.write(path, arcname=path.name)

    names = zipfile.ZipFile(ZIP_PATH).namelist()
    skipped = sorted(SKIP_IDS) if not args.include_skipped else []
    print(f"wrote {meta_path.relative_to(ROOT)} ({len(rows)} achievements)")
    print(f"wrote {loc_path.relative_to(ROOT)} (on disk; in ZIP={args.with_zh})")
    print(f"wrote {map_path.relative_to(ROOT)}")
    print(f"copied {len(rows)} icons")
    if skipped:
        print(f"omitted (already in Console): {', '.join(skipped)}")
    print(f"ZIP {ZIP_PATH.relative_to(ROOT)} ({ZIP_PATH.stat().st_size} bytes, {len(names)} entries)")


if __name__ == "__main__":
    main()
