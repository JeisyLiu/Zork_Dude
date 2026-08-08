# 迷雾之塔 — 上架待办

按推荐顺序推进。完成后把对应项改成 `[x]`。

## 1. 应用主页 + 隐私协议网页

- [ ] 准备可公网访问的 HTTPS 站点（GitHub Pages / Cloudflare Pages / 自有域名均可）— **推送仓库后由 GitHub Pages 发布**
- [x] 应用主页：游戏简介、截图/宣传图、商店链接占位、联系方式（`index.html` + `site/`）
- [x] 隐私政策页（Play Console 必填 URL），至少写清：
  - [x] 收集/使用的数据：广告（AdMob）、本地存档、Play Games 成就与排行榜
  - [x] 无自有账号体系、无自建后端用户数据库
  - [x] Play Games 相关数据由 Google 处理；用户可通过 Google / Play Games 设置删除
  - [x] 广告相关：UMP 同意、AdMob 隐私说明链接
  - [x] 联系：GitHub Issues / github.com/jeisyliu（邮箱可后续补充）
- [x] （可选）支持 / 联系页 — 主页与隐私页链至 GitHub Issues
- [x] 将隐私政策 URL、主页 URL 记到下方「上架信息」

### 上架信息（填好后粘贴到 Play Console）

| 用途 | URL |
|------|-----|
| 应用主页 | https://jeisyliu.github.io/Zork_Dude/ |
| 隐私政策 | https://jeisyliu.github.io/Zork_Dude/privacy.html |
| 支持 / 联系（可选） | https://github.com/jeisyliu/Zork_Dude/issues |

---

## 2. Google Play Games Services 后台配置

详细文案见：[PLAY_GAMES_ACHIEVEMENTS.md](./PLAY_GAMES_ACHIEVEMENTS.md)（可逐条复制到 Console）

- [ ] Play Console 创建/选择应用「迷雾之塔」
- [ ] Grow users → Play Games Services → 完成初始 Setup / Configuration
- [ ] 配置 OAuth 同意屏幕（Google Cloud）
- [ ] 添加 Credential：Android（包名 `com.zorkdude.zork_dude`）
- [ ] 填入 **debug** 签名 SHA-1
- [ ] 填入 **release / Play App Signing** 签名 SHA-1
- [ ] 按 `PLAY_GAMES_ACHIEVEMENTS.md` 创建 3 个成就
- [ ] 按该文件创建 1 个排行榜
- [ ] Play Games Services → Publishing → **Publish**（只发布 PGS 配置，不等于上架游戏）
- [ ] Configuration → Credentials → **Get resources**，导出 XML
- [ ] 用真实 ID 替换工程占位符：
  - [ ] [`flutter_app/android/app/src/main/res/values/games-ids.xml`](flutter_app/android/app/src/main/res/values/games-ids.xml)
  - [ ] [`flutter_app/lib/services/play_games/play_games_ids.dart`](flutter_app/lib/services/play_games/play_games_ids.dart)
- [ ] 添加 PGS 测试账号，真机验证：静默登录 / 成就解锁 / 排行榜提交 / 主页入口

### 回填 ID 记录（从 Console 粘贴）

| 本地 ID | Console 资源名 | Android ID（CgkI…） |
|---------|----------------|---------------------|
| `app_id` | Play Games App ID | |
| `ending_dragon` | 幼龙已陨落 | |
| `ending_site` | 站点行动完成 | |
| `ending_main` | 迷雾消散 | |
| `high_score` | 最高得分 | |

---

## 3. Play Console 商店与合规

- [ ] Data Safety：如实填写广告、Play Games、本地数据等
- [ ] 商店列表：标题、短描述、完整描述、截图、图标、分级问卷
- [ ] 填写隐私政策 URL
- [ ] （可选）填写应用主页 / 支持网址
- [ ] 内部测试轨道上传 AAB，用测试账号验证 PGS + 广告

---

## 本轮不做

- 自有后端 / 云存档
- 应用内「注销自有账号」（当前无自有账号）
- iOS Game Center
- 增量成就、更多成就（首期仅 3 成就 + 1 排行榜）
