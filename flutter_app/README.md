# 迷雾之塔 · Flutter 移动端

基于 **Flutter + Flame + Bonfire** 的原生移动客户端。

> 仓库里已有的 `mobile/` 是 **移动 Web 版**（HTML）。本目录 `flutter_app/` 是独立的原生 App。

## 架构

- **探索主界面**：Zork 指令系统 + 迷雾残页小地图（移植自 Web 版）
- **战斗场景**：仅当 `inCombat=true` 时进入 Bonfire 动作 Arena
- **数据**：读取 `assets/data/*.json`（与根目录 `data/` 同步）

## 同步游戏数据

```bash
dart run tool/sync_game_data.dart
```

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
| 战斗 | 遇敌自动进入动作场景；摇杆移动 + 攻击按钮；可逃跑 |

## 目录结构

```
lib/
├── domain/           # GameSession、地图算法、指令处理
├── data/             # JSON 加载
├── state/            # GameController
├── screens/          # Home、Exploration、CombatArena
├── widgets/          # 状态栏、日志、地图、快捷指令
└── game/             # Bonfire 战斗层（Arena、Player、Enemy）
```

## 构建

```bash
flutter build apk --release
flutter build web --web-renderer=canvaskit
```
