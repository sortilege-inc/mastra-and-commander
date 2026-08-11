# Art Direction — "Netrunner meets Arkham Horror"

Visual target for **Mastra & Commander** cards: the muted, occult, atmospheric palette and
iconography of Fantasy Flight's **Arkham Horror: The Card Game**, crossed with the corporate-
cyberpunk sci-fi and **typography of Android: Netrunner**.

## Palette — BOLD, not washed out
Early parchment-heavy renders read too faded. Direction is **high-contrast and saturated**:
- **Grounds:** deep ink-black / dark slate — **NOT parchment**.
- **Accents:** vivid jewel tones — electric teal, oxblood crimson, luminous gold, deep violet.
- **Tech overlays:** glowing neon cyan/magenta circuit traces and highlights.
- **Avoid:** aged paper, sepia, muted/faded/tarnished tones, heavy grunge.

## Type & icons
- **Type:** bold **condensed geometric sans**, corporate-hacker feel (Netrunner-adjacent);
  small-caps for titles/type lines.
- **Icons:** clean, angular, geometric resource pips + occult-deco filigree corners; faint
  data-grid / glitch textures behind art.

## Layout — zones
Title bar (top) · central art window · lower rules panel, plus **three icon rails**:
- **LEFT edge = Produce** (output currencies this card generates)
- **RIGHT edge = Consume / Cost** (input cost)
- **BOTTOM edge = Contributes** (color + shape, the Eval currency)

---

## Midjourney — card FRAME / TEMPLATE concept (BOLD, with I/O zones)

Zone legend for compositing: **LEFT rail = Produce · RIGHT rail = Consume/Cost · BOTTOM row =
Contributes**.

```
A single science-fiction trading card, portrait orientation, front face — Arkham Horror: The
Card Game meets Android: Netrunner, BOLD and high-contrast. Deep ink-black and dark slate
ground, saturated jewel tones (electric teal, vivid oxblood crimson, luminous gold, deep
violet) with glowing neon cyan and magenta accents. Ornate art-deco-meets-circuitry border,
crisp sharp linework, strong metallic definition. Clear separated layout zones: a bold TITLE
BAR across the top; a central ILLUSTRATION WINDOW; a LOWER RULES PANEL beneath it; a vertical
rail of distinct glowing geometric ICONS running down the LEFT edge; a matching vertical rail
of icons down the RIGHT edge; and a horizontal row of icons across the BOTTOM edge. Netrunner-
style bold condensed geometric hacker typography. Dramatic high-contrast lighting, vivid color,
sharp focus, high definition, striking and punchy, print-ready --ar 5:7 --style raw --stylize
150 --no parchment, aged paper, sepia, washed out, faded, muted, grunge --v 7
```

Still too soft? Push `--stylize 100`, add `neon-noir, cinematic color grade` up front. Border
too eroded/busy? Add `clean, precise, engraved`, drop grunge-adjacent words. Midjourney can't
render meaningful icons — these rails are **compositional placeholders**; real icons go on via
the Squib pipeline.

## Midjourney — card WITH art (worked example, e.g. "Mastra")

```
Sci-fi trading card, portrait, front face, Arkham Horror LCG meets Android: Netrunner. Central
painterly illustration of a robotic orchestra in a concert hall conducted by a gloved hand,
cool teal-and-violet stage light. Aged-parchment and ink-black frame with oxblood and tarnished-
brass art-deco filigree, thin neon circuit traces, angular geometric cost pips down the left
edge, bold title bar, lower rules panel, condensed geometric hacker typography. Atmospheric,
occult-corporate, high detail --ar 5:7 --style raw --stylize 300 --v 7
```

## Midjourney — ILLUSTRATION ONLY (for the art/ window)

```
Painterly sci-fi key art: <SUBJECT>, atmospheric occult-cyberpunk mood, muted teal / oxblood /
brass palette with sparing neon accents, Arkham-Horror-meets-Netrunner aesthetic, dramatic
lighting, high detail, no text, no border --ar 3:4 --style raw --v 7
```

## Notes
- **Midjourney can't render legible UI text/numbers** — use these for **frame mood + window
  art**, then composite real title/rules/pips/contribution via the Squib pipeline (`deck.rb`).
- The **illustration-only** prompt (`--ar 3:4`, `no text, no border`) is the one that feeds
  `art/<name>.png`; the frame/example prompts are for exploring the overall look.
- Tune `--stylize` (lower = more literal to the prompt, higher = more artistic). Swap `--v 7`
  for whatever the current Midjourney version is.
