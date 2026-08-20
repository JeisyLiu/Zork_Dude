# 版本说明目录

本目录存放各版本更新说明与 Play Console 商店列表文案。

## 结构

| 路径 | 说明 |
|------|------|
| `{version}.md` | 该版本更新说明（单文件内含全部支持语种） |
| `store/{locale}/listing.md` | 对应语言的商店标题 / 短描述 / 完整描述 |

## 支持语种与国家 / 地区映射

与 [`flutter_app/lib/l10n/locale_tag.dart`](../flutter_app/lib/l10n/locale_tag.dart) 一致。  
下表「系统语言识别」按 `LocaleTag.fromLocale`：只要系统 `languageCode`（及中文的 script/country）命中，即选用对应语言包；**不等于**仅限该国用户。

| 内部 tag | 显示名 | Material / ARB 区域 | 系统语言如何落到本包 | 典型国家 / 地区 |
|----------|--------|---------------------|----------------------|-----------------|
| `zh_Hans` | 简体中文 | `zh` + Hans | `zh` 且非繁体判定 | 中国大陆、新加坡等（默认中文） |
| `zh_Hant` | 繁體中文 | `zh` + Hant | `zh` + script Hant，或 country `TW` / `HK` / `MO` | 台湾、香港、澳门 |
| `en_US` | English | `en_US` | 任意 `en*` | 美国及所有英语区（英/澳/加等共用美式文案） |
| `ja` | 日本語 | `ja` | `ja` | 日本 |
| `ko` | 한국어 | `ko` | `ko` | 韩国 |
| `fr` | Français | `fr` | `fr` | 法国及法语区（未再分 fr-CA 等） |
| `de` | Deutsch | `de` | `de` | 德国及德语区（未再分 de-AT / de-CH） |
| `it` | Italiano | `it` | `it` | 意大利及意大利语区 |
| `es_ES` | Español | `es_ES` | 任意 `es*` | 西班牙及所有西语区（拉美共用西班牙文案） |
| `pt_BR` | Português (Brasil) | `pt_BR` | 任意 `pt*` | 巴西及所有葡语区（含葡萄牙，共用巴西文案） |
| `ru` | Русский | `ru` | `ru` | 俄罗斯及俄语区 |

**未识别语言**：回退 `en_US`（与 [`LocaleTag.fallback`](../flutter_app/lib/l10n/locale_tag.dart) 一致）。

**商店列表**（`store/{locale}/`）与上表 11 个 tag 一一对应；Play Console 发布说明标签见各版本文件（如 `0.9.13.md` 中的 `<zh-CN>` / `<en-US>` 等）。

## 发版时怎么用

1. 新建 / 更新 `{version}.md`（「What's new」，每语言 ≤500 字符）
2. 抬高 `flutter_app/pubspec.yaml` 的 `x.y.z+N`（`+N` = `versionCode`，每次上架必须增加）
3. 按 [docs/PLAY_CONSOLE_RUNBOOK.md](../docs/PLAY_CONSOLE_RUNBOOK.md) §4 打 AAB、上传轨道、设置 **In-app update priority**（0–3 软更，4–5 必更）
4. 勾选 [TODO_LIST.md](../TODO_LIST.md) §3；内测验收见 [docs/INTERNAL_TEST_CHECKLIST.md](../docs/INTERNAL_TEST_CHECKLIST.md)

## 合规与素材

Data Safety、内容分级、截图清单见 [docs/STORE_LISTING.md](../docs/STORE_LISTING.md)。

## 版本列表

- [0.9.14](0.9.14.md) — 当前
- [0.9.13](0.9.13.md)
- [0.9.12](0.9.12.md)
- [0.9.11](0.9.11.md)
- [0.9.10](0.9.10.md)
- [0.9.9](0.9.9.md)
- [0.9.6-0.9.7-0.9.8](0.9.6-0.9.7-0.9.8.md)
- [0.9.4-0.9.5](0.9.4-0.9.5.md)
- [0.9.3](0.9.3.md)
- [0.9.1-0.9.2](0.9.1-0.9.2.md)
- [0.9.1](0.9.1.md)
