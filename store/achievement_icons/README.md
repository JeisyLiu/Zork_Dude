# Play Games 成就图标（512×512）

上传到 Play Console 各成就 / 排行榜时使用。文件名对应本地逻辑 ID。

| 文件 | 成就名（见 PLAY_GAMES_ACHIEVEMENTS.md） |
|------|----------------------------------------|
| `awaken.png` | 雾中苏醒 |
| `first_victory.png` | 初战告捷 |
| `high_score.png` | 最高得分（排行榜） |
| … | 其余见目录 |

重新生成：

```bash
python tool/generate_achievement_icons.py
```

源图来自 `flutter_app/assets/images/`。
