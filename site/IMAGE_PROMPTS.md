# 官网落地页 · 补图提示词

## `hero_mist_wide.png`（建议 16:9，960×540 或 1280×720）

用于主页首屏全幅背景。色板与 `mist_tower_hero.png` 一致。

### Positive

```text
widescreen pixel art landscape, solitary ancient mist tower on a distant ridge,
two horizontal fog bands across the valley, gnarled forest silhouettes at edges,
dawn mystery not horror, vast empty sky above the fog,
minimalist pixel art for a dark fantasy adventure game,
muted charcoal brown, dark olive and desaturated antique gold palette,
sparse tiny glowing runes on the tower, crisp 16-bit pixel edges, restrained detail,
atmospheric, no characters, no text, no logo, no UI frame, 16:9
```

### Negative

```text
photorealistic, cinematic photo, Unreal Engine, 3D render, painterly oil painting,
smooth gradients, high detail, busy composition, noisy dithering, anime, chibi,
readable text, watermark, logo, HUD, thick frame border, collage, neon colors,
purple glow, blue cyberpunk, characters in foreground
```

### 使用方式

生成后保存为 `site/images/hero_mist_wide.png`，在 `index.html` 的 `.hero` 背景中引用；未生成前可继续用 `bg_surface.png` 作底图。
