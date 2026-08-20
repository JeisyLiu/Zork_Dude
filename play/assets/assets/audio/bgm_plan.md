# 迷雾之塔 · BGM 场景与古典改编计划

`assets/audio/bgm/` 已放入 **8-bit** 改编曲（公版古典裁切经 `audio8bit` **transcribe/chords** 转写，尽量保留和声；见下方「当前已落地」）。
程序常量见 [`lib/services/audio/audio_assets.dart`](../../lib/services/audio/audio_assets.dart)。

| 常量 | 资源路径 | 触发 |
|------|----------|------|
| `AudioAssets.bgmHome` | `assets/audio/bgm/home.ogg` | 主页 `playHomeBgm()` |
| `AudioAssets.bgmPrologue` | `assets/audio/bgm/prologue.ogg` | 新游戏电影式序章爬行字 `playPrologueBgm()` |
| `AudioAssets.bgmSurface` | `assets/audio/bgm/surface.ogg` | 探索 · 地表层 |
| `AudioAssets.bgmCave` | `assets/audio/bgm/cave.ogg` | 探索 · 洞穴层 |
| `AudioAssets.bgmTower` | `assets/audio/bgm/tower.ogg` | 探索 · 塔层 |
| `AudioAssets.bgmSite` | `assets/audio/bgm/site.ogg` | 探索 · 站点层 |
| `AudioAssets.bgmCombat` | `assets/audio/bgm/combat.ogg` | 回合战斗 |
| `AudioAssets.bgmEnding` | `assets/audio/bgm/ending.ogg` | 结算 / Ending（不循环） |

## 当前已落地（8-bit 改编）

1. `python tool/fetch_bgm_classical.py` — 下载并裁切公版古典（备份：`tool/audio_sources/bgm_classical_trimmed/`）
2. `python tool/convert_bgm_8bit.py` — `audio8bit` **transcribe/chords**（优先保留和声）→ 覆盖 `assets/audio/bgm/*`

| 文件 | 来源作品 | 许可要点 |
|------|----------|----------|
| `home` | Satie Gymnopédie No.1 | Commons **CC0** |
| `prologue` | Holst Venus（美军乐队） | **PD-USGov** |
| `surface` | Grieg Morning Mood（Musopen） | **Public Domain** |
| `cave` | Holst Neptune（1923 录音） | **Public Domain** |
| `tower` | Mussorgsky Night on Bald Mountain（Musopen） | **Public Domain** |
| `site` | Holst Mars（Musopen） | **Public Domain** |
| `combat` | Beethoven Symphony No.5 I（Musopen） | **Public Domain** |
| `ending` | Beethoven Moonlight I（Musopen / Pitman） | **Public Domain** |

每曲均有 `.ogg`（打进 Android）+ Windows 用 `.wav`（仅 `windows/audio/bgm/`，由 CMake 装到 `data/audio/`）。明细见 [`License.txt`](License.txt)。

**平台：**

- Android / 体积优先：仅 `assets/audio/bgm/*.ogg`（勿把 `.wav` 放进 Flutter assets）
- Windows：Media Foundation 不解码 OGG；运行时从 `data/audio/bgm/*.wav` 播放。生成：`python tool/ogg_to_wav.py`

**风格总锚点：** 暗黑奇幻雾塔、16-bit / lo-fi 复古、无人声、不抢 UI。生成提示词详见 [`sound_prompt.md`](sound_prompt.md) / [`tool/prompts/sound_prompt.md`](../../tool/prompts/sound_prompt.md)。

---

## 场景一览

| 场景 | 文件名 | 时长建议 | 循环 | 风格 | 建议免费古典来源（裁切后可再做 8-bit） |
|------|--------|----------|------|------|----------------------------------------|
| 主页 | `home.ogg` | 60–90s | 是 | 宁静、邀请、雾中远塔；慢板、稀疏琶音，不抢按钮 | Debussy《Clair de Lune》慢段；或 Satie《Gymnopédie No.1》 |
| 序章开场 | `prologue.ogg` | 45–90s | 否 | 电影爬行字：史诗但克制、慢推近、神秘远方；可比主页更庄严，勿盖过字幕 | Holst《Venus》或《Neptune》氛围段；或 Wagner《Lohengrin》前奏柔和段；或 Strauss《Also sprach Zarathustra》**仅取极弱氛围垫底**（勿用完整嘹亮铜管开场） |
| 地表 | `surface.ogg` | 90–120s | 是 | 雾林探索、好奇、略湿润弦乐感，80BPM 左右 | Grieg《Morning Mood》(Peer Gynt)；或 Vivaldi《Spring》慢乐章片段 |
| 洞穴 | `cave.ogg` | 90–120s | 是 | 潮湿回响、低沉、谨慎；暗但不恐怖，76BPM 左右 | Bach《Toccata and Fugue in D minor》低音动机放慢；或 Holst《Neptune》氛围段 |
| 塔层 | `tower.ogg` | 90–120s | 是 | 上升压迫、石厅混响、稀疏钟感，84BPM 左右 | Mussorgsky《Night on Bald Mountain》中段压低；或 Bach 平均律慢前奏曲 |
| 站点 | `site.ogg` | 90–120s | 是 | 冷电子遗迹：脉冲 + 去饱和合成感，88BPM 左右 | Holst《Mars》节奏抽离后循环；或公版氛围录音再做成脉冲垫底 |
| 战斗 | `combat.ogg` | 60–90s | 是 | 紧张打击、短动机、约 108BPM，紧张但不混乱 | Wagner《Ride of the Valkyries》节选压混；或 Beethoven《Symphony No.5》动机改编 |
| 结算 | `ending.ogg` | 45–75s | 否 | 苦乐交加的胜利、可淡出、播一次 | Elgar《Nimrod》(Enigma) 尾段；或 Beethoven《Ode to Joy》柔和变奏 |

### 序章开场说明

- UI：`PrologueCrawl`（新游戏经 `HomeEnterTransition` 后弹出，约 30s 滚动字幕，可跳过）。
- 音频：进入爬行字时播 `prologue.ogg`（**不循环**）；进入探索后由 `playExplorationBgm` 接地表等曲目。
- 继续游戏 / 读档**不会**播序章曲。

---

## 许可与取材

- **作品**：多数古典乐谱因超过版权保护期属公有领域。
- **录音**：必须单独确认。请从明确标注 **Public Domain / CC0 / 允许商用** 的来源下载，例如：
  - [Musopen](https://musopen.org/)
  - [IMSLP](https://imslp.org/)（注意每条录音的许可）
  - [Internet Archive](https://archive.org/)（筛 PD）
  - Pixabay / Free Music Archive 等（看古典分类与 License）
- 避免：未写清商用条款、仅 personal use、或未过保护期的现代录音。

---

## 制作清单

1. 下载公版录音 → 裁到建议时长 → 首尾淡入淡出做伪循环（`prologue` / `ending` 除外，可做收束淡出）。
2. （可选）经 `audio8bit` 转成 8-bit 复古感：`python tool/batch_audio8bit_ogg.py --input <mp3或文件夹> -y`。
3. 统一响度：BGM 略低于 UI 点击；同类曲目响度尽量齐。序章曲可略低于主页，避免盖字幕。
4. 放入：

```text
flutter_app/assets/audio/bgm/          # Android / all platforms (OGG only)
  home.ogg
  prologue.ogg
  surface.ogg
  cave.ogg
  tower.ogg
  site.ogg
  combat.ogg
  ending.ogg
flutter_app/windows/audio/bgm/         # Windows PCM only (not in AAB)
  home.wav
  prologue.wav
  ...
```

5. 游戏设置中可开关 BGM；缺文件时播放失败会被静默跳过（debug 日志可见）。

---

## 与代码对应

以下路径已在工程中接线，**保持文件名即可**：

```text
home / prologue / surface / cave / tower / site / combat / ending
```

加载入口：

- `GameAudioService.playHomeBgm`
- `GameAudioService.playPrologueBgm`（`PrologueCrawl`）
- `GameAudioService.playExplorationBgm`
- `GameAudioService.playCombatBgm`
- `GameAudioService.playEndingBgm`
