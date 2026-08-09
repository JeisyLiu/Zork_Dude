#!/usr/bin/env python3
"""Generate localized messages, world data, and UI ARB files from zh_Hans."""

from __future__ import annotations

import json
import re
import sys
import time
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    print("Run: pip install deep-translator")
    sys.exit(1)

ROOT = Path(__file__).resolve().parent.parent

LOCALES = [
    "zh_Hans",
    "zh_Hant",
    "en_US",
    "ja",
    "ko",
    "fr",
    "de",
    "it",
    "es_ES",
    "pt_BR",
]

DATA_FILES = [
    "items.json",
    "monsters.json",
    "npcs.json",
    "companions.json",
    "rooms.json",
    "status_effects.json",
]

TRANSLATABLE_FIELDS = {
    "name",
    "desc",
    "title",
    "use_msg",
    "ability_desc",
    "recruit_msg",
    "taunt",
}

TARGET = {
    "zh_Hant": "zh-TW",
    "en_US": "en",
    "ja": "ja",
    "ko": "ko",
    "fr": "fr",
    "de": "de",
    "it": "it",
    "es_ES": "es",
    "pt_BR": "pt",
}

ARB_TARGETS = {
    "ja": "ja",
    "ko": "ko",
    "fr": "fr",
    "de": "de",
    "it": "it",
    "es": "es",
    "es_ES": "es_ES",
    "pt": "pt",
    "pt_BR": "pt_BR",
}

PH_RE = re.compile(r"\{[a-zA-Z0-9_]+\}")
BATCH = 40


def protect(text: str) -> tuple[str, list[str]]:
    placeholders: list[str] = []

    def stash(m: re.Match[str]) -> str:
        placeholders.append(m.group(0))
        return f"__PH{len(placeholders) - 1}__"

    return PH_RE.sub(stash, text), placeholders


def restore(text: str, placeholders: list[str]) -> str:
    out = text
    for i, ph in enumerate(placeholders):
        out = out.replace(f"__PH{i}__", ph)
    return out


def batch_translate(strings: list[str], locale: str) -> dict[str, str]:
    if locale == "zh_Hans":
        return {s: s for s in strings}
    protected: list[str] = []
    holders: list[list[str]] = []
    for s in strings:
        p, h = protect(s)
        protected.append(p)
        holders.append(h)

    out: dict[str, str] = {}
    t = GoogleTranslator(source="zh-CN", target=TARGET[locale])
    for i in range(0, len(protected), BATCH):
        chunk = protected[i : i + BATCH]
        try:
            translated = t.translate_batch(chunk)
        except Exception as e:
            print(f"  batch warn ({locale}): {e!r}, falling back per-item")
            translated = []
            for item in chunk:
                try:
                    translated.append(t.translate(item))
                except Exception:
                    translated.append(item)
                time.sleep(0.05)
        for src, prot, tr, h in zip(
            strings[i : i + BATCH], chunk, translated, holders[i : i + BATCH]
        ):
            out[src] = restore(tr, h)
        print(f"  {locale}: {min(i + BATCH, len(strings))}/{len(strings)}")
        time.sleep(0.15)
    return out


def translate_messages(locale: str, table: dict[str, str]) -> None:
    src = json.loads(
        (ROOT / "assets/l10n/messages/zh_Hans.json").read_text(encoding="utf-8")
    )
    out_path = ROOT / f"assets/l10n/messages/{locale}.json"
    translated = {k: table[v] for k, v in src.items()}
    out_path.write_text(
        json.dumps(translated, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def translate_world_node(node, table: dict[str, str]):
    if isinstance(node, dict):
        out = {}
        for k, v in node.items():
            if k == "dialogs" and isinstance(v, dict):
                out[k] = {dk: table[dv] for dk, dv in v.items()}
            elif k in TRANSLATABLE_FIELDS and isinstance(v, str):
                out[k] = table[v]
            else:
                out[k] = translate_world_node(v, table)
        return out
    if isinstance(node, list):
        return [translate_world_node(x, table) for x in node]
    return node


def collect_world_strings(node, acc: set[str]) -> None:
    if isinstance(node, dict):
        for k, v in node.items():
            if k in TRANSLATABLE_FIELDS and isinstance(v, str):
                acc.add(v)
            elif k == "dialogs" and isinstance(v, dict):
                for dv in v.values():
                    if isinstance(dv, str):
                        acc.add(dv)
            else:
                collect_world_strings(v, acc)
    elif isinstance(node, list):
        for x in node:
            collect_world_strings(x, acc)


def translate_world_data(locale: str, table: dict[str, str]) -> None:
    src_dir = ROOT / "assets/data/l10n/zh_Hans"
    out_dir = ROOT / f"assets/data/l10n/{locale}"
    out_dir.mkdir(parents=True, exist_ok=True)
    for fname in DATA_FILES:
        src = json.loads((src_dir / fname).read_text(encoding="utf-8"))
        out = translate_world_node(src, table)
        (out_dir / fname).write_text(
            json.dumps(out, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


def translate_arbs(locale_tag: str, table: dict[str, str]) -> None:
    zh = json.loads((ROOT / "lib/l10n/app_zh_Hans.arb").read_text(encoding="utf-8"))
    if locale_tag == "zh_Hant":
        locale = "zh_Hant"
    else:
        locale = ARB_TARGETS[locale_tag]
    out: dict = {"@@locale": locale}
    for key, val in zh.items():
        if key == "@@locale":
            continue
        if key.startswith("@"):
            out[key] = val
            continue
        out[key] = table[val]
    (ROOT / f"lib/l10n/app_{locale_tag}.arb").write_text(
        json.dumps(out, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def sync_fallback_arbs() -> None:
    zh_hans = json.loads(
        (ROOT / "lib/l10n/app_zh_Hans.arb").read_text(encoding="utf-8")
    )
    en_us = json.loads(
        (ROOT / "lib/l10n/app_en_US.arb").read_text(encoding="utf-8")
    )
    zh = dict(zh_hans)
    zh["@@locale"] = "zh"
    en = dict(en_us)
    en["@@locale"] = "en"
    (ROOT / "lib/l10n/app_zh.arb").write_text(
        json.dumps(zh, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    (ROOT / "lib/l10n/app_en.arb").write_text(
        json.dumps(en, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )


def collect_all_strings() -> list[str]:
    unique: set[str] = set()
    msgs = json.loads(
        (ROOT / "assets/l10n/messages/zh_Hans.json").read_text(encoding="utf-8")
    )
    unique.update(msgs.values())
    src_dir = ROOT / "assets/data/l10n/zh_Hans"
    for fname in DATA_FILES:
        collect_world_strings(
            json.loads((src_dir / fname).read_text(encoding="utf-8")), unique
        )
    zh = json.loads((ROOT / "lib/l10n/app_zh_Hans.arb").read_text(encoding="utf-8"))
    for key, val in zh.items():
        if not key.startswith("@") and key != "@@locale" and isinstance(val, str):
            unique.add(val)
    return sorted(unique)


def main() -> None:
    strings = collect_all_strings()
    print(f"unique source strings: {len(strings)}", flush=True)
    tables: dict[str, dict[str, str]] = {}
    for locale in LOCALES:
        if locale == "zh_Hans":
            continue
        print(f"translating -> {locale}", flush=True)
        tables[locale] = batch_translate(strings, locale)
        translate_messages(locale, tables[locale])
        translate_world_data(locale, tables[locale])

    arb_from_locale = {
        "ja": "ja",
        "ko": "ko",
        "fr": "fr",
        "de": "de",
        "it": "it",
        "es_ES": "es_ES",
        "pt_BR": "pt_BR",
    }
    for tag, locale in arb_from_locale.items():
        print(f"arb -> app_{tag}.arb", flush=True)
        translate_arbs(tag, tables[locale])

    # zh_Hant UI arb from translation table
    if "zh_Hant" in tables:
        print("arb -> app_zh_Hant.arb", flush=True)
        translate_arbs("zh_Hant", tables["zh_Hant"])

    es_es = json.loads(
        (ROOT / "lib/l10n/app_es_ES.arb").read_text(encoding="utf-8")
    )
    es = dict(es_es)
    es["@@locale"] = "es"
    (ROOT / "lib/l10n/app_es.arb").write_text(
        json.dumps(es, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    pt_br = json.loads(
        (ROOT / "lib/l10n/app_pt_BR.arb").read_text(encoding="utf-8")
    )
    pt = dict(pt_br)
    pt["@@locale"] = "pt"
    (ROOT / "lib/l10n/app_pt.arb").write_text(
        json.dumps(pt, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    sync_fallback_arbs()
    print("done", flush=True)


if __name__ == "__main__":
    main()
