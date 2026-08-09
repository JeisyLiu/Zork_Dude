# 迷雾之塔 · Flutter 移动端

基于 **Flutter** 的原生移动客户端。

> 仓库里已有的 `mobile/` 是 **移动 Web 版**（HTML）。本目录 `flutter_app/` 是独立的原生 App。

## 架构

- **探索主界面**：Zork 指令系统 + 迷雾残页小地图（移植自 Web 版）
- **战斗场景**：遇敌时进入 `TurnCombatScreen` 回合制战斗
- **数据**：按 locale 加载 `assets/data/l10n/{locale}/*.json`（缺失回落 `zh_Hans`；旧路径 `assets/data/*.json` 仍兼容）
- **UI**：Kenney UI Pack Adventure 像素风资源（棕木幻想 / 灰铆钉站点 / 战斗 HUD）
- **国际化**：UI ARB + 领域 `GameMessages` + 世界 JSON，共 10 种语言（见下）

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

## 国际化（i18n）

支持 10 个 BCP 47 locale：`zh_Hans`、`zh_Hant`、`en_US`、`ja`、`ko`、`fr`、`de`、`it`、`es_ES`、`pt_BR`。

| 层 | 机制 | 路径 |
|---|---|---|
| UI 壳 | Flutter gen-l10n（ARB） | `lib/l10n/app_*.arb`（含 `es` / `pt` 基础回落） |
| 领域文案 | `GameMessages`（无 BuildContext） | `assets/l10n/messages/{locale}.json` |
| 世界内容 | `WorldRepository` 按 locale 加载 | `assets/data/l10n/{locale}/*.json` |

语言在**开局时绑定**（跟随系统 locale）；中途改系统语言需重进游戏，不做热切换。

### 重新生成翻译

以 `zh_Hans` 为源，批量生成其余 9 语种（UI ARB + messages JSON + 世界 JSON）：

```bash
cd flutter_app
pip install deep-translator   # 仅首次
python tool/generate_i18n.py
```

### 校验与测试

```bash
cd flutter_app
dart run tool/check_l10n.dart   # 各 locale 键集 / 实体 id 与 zh_Hans 一致
flutter gen-l10n
flutter test
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
├── data/             # JSON 加载（按 locale）
├── l10n/             # ARB、AppLocalizations、GameMessages、LocaleTag
├── state/            # GameController
├── ui/               # 主题、资源路径、Kenney 组件
├── screens/          # Home、Exploration、TurnCombat
└── widgets/          # 状态栏、日志、地图、快捷指令
assets/
├── data/l10n/        # 世界内容（按 locale 分目录）
└── l10n/messages/    # 领域运行时文案
tool/
├── generate_i18n.py      # 从 zh_Hans 生成多语言资源
├── check_l10n.dart       # 校验键集 / 实体 id
├── apply_pgs_ids.dart    # Console 导出 XML → 同步 play_games_ids.dart
└── check_pgs_ids.dart    # 校验无 PLACEHOLDER
```

## Google Play 上架

操作手册见仓库根目录 [docs/PLAY_CONSOLE_RUNBOOK.md](../docs/PLAY_CONSOLE_RUNBOOK.md)。

```bash
# Release AAB（上传 Internal testing）
flutter build appbundle --release
# 产物：build/app/outputs/bundle/release/app-release.aab

# Console 导出 games-ids.xml 后回填真 ID
dart run tool/apply_pgs_ids.dart
dart run tool/check_pgs_ids.dart
```

成就图标（512×512）：`store/achievement_icons/`（`python tool/generate_achievement_icons.py` 生成）

## 构建

```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --web-renderer=canvaskit
```
