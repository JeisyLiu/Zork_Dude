# 迷雾之塔 — 上架待办

按推荐顺序推进。完成后把对应项改成 `[x]`。

详细操作手册：[docs/PLAY_CONSOLE_RUNBOOK.md](./docs/PLAY_CONSOLE_RUNBOOK.md)

## 1. 应用主页 + 隐私协议网页

- [x] 站点与隐私页已发布：https://jeisyliu.github.io/Zork_Dude/ · https://jeisyliu.github.io/Zork_Dude/privacy.html

---

## 2. Google Play Games

### 2.A / 2.B / 2.C

- [x] Setup / OAuth / Android Credential（App Signing SHA-1）
- [x] Testers
- [x] 18 成就（Import + Awakening 手建）
- [x] 排行榜 **High Score** + `high_score.png`

### 2.D Publish PGS + 回填工程 ID ← **测更新前建议先做完**

- [ ] PGS → **Publishing → Publish**
- [ ] **Get resources** → 覆盖 `flutter_app/android/app/src/main/res/values/games-ids.xml`
- [ ] `cd flutter_app` → `dart run tool/apply_pgs_ids.dart` → `dart run tool/check_pgs_ids.dart`
- [ ] 填下方回填表；用含真 ID 的包发 Internal（与 §3 合并）

### 2.E 真机验收（Play 安装）

- [ ] 成就 / 排行榜 UI、登录、解锁、提交分数、Outbox

### 回填 ID 记录

| 本地 ID | Console 名 | Android ID（CgkI…） |
|---------|------------|---------------------|
| `app_id` | Play Games App ID | |
| `awaken` … `score_1000` | 各成就 | |
| `high_score` | High Score | |

---

## 3. 版本更新提示（In-App Update）← **当前重点**

代码已接好：回主页会检查 Play 更新。  
**硬条件：** 包必须从 **Play 安装**；商店里必须有 **更高 versionCode**。侧载 / `flutter run` 不会出提示。

工程当前：`0.9.14+14`（versionCode=**14**）。文案：`version/0.9.14.md`。

### 测软更（priority = 2）

1. （建议）先做完 §2.D，再打「含真 ID」的包  
2. **若 Internal 里还没有更低版本：**  
   - 先发一版旧包（例如保持 `+3`）并装上  
   - 再把 `pubspec` 改成更高 `+versionCode`，打新 AAB 再发一版  
3. **若已有旧包：** 新包 versionCode 必须比机上旧包大  
4. Console → Internal testing → 上传 AAB → What's new → **In-app update priority = 2** → 发布  
5. 机上保留旧版，打开主页 → 软更下载 → 确认安装 → 设置里版本应变新  

| Priority | 含义 | 本次 |
|----------|------|------|
| **2** | 软更，可取消 | **用这个测提示** |
| 4–5 | 全屏必更 | 先别用 |

### 3.A 清单

- [ ] §2.D 回填真 ID（建议）
- [ ] 抬高 `+versionCode`（相对机上旧包）
- [ ] `flutter build appbundle --release`
- [ ] Internal 上传，**priority=2**，发布
- [ ] 旧版机验主页更新提示

### 3.C 记录

| 项 | 值 |
|----|-----|
| 工程 | `0.9.14+14` |
| 实际上传新包 | |
| 轨道 | Internal |
| priority | 2 |

---

## 4. 商店与合规

- [ ] Data Safety / 商店列表 / URL  
见 `docs/STORE_LISTING.md`

---

## 你现在怎么走

1. **Publish PGS** → Get resources → `apply_pgs_ids`  
2. 打 AAB → Internal，**priority=2**（需要两版才能测更新时：先旧后新）  
3. 旧版机开主页看更新提示；顺带验成就/排行榜  
4. 再补商店合规  

---

## 本轮不做

- 自有后端 / 云存档 / iOS Game Center
