# 迷雾之塔 · 像素风插画提示词

与游戏整体一致：**标题页、探索底图、结算插画全部用像素风**。  
风格以标题主图的**原始提示词**为准（见下方「风格锚点」），其他图只换题材与构图，不换画风。

---

## 风格锚点（主图原始提示词）

路径：`home/mist_tower_hero.png`  
以下为当时生成主图的完整提示；**色板 / 像素规格 / 克制细节** 应落到每一张图。

```text
Minimalist pixel art emblem for a dark fantasy adventure game, a solitary ancient mist tower silhouette rising through two horizontal layers of fog, symmetrical centered composition, muted charcoal brown, dark olive and desaturated antique gold palette, sparse tiny glowing runes, crisp 16-bit pixel edges, restrained detail, atmospheric but readable at icon size, no characters, no text, no logo, no UI frame, large empty margin around the tower, transparent background, square 1:1 composition
```

### 从主图抽出来的「统一风格句」（其他图都带上）

只保留跨图通用的部分；居中、留白、透明底、1:1 等是图标构图，**不要**套到场景/结算上。

```text
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no text, no logo, no UI frame
```

### 负面提示（Negative）

```text
photorealistic, cinematic photo, Unreal Engine, 3D render, painterly oil painting,
smooth gradients, high detail, busy composition, noisy dithering, anime, chibi,
readable text, watermark, logo, HUD, thick frame border, collage, neon colors
```

---

## 要不要传主图当参考？

| 做法 | 结论 |
|------|------|
| **提示词对齐主图原句** | 必须：共用上面的「统一风格句」 |
| **主图作风格参考（推荐）** | 每张带上 `mist_tower_hero.png` 作 style/sref，像素边与色板更稳 |
| **主图作图生图底图** | 不推荐：会把「居中塔标」构图硬套进场景 |

**建议：** 风格参考图 + 统一风格句 + 各条题材描述；同一模型、同一 style 权重批量出。

### 建议尺寸

| 用途 | 比例 | 建议生成分辨率 |
|------|------|----------------|
| 探索底图 `bg_*.png` | 16:9 | 640×360 或 960×540（再 nearest-neighbor 放大） |
| 结算插画 `ending/*.png` | 16:9 | 640×360 或 960×540 |
| 标题英雄图 | 1:1 | 256×256～512×512 |

---

## 探索场景底图

路径：`assets/images/exploration/`

### 1. `bg_surface.png` — 地表层

**游戏内容：** 迷雾森林、村落、十字路口。

```text
widescreen pixel art scene, dirt forest path into layered mist, gnarled trees framing sides,
two soft horizontal fog bands, tiny distant village roofs in haze, mossy rocks,
dawn mystery not horror, restrained environment detail,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

### 2. `bg_cave.png` — 洞穴层

**游戏内容：** 洞穴通道、苔藓、火把。

```text
widescreen pixel art scene, damp cave tunnel forking into darkness, rough rock walls,
small patches of moss, cobblestone floor, few wall torches with antique-gold pixel flames,
cool dark shadows, restrained dungeon detail,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

### 3. `bg_tower.png` — 高塔层

**游戏内容：** 古塔回廊、窗外迷雾。

```text
widescreen pixel art scene, long mist tower corridor, dark pillars, one lattice window with dim antique-gold glow,
stone floor, open side overlooking layered horizontal fog, hanging lantern silhouette,
lonely interior, restrained architectural detail,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

### 4. `bg_site.png` — 收容站点层

**游戏内容：** SCP 风地下走廊；色板仍跟主图，只用少量冷灰表达工业，避免霓虹青。

```text
widescreen pixel art scene, abandoned underground facility corridor, stained concrete and rust pipes,
dark hallway, one small antique-gold flashlight pool on floor, distant vault door,
cold charcoal industrial mood still within muted olive-brown family, restrained detail,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

---

## 结算插画

路径：`assets/images/ending/`  
塔的剪影/雾带尽量贴近主图语汇（layered fog、antique gold 高光）。

**可读性（重要）：** 结算图不要大面积死黑。暗部至少要有 **灯 / 火把 / 发光宝物 / 塔窗光** 之一照亮主体；中景雾可亮一些，主体轮廓必须看得清。

结算图可额外加一句：

```text
clear readable lighting, subjects lit by warm antique-gold lamps torches or glowing treasure, no pitch-black voids
```

负面可追加：`pitch black, underexposed, unreadable silhouette, crushed shadows`

### 5. `dragon_clear.png` — 幼龙已陨落

```text
widescreen pixel art ending scene, young dark dragon collapsed on mossy stone terrace clearly lit,
bright antique-gold teardrop magic gem on pedestal as strong light source illuminating dragon and floor,
wall torches or standing braziers with warm flames at terrace edges, sea of fog with two soft fog layers,
distant jagged mist tower with glowing windows, solemn victory, clear readable lighting not too dark,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no text, no logo, no UI frame, 16:9
```

### 6. `journey_complete.png` — 迷雾消散（主线通关）

```text
widescreen pixel art ending landscape, tiny hooded traveler from behind on forest path clearly visible,
traveler holding a warm glowing lantern, distant mist tower with several lit windows in thinning layered fog,
tower edge dissolving into sparse antique-gold pixel sparks, soft golden dusk light filling the valley mist,
bittersweet freedom, clear readable lighting not too dark, restrained detail,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no text, no logo, no UI frame, 16:9
```

### 7. `site_clear.png` — 站点行动完成

```text
widescreen pixel art ending scene, open containment vault doors, bright antique-gold anomalous core as main light,
core glow lighting floor walls and door edges, wall-mounted lamps and a few warm indicator lights,
few floating dark shards catching the glow, cave-industrial bunker quiet aftermath,
clear readable lighting not too dark, restrained detail, muted charcoal olive gold palette not neon,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

### 8. `game_over.png` — 你倒下了

```text
widescreen pixel art defeat scene, fallen adventurer face-down in muddy misty forest clearly lit in foreground,
broken lantern beside them still casting a strong warm antique-gold pool of light on body sword and ground,
second torch or lantern glow nearby among gnarled trees, layered grey-olive fog catching light,
distant mist tower with glowing windows, somber no gore, clear readable lighting not pitch black,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing accents, crisp 16-bit pixel edges, restrained detail,
atmospheric, no text, no logo, no UI frame, 16:9
```

---

## 封面按钮底板（无字）

路径：`home/button_enter.png`  
程序叠字：「进入迷雾」/ `enter`。图上**不要画任何文字**。

**规格：** 横向长条；建议源图 **128×48** 或 **160×56**（可 nearest-neighbor 放大）；透明底；中间留出平坦暗色填色区给文字。

**风格参考：** `mist_tower_hero.png`

```text
minimalist pixel art UI button plate for a dark fantasy adventure game,
wide horizontal empty stone tablet button with dark weathered border,
flat empty center panel for overlay text, no letters no numbers no glyphs,
muted charcoal brown dark olive desaturated antique gold rim highlights,
sparse tiny glowing rune dots on corners only, crisp 16-bit pixel edges,
restrained detail, atmospheric but readable as a game button,
transparent background, no characters, no text, no logo, no UI frame around the button,
landscape 3:1 composition
```

负面追加：`text, letters, words, title, caption, watermark, busy ornaments, wooden kenney style, cartoon wood plank`

---

## 文件对照

| 文件 | 图层 / 结局 | 风格 |
|------|-------------|------|
| `home/mist_tower_hero.png` | 标题锚点 | 原始提示词（完整） |
| `home/button_enter.png` | 封面进入按钮底板 | 统一风格句 + 无字底板 |
| `exploration/bg_surface.png` | 地表 | 统一风格句 + 题材 |
| `exploration/bg_cave.png` | 洞穴 | 同上 |
| `exploration/bg_tower.png` | 高塔 | 同上 |
| `exploration/bg_site.png` | 收容站 | 同上（色板跟主图） |
| `ending/dragon_clear.png` | 幼龙已陨落 | 同上 |
| `ending/journey_complete.png` | 迷雾消散 | 同上 |
| `ending/site_clear.png` | 站点行动完成 | 同上 |
| `ending/game_over.png` | 你倒下了 | 同上 |
