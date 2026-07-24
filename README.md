# 🌫 迷雾之塔

类 [Zork](https://en.wikipedia.org/wiki/Zork) 的中文文字冒险游戏。你从迷雾森林中醒来，失去记忆——探索、收集、对话、招募、战斗、解谜，找回失落的真相。

## 在线游玩

| 版本 | 链接 |
|------|------|
| 桌面版 | [https://jeisyliu.github.io/Zork_Dude/](https://jeisyliu.github.io/Zork_Dude/) |
| 移动版 | [https://jeisyliu.github.io/Zork_Dude/mobile](https://jeisyliu.github.io/Zork_Dude/mobile) |

浏览器打开即可玩，无需安装。手机建议使用移动版。

## 特色

- **58** 个场景（地表 / 洞穴 / 高塔 / 收容站点）
- **33** 种怪物（含精英、BOSS 与多只收容物）
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

用任意静态服务器打开根目录，或直接用浏览器打开 `index.html` / `mobile/index.html`：

```bash
# 例如使用 Python
python -m http.server 8080
# 然后访问 http://localhost:8080/ 或 http://localhost:8080/mobile/
```

### 命令行版（Python）

需要 Python 3.10+：

```bash
python zork_game.py
```

## 常用命令

| 类别 | 命令 | 说明 |
|------|------|------|
| 移动 | `n` / `s` / `e` / `w` / `u` / `d` | 北南东西上下 |
| 探索 | `look` `take` `drop` `use` `inventory` | 查看、拾取、丢弃、使用、背包 |
| 社交 | `talk` `buy` `sell` `heal` | 对话、买卖、治疗 |
| 战斗 | `attack` `flee` | 攻击、逃跑 |
| 队友 | `recruit` `party` | 招募、查看队伍 |
| 系统 | `help` `score` `map` `quit` | 帮助、得分、地图、退出 |

物品可用名称或序号操作，例如 `take 1`、`use 2`。食物 / 宝藏 / 材料可叠加（上限 999）。

**背包**：使用 `use` 装备背包类物品（如战术背包）；当前负重超过新背包容量时无法更换。

**站点支线**：在被诅咒的墓地拾取二级钥匙卡进入基金会收容站点。收容走廊南侧进入单元区，向下可到 914 号齿轮工房（`use 914`）。

常见收容物示例：未完乐章(012)、害羞者(096)、雕塑(173)、转换器(914)、瘟疫医生(049)、万能药(500)、不灭爬行者(682) 等（原创玩法致敬，非维基原文）。

Web 版也支持按钮点选与底部输入框输入命令。

## 项目结构

```
zork-dude/
├── index.html          # 桌面 Web 版
├── mobile/
│   └── index.html      # 移动 Web 版
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
