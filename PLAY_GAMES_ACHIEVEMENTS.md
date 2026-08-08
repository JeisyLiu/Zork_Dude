# Play Games Console — 成就与排行榜文案

在 Google Play Console：

**Grow users → Play Games Services → Setup and management → Achievements / Leaderboards**

按下面每一条创建。名称、描述可直接复制。创建完成后 **Publish** PGS 配置，再把生成的 ID 填回工程。

包名：`com.zorkdude.zork_dude`  
游戏名：迷雾之塔 / Mist Tower

---

## 成就 1 / 3

**本地逻辑 ID（代码用，勿填进 Console 名称栏）**  
`ending_dragon`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name（名称） | 幼龙已陨落 |
| Description（描述） | 击败塔顶幼龙，取得魔法宝石。 |
| Initial state（初始状态） | Revealed（显示） |
| Points（经验值） | 20 |
| Incremental（增量） | No（否，标准一次解锁） |
| List order（列表顺序） | 1 |

**触发说明（给自己看，不必贴 Console）**  
战斗胜利且击败 `dragon_whelp` → `EndingKind.dragonClear`

---

## 成就 2 / 3

**本地逻辑 ID**  
`ending_site`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name（名称） | 站点行动完成 |
| Description（描述） | 击败收容站最终 BOSS，完成站点行动。 |
| Initial state（初始状态） | Revealed（显示） |
| Points（经验值） | 50 |
| Incremental（增量） | No |
| List order（列表顺序） | 2 |

**触发说明**  
战斗胜利且击败 `scp_001` → `EndingKind.siteClear`

---

## 成就 3 / 3

**本地逻辑 ID**  
`ending_main`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name（名称） | 迷雾消散 |
| Description（描述） | 在塔顶使用魔法宝石，找回记忆并打破迷雾诅咒。 |
| Initial state（初始状态） | Revealed（显示） |
| Points（经验值） | 100 |
| Incremental（增量） | No |
| List order（列表顺序） | 3 |

**触发说明**  
主线通关 → `EndingKind.mainClear` / `session.won == true`

---

## 排行榜 1 / 1

**本地逻辑 ID**  
`high_score`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name（名称） | 最高得分 |
| Score formatting（分数格式） | Numeric（数值） |
| Sort order（排序） | Larger is better（越大越好） |
| Ordering（展示） | Higher scores are better |
| Score unit / Format | 整数得分（无小数） |
| Number of decimal places | 0 |
| Refresh type / 时间范围 | 允许日榜 / 周榜 / 全部时间（默认即可） |

**提交说明**  
本地 `session.score` 的历史最高分；仅当新分更高时提交。

---

## 图标（Console 必传）

每个成就需要解锁图标（通常还需锁定态）。建议：

- 尺寸按 Console 当前提示（常见为 512×512）
- 风格与游戏 UI 一致，三成就图标可区分：幼龙 / 站点 / 塔顶宝石
- 排行榜也可上传图标（按 Console 是否必填）

图标文件可放在本地素材目录，创建成就时上传；本文件不附二进制资源。

---

## 创建后回填工程

1. Console → Play Games Services → Configuration → **Get resources**
2. 用导出的字符串替换：

`flutter_app/android/app/src/main/res/values/games-ids.xml`

```xml
<!-- 示例结构；值为 Console 导出结果 -->
<string name="app_id" translatable="false">……</string>
<string name="achievement_ending_dragon" translatable="false">CgkI……</string>
<string name="achievement_ending_site" translatable="false">CgkI……</string>
<string name="achievement_ending_main" translatable="false">CgkI……</string>
<string name="leaderboard_high_score" translatable="false">CgkI……</string>
```

3. 同步替换 `flutter_app/lib/services/play_games/play_games_ids.dart` 中的占位符：

| 本地 ID | Dart 映射键 |
|---------|-------------|
| `ending_dragon` | `PlayGamesLocalId.endingDragon` |
| `ending_site` | `PlayGamesLocalId.endingSite` |
| `ending_main` | `PlayGamesLocalId.endingMain` |
| `high_score` | `PlayGamesLocalId.highScore` |

4. 勾选 [TODO_LIST.md](./TODO_LIST.md) 中「回填 ID」相关项。

---

## 英文备用（若 Console 语言/商店面向海外）

可选：在 Console 为英文地区添加本地化，或直接用下列英文作为主名称。

| 本地 ID | Name | Description |
|---------|------|-------------|
| `ending_dragon` | Dragon Fell | Defeat the young dragon atop the tower and claim the magic gem. |
| `ending_site` | Site Secured | Defeat the containment site’s final boss and complete the operation. |
| `ending_main` | Mist Cleared | Use the magic gem at the tower’s peak to restore your memories and break the curse. |
| `high_score` | High Score | Highest score earned in Mist Tower. |
