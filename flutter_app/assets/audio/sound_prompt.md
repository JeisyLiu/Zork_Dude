# 迷雾之塔 · 音频生成提示词

与 [`image_prompt.md`](../images/image_prompt.md) 对齐：**暗黑奇幻、雾塔氛围、16-bit 复古游戏感、低保真但干净、无人声歌词**。

格式建议：**OGG Vorbis**（体小、循环友好）。若生成工具只出 WAV/MP3，可先导出再转 OGG（`ffmpeg -i input.wav -c:a libvorbis -q:a 4 output.ogg`）。

---

## 风格锚点

```text
dark fantasy mist tower adventure game audio,
retro 16-bit inspired chiptune and lo-fi synth textures,
muted charcoal, olive, and antique gold tonal palette,
atmospheric but readable, restrained arrangement,
no vocals, no lyrics, no recognizable pop melodies,
clean transients for UI and combat SFX, subtle reverb tails
```

### 负面提示（Negative）

```text
orchestral blockbuster, cinematic trailer, modern EDM drop,
cartoon slapstick, realistic foley library clutter,
copyright pop song pastiche, choir vocals, spoken dialogue,
harsh clipping, muddy low-end, overly bright EDM hi-hats
```

### 技术建议

| 类型 | 采样率 | 位深 | 备注 |
|------|--------|------|------|
| BGM | 44.1 kHz | 16-bit | 循环点应无缝；导出前检查首尾波形 |
| SFX | 44.1 kHz | 16-bit | 单声道或立体声均可；音头清晰、尾音短 |

---

## BGM（`assets/audio/bgm/`）

| 路径 | 时长建议 | 循环 | 英文生成提示词 | 中文说明 |
|------|----------|------|----------------|----------|
| `bgm/home.ogg` | 60–90s | 是 | `calm dark fantasy title screen loop, soft misty pads, sparse arpeggio, gentle pulse at 72 BPM, nostalgic 16-bit adventure mood, no vocals` | 主页：宁静、邀请感，不抢 UI |
| `bgm/surface.ogg` | 90–120s | 是 | `exploration loop for misty forest surface, light wind texture, muted strings-like synth, curious not ominous, 80 BPM, seamless loop` | 地表层：雾林探索 |
| `bgm/cave.ogg` | 90–120s | 是 | `underground cave exploration loop, damp echo, low drones, dripping ambience, cautious tempo 76 BPM, dark but not horror` | 洞穴层：潮湿回响 |
| `bgm/tower.ogg` | 90–120s | 是 | `ancient tower ascent loop, rising tension, stone reverb, sparse bells, oppressive mist motif, 84 BPM` | 塔层：压迫、上升感 |
| `bgm/site.ogg` | 90–120s | 是 | `ruined techno-fantasy site loop, cold digital pulses, distant machinery hum, desaturated synth, 88 BPM, eerie restraint` | 站点层：电子冷感遗迹 |
| `bgm/combat.ogg` | 60–90s | 是 | `turn-based battle loop, driving percussion, urgent bass, short melodic motif, 108 BPM, tension without chaos` | 战斗：紧张节奏 |
| `bgm/ending.ogg` | 45–75s | 否 | `ending credits stinger evolving into gentle resolution, bittersweet victory theme, sparse piano-like chiptune, fade-friendly ending` | 结算：一次播放，可淡出 |

---

## UI 音效（`assets/audio/sfx/ui/`）

| 路径 | 时长建议 | 循环 | 英文生成提示词 | 中文说明 |
|------|----------|------|----------------|----------|
| `sfx/ui/click.ogg` | 0.05–0.12s | 否 | `short UI button click, soft pixel blip, crisp attack, no reverb tail` | 通用按钮点击 |
| `sfx/ui/open_panel.ogg` | 0.1–0.25s | 否 | `panel open whoosh blip, upward pitch sweep, light` | 打开面板 |
| `sfx/ui/close_panel.ogg` | 0.1–0.25s | 否 | `panel close blip, downward pitch sweep, soft` | 关闭面板 |
| `sfx/ui/confirm.ogg` | 0.1–0.2s | 否 | `confirm chime, positive two-note, clean` | 确认 |
| `sfx/ui/cancel.ogg` | 0.1–0.2s | 否 | `cancel thud, muted negative tone, short` | 取消 |

---

## 探索音效（`assets/audio/sfx/explore/`）

| 路径 | 时长建议 | 循环 | 英文生成提示词 | 中文说明 |
|------|----------|------|----------------|----------|
| `sfx/explore/footstep.ogg` | 0.08–0.15s | 否 | `single soft footstep on dirt and moss, subtle, repeatable` | 移动一步 |
| `sfx/explore/pickup.ogg` | 0.1–0.25s | 否 | `item pickup sparkle, bright short chime, satisfying` | 拾取物品 |
| `sfx/explore/drop.ogg` | 0.1–0.2s | 否 | `item drop clink on stone, short dull impact` | 丢弃物品 |
| `sfx/explore/use_item.ogg` | 0.15–0.35s | 否 | `use consumable shimmer, magic sparkle, medium length` | 使用物品 |
| `sfx/explore/talk.ogg` | 0.1–0.25s | 否 | `dialogue open blip, friendly notification tone` | 开始对话 |
| `sfx/explore/map_open.ogg` | 0.15–0.3s | 否 | `map unfold paper rustle plus soft chime` | 打开/关闭地图 |
| `sfx/explore/room_enter.ogg` | 0.2–0.4s | 否 | `enter new area sting, subtle ambient swell, not loud` | 进入新房间 |

---

## 战斗音效（`assets/audio/sfx/combat/`）

| 路径 | 时长建议 | 循环 | 英文生成提示词 | 中文说明 |
|------|----------|------|----------------|----------|
| `sfx/combat/battle_start.ogg` | 0.4–0.8s | 否 | `battle encounter fanfare sting, short dramatic swell, RPG style` | 遭遇战开始 |
| `sfx/combat/attack.ogg` | 0.1–0.2s | 否 | `weapon swing whoosh, crisp attack wind, no impact yet` | 出手攻击 |
| `sfx/combat/hit.ogg` | 0.1–0.25s | 否 | `impact hit on armor, punchy mid thud, clear transient` | 命中伤害 |
| `sfx/combat/heal.ogg` | 0.2–0.4s | 否 | `healing sparkle ascending tones, gentle bright` | 治疗 |
| `sfx/combat/skill.ogg` | 0.2–0.45s | 否 | `special skill cast, magic burst, slightly longer tail` | 技能 |
| `sfx/combat/miss.ogg` | 0.08–0.15s | 否 | `miss whiff, airy swipe, no impact` | 未命中 |
| `sfx/combat/flee.ogg` | 0.2–0.35s | 否 | `flee retreat footsteps fading, quick` | 逃跑 |
| `sfx/combat/victory.ogg` | 0.6–1.2s | 否 | `short victory jingle, uplifting 3-note motif, retro RPG` | 战斗胜利 |
| `sfx/combat/defeat.ogg` | 0.6–1.2s | 否 | `defeat downer sting, descending minor motif, brief` | 战斗失败 |
| `sfx/combat/status.ogg` | 0.15–0.3s | 否 | `status effect tick, poison or buff pulse, subtle` | 状态效果 |

---

## 放置说明

1. 按上表文件名放入对应目录（仓库内已有 `.gitkeep` 占位）。
2. 保持路径与 [`audio_assets.dart`](../../lib/services/audio/audio_assets.dart) 常量一致。
3. 缺文件时游戏静默跳过，不崩溃。
4. 批量生成时固定同一模型与 style 权重，BGM 先出 30s 试听再扩至目标长度。
