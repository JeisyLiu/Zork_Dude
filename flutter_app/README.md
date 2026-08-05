# 迷雾之塔 · Flutter 移动端

基于 **Flutter** 的原生移动客户端。

> 仓库里已有的 `mobile/` 是 **移动 Web 版**（HTML）。本目录 `flutter_app/` 是独立的原生 App。

## 架构

- **探索主界面**：Zork 指令系统 + 迷雾残页小地图（移植自 Web 版）
- **战斗场景**：遇敌时进入 `TurnCombatScreen` 回合制战斗
- **数据**：读取 `assets/data/*.json`（与根目录 `data/` 同步）
- **UI**：Kenney UI Pack Adventure 像素风资源（棕木幻想 / 灰铆钉站点 / 战斗 HUD）

## 同步资源

```bash
# 游戏 JSON 数据
dart run tool/sync_game_data.dart

# UI 贴图（根目录 ui_pack/ → assets/ui/）
dart run tool/sync_ui_assets.dart
```

UI 资源许可见 `assets/ui/License.txt`（Kenney UI Pack Adventure, CC0 1.0）。

## 快速开始

```bash
cd flutter_app
flutter pub get
flutter run
```

## 操作

| 模式 | 输入 |
|------|------|
| 探索 | 指令输入框 / 快捷按钮 / 地图点击相邻节点 |
| 移动 | n/s/e/w/u/d 或方向按钮 |
| 战斗 | 遇敌进入回合战；为队友选择指令后执行回合；可逃跑、使用道具 |

## UI 皮肤

| 场景 | 皮肤 | 主要资源 |
|------|------|----------|
| 首页 / 地表·洞穴·高塔 | fantasy | `panel_brown*`、`button_brown`、`minimap_ring_brown*` |
| 收容站点层 | site | `panel_grey_bolts*`、`button_grey` |
| 战斗 HUD | combat | `panel_grey_bolts_dark`、`progress_red/green`、`button_red` |

核心组件：`lib/ui/components/`（`GamePanel`、`GameButton`、`GameBanner`、`GameProgressBar`）

## 目录结构

```
lib/
├── domain/           # GameSession、回合战斗引擎、地图算法、指令处理
├── data/             # JSON 加载
├── state/            # GameController
├── ui/               # 主题、资源路径、Kenney 组件
├── screens/          # Home、Exploration、TurnCombat
└── widgets/          # 状态栏、日志、地图、快捷指令
```

## 构建

```bash
flutter build apk --release
flutter build web --web-renderer=canvaskit
```
