# Play Games Console — 成就与排行榜文案（18 成就）

在 Google Play Console：

**Grow users → Play Games Services → Setup and management → Achievements / Leaderboards**

按下面每一条创建。名称、描述可直接复制。全部建好后 **Publish** PGS 配置，再把生成的 ID 填回工程。

包名：`com.beatinghouse.mist`  
游戏名：迷雾之塔 / Mist Tower  

**Points 规则提醒：** 须为 5 的倍数；单个 ≤200；全作合计 ≤2000（本表合计 **595**，留有余量）。  
**无 Steam 式稀有度类型**；用更高分 + Hidden 表达稀有。

---

## 成就 1 / 18 — `awaken`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 雾中苏醒 |
| Description | 踏入迷雾森林，开始旅程。 |
| Initial state | Revealed |
| Points | 5 |
| Incremental | No |
| List order | 1 |

触发：首次离开 `forest_entrance`。

---

## 成就 2 / 18 — `first_victory`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 初战告捷 |
| Description | 赢得第一场战斗。 |
| Initial state | Revealed |
| Points | 10 |
| Incremental | No |
| List order | 2 |

触发：生涯首次战斗胜利。

---

## 成就 3 / 18 — `first_recruit`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 结伴而行 |
| Description | 招募第一位队友。 |
| Initial state | Revealed |
| Points | 15 |
| Incremental | No |
| List order | 3 |

触发：首次成功招募。

---

## 成就 4 / 18 — `first_quest`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 受托之人 |
| Description | 完成第一个 NPC 委托。 |
| Initial state | Revealed |
| Points | 15 |
| Incremental | No |
| List order | 4 |

触发：任意 NPC `questDone` 首次完成。

---

## 成就 5 / 18 — `enter_cave`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 深入地下 |
| Description | 首次进入洞穴层。 |
| Initial state | Revealed |
| Points | 20 |
| Incremental | No |
| List order | 5 |

触发：首次访问洞穴层房间。

---

## 成就 6 / 18 — `enter_tower`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 塔影将至 |
| Description | 首次登上高塔层。 |
| Initial state | Revealed |
| Points | 25 |
| Incremental | No |
| List order | 6 |

触发：首次访问高塔层房间。

---

## 成就 7 / 18 — `site_gate`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 石门洞开 |
| Description | 持魔法宝石打开通往收容站的石门。 |
| Initial state | Hidden |
| Points | 30 |
| Incremental | No |
| List order | 7 |

触发：`grave_site_open` 标志首次置位。

---

## 成就 8 / 18 — `enter_site`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 收容之下 |
| Description | 首次踏入基金会收容站点。 |
| Initial state | Hidden |
| Points | 35 |
| Incremental | No |
| List order | 8 |

触发：首次访问站点层房间。

---

## 成就 9 / 18 — `explore_20`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 迷雾残页 |
| Description | 探索至少 20 个场景。 |
| Initial state | Revealed |
| Points | 25 |
| Incremental | No |
| List order | 9 |

触发：`visitedCount() >= 20`。

---

## 成就 10 / 18 — `explore_40`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 雾图将满 |
| Description | 探索至少 40 个场景。 |
| Initial state | Revealed |
| Points | 40 |
| Incremental | No |
| List order | 10 |

触发：`visitedCount() >= 40`。

---

## 成就 11 / 18 — `battles_10`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 十战迷雾 |
| Description | 累计赢得 10 场战斗。 |
| Initial state | Revealed |
| Points | 20 |
| Incremental | **Yes**，Steps = **10** |
| List order | 11 |

触发：设备级生涯胜场（跨存档累计）。

---

## 成就 12 / 18 — `battles_25`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 百战将启 |
| Description | 累计赢得 25 场战斗。 |
| Initial state | Revealed |
| Points | 40 |
| Incremental | **Yes**，Steps = **25** |
| List order | 12 |

触发：设备级生涯胜场。

---

## 成就 13 / 18 — `ending_dragon`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 幼龙已陨落 |
| Description | 击败塔顶幼龙，取得魔法宝石。 |
| Initial state | Revealed |
| Points | 40 |
| Incremental | No |
| List order | 13 |

触发：`EndingKind.dragonClear`。

---

## 成就 14 / 18 — `ending_main`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 迷雾消散 |
| Description | 在塔顶使用魔法宝石，找回记忆并打破迷雾诅咒。 |
| Initial state | Hidden |
| Points | 50 |
| Incremental | No |
| List order | 14 |

触发：`EndingKind.mainClear`。

---

## 成就 15 / 18 — `ending_site`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 站点行动完成 |
| Description | 击败收容站最终 BOSS，完成站点行动。 |
| Initial state | Hidden |
| Points | 50 |
| Incremental | No |
| List order | 15 |

触发：`EndingKind.siteClear`。

---

## 成就 16 / 18 — `full_party`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 全员集结 |
| Description | 招募全部 7 名队友。 |
| Initial state | Hidden |
| Points | 75 |
| Incremental | No |
| List order | 16 |

触发：7 名 companion 均 `recruited`。

---

## 成就 17 / 18 — `ng_plus`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 二周目旅人 |
| Description | 开启二周目旅程。 |
| Initial state | Hidden |
| Points | 50 |
| Incremental | No |
| List order | 17 |

触发：成功执行 `ng+`。

---

## 成就 18 / 18 — `score_1000`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 千分迷雾 |
| Description | 单局得分达到 1000。 |
| Initial state | Hidden |
| Points | 50 |
| Incremental | No |
| List order | 18 |

触发：`session.score >= 1000`。

---

## 排行榜 1 / 1 — `high_score`

| Console 字段 | 复制内容 |
|--------------|----------|
| Name | 最高得分 |
| Score formatting | Numeric |
| Sort order | Larger is better |
| Number of decimal places | 0 |

提交：设备本地历史最高 `session.score`。

---

## 英文备用

| 本地 ID | Name | Description |
|---------|------|-------------|
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

## 图标

每个成就需上传图标（常见 512×512）。建议按主题区分：开局 / 探索 / 战斗 / 终局 / 稀有。风格对齐 `mist_tower_hero` 像素色板。

---

## 创建后回填工程

1. Console → **Get resources** 导出 XML  
2. 替换 [`flutter_app/android/app/src/main/res/values/games-ids.xml`](flutter_app/android/app/src/main/res/values/games-ids.xml)  
3. 同步替换 [`flutter_app/lib/services/play_games/play_games_ids.dart`](flutter_app/lib/services/play_games/play_games_ids.dart) 中 `CgkI_PLACEHOLDER_*`  
4. 勾选 [TODO_LIST.md](./TODO_LIST.md) 回填项  

**Points 合计：** 5+10+15+15+20+25+30+35+25+40+20+40+40+50+50+75+50+50 = **595** / 2000
