# Play Games Console — 成就与排行榜文案（18 成就）

在 Google Play Console：

**Grow users → Play Games Services → Setup and management → Achievements / Leaderboards**

按下面每一条创建。名称、描述可直接复制。全部建好后 **Publish** PGS 配置，再把生成的 ID 填回工程。

操作步骤：[docs/PLAY_CONSOLE_RUNBOOK.md](./docs/PLAY_CONSOLE_RUNBOOK.md) §2 · 待办勾选：[TODO_LIST.md](./TODO_LIST.md) §2  
图标目录：[store/achievement_icons/](./store/achievement_icons/)（**512×512** PNG）  
批量导入 ZIP：[store/pgs_achievements_import/achievements_import.zip](./store/pgs_achievements_import/achievements_import.zip)（英文默认 + `zh-CN`；生成：`python tool/pack_pgs_achievements_zip.py`）  
出图提示词：[flutter_app/tool/prompts/image_prompt.md](./flutter_app/tool/prompts/image_prompt.md)「Play Games 成就 / 排行榜图标」

包名：`com.beatinghouse.mist`  
游戏名：迷雾之塔 / Mist Tower  

**Points 规则提醒：** 须为 5 的倍数；单个 ≤200；全作合计 ≤2000（本表合计 **595**，留有余量）。  
**无 Steam 式稀有度类型**；用更高分 + Hidden 表达稀有。

### 语言怎么填（中 + 英）

1. 创建成就时先填 **默认语言**（若 Console 默认是 **en-US**，先贴下方 **en-US** 行）
2. 保存后打开该成就 → **Translations / 添加翻译** → 选 **中文（简体）zh-CN / zh-Hans**，贴 **zh** 行
3. 若默认语言已是简体中文：先贴 zh，再添加 **English (United States) – en-US**

排行榜同理（仅 Name）。

### 图标

每条表格的 **Icon** 行为仓库相对路径；上传 Console 时选对应 PNG。  
若目录尚无文件：按 `tool/prompts/image_prompt.md` 生成，或先跑 `python tool/generate_achievement_icons.py` 占位。

---

## 成就 1 / 18 — `awaken`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 雾中苏醒 | Awakening |
| Description | 踏入迷雾森林，开始旅程。 | Step into the mist forest and begin your journey. |
| Icon | `store/achievement_icons/awaken.png` | |
| Initial state | Revealed | |
| Points | 5 | |
| Incremental | No | |
| List order | 1 | |

触发：首次离开 `forest_entrance`。

---

## 成就 2 / 18 — `first_victory`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 初战告捷 | First Victory |
| Description | 赢得第一场战斗。 | Win your first battle. |
| Icon | `store/achievement_icons/first_victory.png` | |
| Initial state | Revealed | |
| Points | 10 | |
| Incremental | No | |
| List order | 2 | |

触发：生涯首次战斗胜利。

---

## 成就 3 / 18 — `first_recruit`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 结伴而行 | Companions |
| Description | 招募第一位队友。 | Recruit your first companion. |
| Icon | `store/achievement_icons/first_recruit.png` | |
| Initial state | Revealed | |
| Points | 15 | |
| Incremental | No | |
| List order | 3 | |

触发：首次成功招募。

---

## 成就 4 / 18 — `first_quest`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 受托之人 | Trusted |
| Description | 完成第一个 NPC 委托。 | Complete your first NPC quest. |
| Icon | `store/achievement_icons/first_quest.png` | |
| Initial state | Revealed | |
| Points | 15 | |
| Incremental | No | |
| List order | 4 | |

触发：任意 NPC `questDone` 首次完成。

---

## 成就 5 / 18 — `enter_cave`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 深入地下 | Into the Deep |
| Description | 首次进入洞穴层。 | Enter the cave layer for the first time. |
| Icon | `store/achievement_icons/enter_cave.png` | |
| Initial state | Revealed | |
| Points | 20 | |
| Incremental | No | |
| List order | 5 | |

触发：首次访问洞穴层房间。

---

## 成就 6 / 18 — `enter_tower`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 塔影将至 | Tower Ahead |
| Description | 首次登上高塔层。 | Reach the tower layer for the first time. |
| Icon | `store/achievement_icons/enter_tower.png` | |
| Initial state | Revealed | |
| Points | 25 | |
| Incremental | No | |
| List order | 6 | |

触发：首次访问高塔层房间。

---

## 成就 7 / 18 — `site_gate`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 石门洞开 | Stone Gate Opens |
| Description | 持魔法宝石打开通往收容站的石门。 | Open the path to the containment site with the magic gem. |
| Icon | `store/achievement_icons/site_gate.png` | |
| Initial state | Hidden | |
| Points | 30 | |
| Incremental | No | |
| List order | 7 | |

触发：`grave_site_open` 标志首次置位。

---

## 成就 8 / 18 — `enter_site`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 收容之下 | Beneath Containment |
| Description | 首次踏入基金会收容站点。 | Enter the Foundation containment site for the first time. |
| Icon | `store/achievement_icons/enter_site.png` | |
| Initial state | Hidden | |
| Points | 35 | |
| Incremental | No | |
| List order | 8 | |

触发：首次访问站点层房间。

---

## 成就 9 / 18 — `explore_20`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 迷雾残页 | Mist Pages |
| Description | 探索至少 20 个场景。 | Explore at least 20 rooms. |
| Icon | `store/achievement_icons/explore_20.png` | |
| Initial state | Revealed | |
| Points | 25 | |
| Incremental | No | |
| List order | 9 | |

触发：`visitedCount() >= 20`。

---

## 成就 10 / 18 — `explore_40`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 雾图将满 | Charting the Fog |
| Description | 探索至少 40 个场景。 | Explore at least 40 rooms. |
| Icon | `store/achievement_icons/explore_40.png` | |
| Initial state | Revealed | |
| Points | 40 | |
| Incremental | No | |
| List order | 10 | |

触发：`visitedCount() >= 40`。

---

## 成就 11 / 18 — `battles_10`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 十战迷雾 | Ten Battles |
| Description | 累计赢得 10 场战斗。 | Win 10 battles in total. |
| Icon | `store/achievement_icons/battles_10.png` | |
| Initial state | Revealed | |
| Points | 20 | |
| Incremental | **Yes**，Steps = **10** | |
| List order | 11 | |

触发：设备级生涯胜场（跨存档累计）。

---

## 成就 12 / 18 — `battles_25`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 百战将启 | Seasoned Fighter |
| Description | 累计赢得 25 场战斗。 | Win 25 battles in total. |
| Icon | `store/achievement_icons/battles_25.png` | |
| Initial state | Revealed | |
| Points | 40 | |
| Incremental | **Yes**，Steps = **25** | |
| List order | 12 | |

触发：设备级生涯胜场。

---

## 成就 13 / 18 — `ending_dragon`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 幼龙已陨落 | Dragon Fell |
| Description | 击败塔顶幼龙，取得魔法宝石。 | Defeat the young dragon atop the tower and claim the magic gem. |
| Icon | `store/achievement_icons/ending_dragon.png` | |
| Initial state | Revealed | |
| Points | 40 | |
| Incremental | No | |
| List order | 13 | |

触发：`EndingKind.dragonClear`。

---

## 成就 14 / 18 — `ending_main`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 迷雾消散 | Mist Cleared |
| Description | 在塔顶使用魔法宝石，找回记忆并打破迷雾诅咒。 | Use the magic gem at the tower’s peak to restore your memories and break the curse. |
| Icon | `store/achievement_icons/ending_main.png` | |
| Initial state | Hidden | |
| Points | 50 | |
| Incremental | No | |
| List order | 14 | |

触发：`EndingKind.mainClear`。

---

## 成就 15 / 18 — `ending_site`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 站点行动完成 | Site Secured |
| Description | 击败收容站最终 BOSS，完成站点行动。 | Defeat the containment site’s final boss and complete the operation. |
| Icon | `store/achievement_icons/ending_site.png` | |
| Initial state | Hidden | |
| Points | 50 | |
| Incremental | No | |
| List order | 15 | |

触发：`EndingKind.siteClear`。

---

## 成就 16 / 18 — `full_party`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 全员集结 | Full Party |
| Description | 招募全部 7 名队友。 | Recruit all 7 companions. |
| Icon | `store/achievement_icons/full_party.png` | |
| Initial state | Hidden | |
| Points | 75 | |
| Incremental | No | |
| List order | 16 | |

触发：7 名 companion 均 `recruited`。

---

## 成就 17 / 18 — `ng_plus`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 二周目旅人 | New Cycle |
| Description | 开启二周目旅程。 | Start a New Game Plus run. |
| Icon | `store/achievement_icons/ng_plus.png` | |
| Initial state | Hidden | |
| Points | 50 | |
| Incremental | No | |
| List order | 17 | |

触发：成功执行 `ng+`。

---

## 成就 18 / 18 — `score_1000`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 千分迷雾 | Thousand Mist |
| Description | 单局得分达到 1000。 | Reach a score of 1000 in a single run. |
| Icon | `store/achievement_icons/score_1000.png` | |
| Initial state | Hidden | |
| Points | 50 | |
| Incremental | No | |
| List order | 18 | |

触发：`session.score >= 1000`。

---

## 排行榜 1 / 1 — `high_score`

| Console 字段 | zh（简体） | en-US |
|--------------|------------|-------|
| Name | 最高得分 | High Score |
| Icon | `store/achievement_icons/high_score.png` | |
| Score formatting | Numeric | |
| Sort order | Larger is better | |
| Number of decimal places | 0 | |

提交：设备本地历史最高 `session.score`。  
（排行榜描述若 Console 要求：zh「迷雾之塔单局历史最高得分。」/ en-US「Highest score earned in Mist Tower.」）

---

## 图标路径速查

| 本地 ID | 文件 |
|---------|------|
| `awaken` | `store/achievement_icons/awaken.png` |
| `first_victory` | `store/achievement_icons/first_victory.png` |
| `first_recruit` | `store/achievement_icons/first_recruit.png` |
| `first_quest` | `store/achievement_icons/first_quest.png` |
| `enter_cave` | `store/achievement_icons/enter_cave.png` |
| `enter_tower` | `store/achievement_icons/enter_tower.png` |
| `site_gate` | `store/achievement_icons/site_gate.png` |
| `enter_site` | `store/achievement_icons/enter_site.png` |
| `explore_20` | `store/achievement_icons/explore_20.png` |
| `explore_40` | `store/achievement_icons/explore_40.png` |
| `battles_10` | `store/achievement_icons/battles_10.png` |
| `battles_25` | `store/achievement_icons/battles_25.png` |
| `ending_dragon` | `store/achievement_icons/ending_dragon.png` |
| `ending_main` | `store/achievement_icons/ending_main.png` |
| `ending_site` | `store/achievement_icons/ending_site.png` |
| `full_party` | `store/achievement_icons/full_party.png` |
| `ng_plus` | `store/achievement_icons/ng_plus.png` |
| `score_1000` | `store/achievement_icons/score_1000.png` |
| `high_score` | `store/achievement_icons/high_score.png` |

---

## 英文速查表

| 本地 ID | en-US Name | en-US Description |
|---------|------------|-------------------|
| `awaken` | Awakening | Step into the mist forest and begin your journey. |
| `first_victory` | First Victory | Win your first battle. |
| `first_recruit` | Companions | Recruit your first companion. |
| `first_quest` | Trusted | Complete your first NPC quest. |
| `enter_cave` | Into the Deep | Enter the cave layer for the first time. |
| `enter_tower` | Tower Ahead | Reach the tower layer for the first time. |
| `site_gate` | Stone Gate Opens | Open the path to the containment site with the magic gem. |
| `enter_site` | Beneath Containment | Enter the Foundation containment site for the first time. |
| `explore_20` | Mist Pages | Explore at least 20 rooms. |
| `explore_40` | Charting the Fog | Explore at least 40 rooms. |
| `battles_10` | Ten Battles | Win 10 battles in total. |
| `battles_25` | Seasoned Fighter | Win 25 battles in total. |
| `ending_dragon` | Dragon Fell | Defeat the young dragon atop the tower and claim the magic gem. |
| `ending_main` | Mist Cleared | Use the magic gem at the tower’s peak to restore your memories and break the curse. |
| `ending_site` | Site Secured | Defeat the containment site’s final boss and complete the operation. |
| `full_party` | Full Party | Recruit all 7 companions. |
| `ng_plus` | New Cycle | Start a New Game Plus run. |
| `score_1000` | Thousand Mist | Reach a score of 1000 in a single run. |
| `high_score` | High Score | Highest score earned in Mist Tower. |

---

## 创建后回填工程

完整步骤见 [docs/PLAY_CONSOLE_RUNBOOK.md](./docs/PLAY_CONSOLE_RUNBOOK.md) §2.5；勾选见 [TODO_LIST.md](./TODO_LIST.md) §2.D。

1. PGS → **Publishing → Publish**（只发布 PGS，不等于上架游戏）  
2. Console → **Get resources** 导出 XML  
3. 覆盖 [`flutter_app/android/app/src/main/res/values/games-ids.xml`](flutter_app/android/app/src/main/res/values/games-ids.xml)  
4. 同步 Dart 占位符：

```bash
cd flutter_app
dart run tool/apply_pgs_ids.dart
dart run tool/check_pgs_ids.dart
```

5. 把真实 ID 填入 [TODO_LIST.md](./TODO_LIST.md)「回填 ID 记录」表  
6. 用含真 ID 的包打 Internal testing，按 [docs/INTERNAL_TEST_CHECKLIST.md](./docs/INTERNAL_TEST_CHECKLIST.md) 验收  

**Points 合计：** 5+10+15+15+20+25+30+35+25+40+20+40+40+50+50+75+50+50 = **595** / 2000
