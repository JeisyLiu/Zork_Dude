# 🌫 Mist Tower (迷雾之塔)

A [Zork](https://en.wikipedia.org/wiki/Zork)-like text adventure. You wake in a misty forest with no memory—explore, collect, talk, recruit, fight, and solve puzzles to uncover the truth.

## Play online

| Build | Link |
|------|------|
| Lore homepage | [https://jeisyliu.github.io/Zork_Dude/](https://jeisyliu.github.io/Zork_Dude/) |
| Desktop Web | [https://jeisyliu.github.io/Zork_Dude/play.html](https://jeisyliu.github.io/Zork_Dude/play.html) |
| Mobile Web | [https://jeisyliu.github.io/Zork_Dude/mobile](https://jeisyliu.github.io/Zork_Dude/mobile) |
| Privacy policy | [https://jeisyliu.github.io/Zork_Dude/privacy.html](https://jeisyliu.github.io/Zork_Dude/privacy.html) |

Open in a browser—no install required. On phones, prefer the mobile build.

**Developer**: Hunan Beating House Information Technology Co Ltd（湖南跃动小屋信息技术有限公司）· [JeisyLiu](https://github.com/jeisyliu) · [beatinghousehunan@gmail.com](mailto:beatinghousehunan@gmail.com)

## Features

- **59** rooms (surface / caves / tower / containment site)
- **34** monsters (elites, bosses, and many anomalies)
- Keep exploring after main or site endings; `ng+` New Game+ keeps gear
- **21** NPCs (Plague Doctor, aging AI, Cain, and more)
- **7** recruitable companions (fighter, rogue, mage, healer…)
- **100+** items (including 30+ original SCP-inspired anomalies)
- **Swappable backpacks**: canvas / tactical / anomaly sack, different weight caps
- **Foundation containment site**: cell block, Site-914 workshop, 096/173/682 cells
- Site devices: `use 914` refine, `use 294` drink, `use 261` vending
- Combat, dialogue, trade, heal, quests, and scoring
- Mist-fragment map with layer switching (including the site layer)
- Data-driven: entities live in `data/*.json`—change data without touching core logic

## Run locally

### Web

Serve the repo root with any static server:

```bash
# e.g. Python
python -m http.server 8080
# Lore home     http://localhost:8080/
# Desktop play  http://localhost:8080/play.html
# Mobile        http://localhost:8080/mobile/
```

### CLI (Python)

Requires Python 3.10+:

```bash
python zork_game.py
```

### Flutter native (Zork exploration + turn combat)

The native app lives in `flutter_app/` (separate from the `mobile/` Web build). The main loop is **Zork-style exploration + mist-fragment map**; encounters open **turn-based combat**:

```bash
cd flutter_app
dart run tool/sync_game_data.dart   # sync root data/*.json
flutter pub get
flutter run
```

See [flutter_app/README.md](flutter_app/README.md).

## Common commands

| Category | Commands | Notes |
|------|------|------|
| Move | `n` / `s` / `e` / `w` / `u` / `d` | north / south / east / west / up / down |
| Explore | `look` `take` `drop` `use` `inventory` | look, take, drop, use, inventory |
| Social | `talk` `buy` `sell` `heal` | talk, trade, heal |
| Combat | `attack` `flee` | attack, flee |
| Party | `recruit` `party` | recruit, party |
| System | `help` `score` `map` `ng+` `quit` | help, score, map, New Game+, quit |

Items can be targeted by name or index, e.g. `take 1`, `use 2`. Food / treasure / materials stack (cap 999).

**Backpack**: `use` a backpack item (e.g. tactical pack) to equip it; you cannot switch if current weight exceeds the new capacity.

**Site side path**: with the magic gem from the young dragon, open the stone gate at the cursed graveyard to enter the Foundation containment site. South from the containment corridor reaches the cell block; go down to the Site-914 workshop (`use 914`).

Example anomalies: Incomplete Score (012), Shy Guy (096), Sculpture (173), Converter (914), Plague Doctor (049), Panacea (500), Immortal Crawler (682), Terminal Prototype (001)—original gameplay homage, not wiki text.

**Endings & New Game+**: after defeating the young dragon you may keep exploring or return to finish the main ending; using the magic gem at the tower top also completes the main line. Defeating 001 plays the site ending and credits. Tips show once; the game does not hard-stop. After either ending, `ng+` / `newgame+` (Web has a New Game+ button) resets the world but keeps gear, items, gold, and companions.

The Web builds also support tap buttons plus a command input at the bottom.

## Project layout

```
zork-dude/
├── index.html          # lore homepage
├── play.html           # desktop Web adventure
├── privacy.html        # privacy policy
├── site/               # homepage styles, version notes, landing art
├── mobile/
│   └── index.html      # mobile Web
├── flutter_app/        # Flutter native app
├── zork_game.py        # full CLI
└── data/
    ├── rooms.json      # rooms
    ├── items.json      # items
    ├── monsters.json   # monsters
    ├── npcs.json       # NPCs
    └── companions.json # recruitable companions
```

## Victory goal

Reach the tower top, defeat the young dragon, use the magic gem—recover your memory and break the mist curse.

Wake in the mist. Recover what was lost.

---

# 中文说明

## 🌫 迷雾之塔

类 [Zork](https://en.wikipedia.org/wiki/Zork) 的中文文字冒险游戏。你从迷雾森林中醒来，失去记忆——探索、收集、对话、招募、战斗、解谜，找回失落的真相。

## 在线游玩

| 版本 | 链接 |
|------|------|
| 世界观主页 | [https://jeisyliu.github.io/Zork_Dude/](https://jeisyliu.github.io/Zork_Dude/) |
| 桌面 Web 版 | [https://jeisyliu.github.io/Zork_Dude/play.html](https://jeisyliu.github.io/Zork_Dude/play.html) |
| 移动 Web 版 | [https://jeisyliu.github.io/Zork_Dude/mobile](https://jeisyliu.github.io/Zork_Dude/mobile) |
| 隐私政策 | [https://jeisyliu.github.io/Zork_Dude/privacy.html](https://jeisyliu.github.io/Zork_Dude/privacy.html) |

浏览器打开即可玩，无需安装。手机建议使用移动版。

**开发者**：湖南跃动小屋信息技术有限公司（Hunan Beating House Information Technology Co Ltd）· [JeisyLiu](https://github.com/jeisyliu) · [beatinghousehunan@gmail.com](mailto:beatinghousehunan@gmail.com)

## 特色

- **59** 个场景（地表 / 洞穴 / 高塔 / 收容站点）
- **34** 种怪物（含精英、BOSS 与多只收容物）
- 主线与站点通关后仍可继续探索；`ng+` 二周目保留装备道具
- **21** 位 NPC（含瘟疫医生、老化 AI、该隐等）
- **7** 位可招募队友（战士、盗贼、法师、治疗者……）
- **100+** 种道具（含 30+ 原创致敬向 SCP 收容物）
- **可更换背包**：帆布包 / 战术背包 / 异常收纳囊，负重上限不同
- **基金会收容站点**：单元区、914 齿轮工房、096/173/682 等危险收容间
- 站点装置：`use 914` 精炼、`use 294` 饮水、`use 261` 贩卖机
- 战斗、对话、交易、治疗、任务与得分系统
- 迷雾残页地图：图层切换（含「站点」层）
- 数据驱动：实体定义在 `data/*.json`，改数据不必动核心逻辑

## 本地运行

### Web 版

用任意静态服务器打开根目录：

```bash
# 例如使用 Python
python -m http.server 8080
# 主页（世界观） http://localhost:8080/
# 桌面游玩     http://localhost:8080/play.html
# 移动版       http://localhost:8080/mobile/
```

### 命令行版（Python）

需要 Python 3.10+：

```bash
python zork_game.py
```

### Flutter 原生移动端（Zork 探索 + 回合战斗）

原生 App 在 `flutter_app/`（与 `mobile/` 移动 Web 版独立）。主界面为 **Zork 指令探索 + 迷雾残页地图**，遇敌时进入 **回合制战斗**：

```bash
cd flutter_app
dart run tool/sync_game_data.dart   # 同步根目录 data/*.json
flutter pub get
flutter run
```

详见 [flutter_app/README.md](flutter_app/README.md)。

## 常用命令

| 类别 | 命令 | 说明 |
|------|------|------|
| 移动 | `n` / `s` / `e` / `w` / `u` / `d` | 北南东西上下 |
| 探索 | `look` `take` `drop` `use` `inventory` | 查看、拾取、丢弃、使用、背包 |
| 社交 | `talk` `buy` `sell` `heal` | 对话、买卖、治疗 |
| 战斗 | `attack` `flee` | 攻击、逃跑 |
| 队友 | `recruit` `party` | 招募、查看队伍 |
| 系统 | `help` `score` `map` `ng+` `quit` | 帮助、得分、地图、二周目、退出 |

物品可用名称或序号操作，例如 `take 1`、`use 2`。食物 / 宝藏 / 材料可叠加（上限 999）。

**背包**：使用 `use` 装备背包类物品（如战术背包）；当前负重超过新背包容量时无法更换。

**站点支线**：持有幼龙掉落的魔法宝石，在被诅咒的墓地可打开石门进入基金会收容站点。收容走廊南侧进入单元区，向下可到 914 号齿轮工房（`use 914`）。

常见收容物示例：未完乐章(012)、害羞者(096)、雕塑(173)、转换器(914)、瘟疫医生(049)、万能药(500)、不灭爬行者(682)、终焉原型(001) 等（原创玩法致敬，非维基原文）。

**通关与二周目**：击败幼龙后可选择继续探险或返程完成主线；塔顶使用魔法宝石亦可完成主线。击败 001 后播放站点通关动画与职员表。提示只出现一次，游戏不结束。完成任一通关后可用 `ng+` / `newgame+`（Web 有「二周目」按钮）重置世界并保留装备、道具、金币与队友。

Web 版也支持按钮点选与底部输入框输入命令。

## 项目结构

```
zork-dude/
├── index.html          # 世界观介绍主页
├── play.html           # 桌面 Web 文字冒险
├── privacy.html        # 隐私政策
├── site/               # 主页样式、版本说明、落地页图片
├── mobile/
│   └── index.html      # 移动 Web 版
├── flutter_app/        # Flutter 原生移动端
├── zork_game.py        # 命令行完整版
└── data/
    ├── rooms.json      # 场景
    ├── items.json      # 道具
    ├── monsters.json   # 怪物
    ├── npcs.json       # NPC
    └── companions.json # 可招募队友
```

## 胜利目标

登上高塔顶层，击败幼龙，使用魔法宝石——找回记忆，打破迷雾诅咒。

---

从迷雾中醒来，找回失落的记忆。
