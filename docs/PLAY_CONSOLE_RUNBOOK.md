# Play Console 上架操作手册

按顺序执行。代码侧工具见 `flutter_app/tool/`。

## 前置信息

| 项 | 值 |
|---|---|
| 包名 | `com.zorkdude.zork_dude` |
| 游戏名 | 迷雾之塔 / Mist Tower |
| 应用主页 | https://jeisyliu.github.io/Zork_Dude/ |
| 隐私政策 | https://jeisyliu.github.io/Zork_Dude/privacy.html |
| 成就文案 | [PLAY_GAMES_ACHIEVEMENTS.md](../PLAY_GAMES_ACHIEVEMENTS.md) |
| 商店文案 | [STORE_LISTING.md](./STORE_LISTING.md) |

---

## 1. GitHub Pages（已完成）

- 主页与隐私页已可访问（2026-08 验收通过）
- 若更新站点内容：推送到 `main` 分支即可

---

## 2. Play Console 应用与 PGS 配置

### 2.1 创建应用

1. [Google Play Console](https://play.google.com/console) → 创建应用「迷雾之塔」
2. 默认语言：简体中文（中国）或英语，按需添加多语言

### 2.2 Play Games Services

路径：**Grow users → Play Games Services → Setup and management**

1. 完成初始 **Setup / Configuration**
2. **Google Cloud** → OAuth 同意屏幕（外部测试 / 正式发布前配置）
3. **Credentials** → 添加 **Android**：
   - 包名：`com.zorkdude.zork_dude`
   - SHA-1（debug，本机开发用）：

```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

   - SHA-1（release）：Play Console → **Release → Setup → App integrity → App signing key certificate** 复制 SHA-1

### 2.3 成就与排行榜

按 [PLAY_GAMES_ACHIEVEMENTS.md](../PLAY_GAMES_ACHIEVEMENTS.md) 创建 **18** 个成就 + **1** 个排行榜。

成就图标（512×512 PNG）见 `store/achievement_icons/`（由 `python tool/generate_achievement_icons.py` 生成）。

### 2.4 发布 PGS 并导出 ID

1. PGS → **Publishing** → **Publish**（仅发布 PGS 配置）
2. **Configuration → Credentials → Get resources** → 下载 `games-ids.xml`
3. 将下载的 XML 覆盖到：
   `flutter_app/android/app/src/main/res/values/games-ids.xml`
4. 在工程根目录执行：

```bash
cd flutter_app
dart run tool/apply_pgs_ids.dart
dart run tool/check_pgs_ids.dart
```

5. 把 ID 填入 [TODO_LIST.md](../TODO_LIST.md)「回填 ID 记录」表

### 2.5 测试账号

PGS → **Testing** → 添加测试 Google 账号（Gmail）。

---

## 3. 商店与合规

见 [STORE_LISTING.md](./STORE_LISTING.md)：

- Data Safety 问卷答案
- 标题 / 短描述 / 完整描述（中/英）
- 隐私政策 URL、主页 URL

---

## 4. 内部测试 AAB

```bash
cd flutter_app
flutter build appbundle --release
```

产物：`build/app/outputs/bundle/release/app-release.aab`

1. Play Console → **Testing → Internal testing** → 创建版本 → 上传 AAB
2. 添加测试人员 → 从 Play 商店链接安装
3. 验收清单见 [INTERNAL_TEST_CHECKLIST.md](./INTERNAL_TEST_CHECKLIST.md)

---

## 5. 真机验收（PGS + 广告）

- [ ] 主页「成就」「排行榜」入口可打开 Play Games UI
- [ ] 静默登录成功（或提示连接）
- [ ] 触发成就后 Console 侧可见解锁（可能有延迟）
- [ ] 排行榜提交分数
- [ ] 首次启动 UMP 同意弹窗正常；激励广告可加载（测试设备）
