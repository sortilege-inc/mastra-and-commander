# Squib Rebuild Brief — Ice Chrome frame + new card model

**Task:** rebuild the Squib card pipeline in this repo (`~/Working/mastra-and-commander`)
onto the **new "Ice Chrome" frame** and the **new card data model**, then populate an initial
set from the placeholder cards in the sibling engine repo. Prior context: the pipeline
currently renders the old "Lens" parchment frame (`svg/v3/lens/`, `cards/deck.rb`,
`cards/cards.yml`). We are replacing the frame and the card schema.

## Inputs (sources of truth)

1. **New frame (Ice Chrome):** `temp/Design layers with slot centre notes/`
   - `layers/*.svg` (11 cropped layers) + `spec.json` (canvas, layer z-order/origins, slot
     centres, backing spec, text-box fonts, palette). `temp/` is git-ignored — **copy the
     layers into the repo** (proposed: `svg/v4/ice/` with its `spec.json`).
2. **Card model + rules:** the engine repo
   `~/Working/mastra-and-commander-server/src/games/mastra-and-commander/`
   - `cards/types.ts` — the printed-face data contract (field names mirror the frame).
   - `constants.ts` — the vocabularies (pips, colors, shapes, ecosystems, keywords).
   - Rules doc `cards/game-design.md` (this repo) — the locked mechanics.
3. **Initial card content:** `…/cards/testSet.ts` → `OPERATOR_CARDS` (18 placeholder cards,
   all `TEST-` ids). These are synthetic but concrete; use them to populate `cards.yml`.

## The new card face (what changed)

Per `spec.json` zones + `types.ts`, an Operator card face has **no stat badge, no set-symbol,
and no dedicated type-line zone**. Fields:

| Face element | Source field | Frame zone |
|---|---|---|
| Title | `name` | title-plate (top) |
| Art | (per-card art, later) | art-window octagon |
| **Produce** (output currencies, ≤5) | `produce: Pip[]` | **left rail**, 5 slots |
| **Consume** (input cost, ≤5) | `consume: Pip[]` | **right rail**, 5 slots |
| **Contributes** (≤3) | `contributes: {color,shape}[]` | **bottom rail**, 3 slots |
| Rules text | `rulesText` | rules-panel |
| Type line | `traits: string[]` | **no zone — decision needed** (see below) |

Vocabularies (from `constants.ts`):
- **Pips:** `capital` = **Value** (coin), `attention` = **Attention** (eye), `technology` = **Automation** (gear), `generic` (blank).
- **Colors:** pink, cyan, amber, violet, green. **Shapes:** circle, triangle, square,
  pentagon, hexagon (SHAPES is order-significant).
- Also on cards: `supertype` (ephemeral|persistent), `keywords` (durable|setup),
  `ecosystem` (anthropic|openai|google|oss), `entropyFeed`. These don't all need to render
  yet — at minimum render title/art/produce/consume/contributes/rules.

## Geometry (from `spec.json` — use these exact numbers)

- Canvas 825×1125 @ 300 dpi; trim 750×1050 r40.
- Layer z-order: card-base(10) → art-placeholder(20) → art-window(30) → frame(40) →
  title-plate(50) → rules-panel(50) → rails(60) → guides(999, non-printing).
- **Slot centres** (place icons here; rails already contain empty backings):
  - produce (left): x 82.5; y 396.5 / 468.5 / 540.5 / 612.5 / 684.5
  - consume (right): x 742.5; same ys
  - contributes (bottom): y 1022.5; x 271.5 / 412.5 / 553.5
  - backing: chamfered square, size 62, **icon box ≤53** — size icons to fit.
- **Text boxes / fonts:**
  - Title: box (170,95,485,52), **Chakra Petch 700, 40 px, UPPERCASE, centered**, `#14323f`.
  - Rules: box (190,740,445,210), **Barlow 400, 26 px, leading 33, left**, `#1a3441`.
- Palette + a single accent hue `#00c2d4` (recolor by find/replace for card-type variants);
  `accentAlternates` gives teal/oxblood/gold/violet/cyan/magenta.

## Steps

1. **Import the frame.** Copy `temp/…/layers/*.svg` + `spec.json` → `svg/v4/ice/`. Note each
   layer SVG uses a `viewBox` already offset to canvas coords (e.g. rail-left is
   `viewBox="34 354 97 372"`), so place at its `x/y/w/h`.
2. **Fonts.** Install **Chakra Petch** and **Barlow** (both OFL) into
   `~/.local/share/fonts`, `fc-cache -f`, and confirm the Pango family strings resolve
   (`fc-match "Chakra Petch:weight=700"`, `fc-match "Barlow"`). Same px→pt rule as before:
   `pt = px × 72 / 300`.
3. **Icons.** Build two small icon sets sized to the ≤53 px slot box:
   - **Pips (4):** coin/eye/gear/blank, styled to read on the dark chamfered sockets
     (light/glowing). Reuse the glyphs from `svg/08-pips/` but restyle for ice-chrome, or
     draw fresh.
   - **Contribution marks (5 shapes × 5 colors):** filled shape glyphs (circle/triangle/
     square/pentagon/hexagon) in the 5 colors — generate procedurally (shape path + color).
4. **`cards.yml` — new schema.** Replace the old schema. Transcribe the 18 `OPERATOR_CARDS`
   from `testSet.ts` into it (keep the `TEST-…`-derived names; mark the file clearly as a
   placeholder set). Example entry:
   ```yaml
   - name: Supervisor Agent
     traits: [Agent]
     supertype: ephemeral
     consume: [technology, technology, generic]   # right rail
     produce: [attention, attention]              # left rail
     contributes: [{color: cyan, shape: square}, {color: cyan, shape: circle}]  # bottom
     keywords: []
     ecosystem: anthropic
     rules: "Coordinates subagents. Feeds 2 Entropy — coordination is disorder."
   ```
5. **Rewrite `deck.rb`.** Drive everything from `svg/v4/ice/spec.json`:
   - Composite layers in z-order. Art: fill the octagon art-window with per-card art (or
     `art-placeholder.svg`), **clipped to the octagon** — Squib's `mask:` fills a colour, so
     reuse the matte/cairo-clip approach (aperture-mask.svg is a solid octagon in the art
     box); draw `art-window.svg` (rim) above.
   - Title (Chakra Petch) and rules (Barlow) per the text-box fonts; keep the **rich rules
     mini-syntax** (`**bold**`, inline `{gear}{eye}{coin}{blank}`) and the embed `dy` fix.
   - Place produce icons at the left slot centres (first N), consume at the right, contributes
     at the bottom. Leave unused slots as the empty backing already in the rail SVG.
   - **No** stat badge / set-symbol / type-bar.
6. **Pilot + verify.** Render one Operator card that exercises all rails — e.g.
   **Supervisor Agent** (2 produce, 3 consume, 2 contributes) or **Agent Swarm** (3/3/3) —
   read the PNG back, tune icon size/placement + text fit, then render all 18 and build a
   `montage` contact sheet.

## Decisions to surface to the owner (don't guess silently)

- **Type line placement:** the frame has no type-line zone but `traits` should show somewhere.
  Options: a slim line at the top of the rules panel, a subtitle under the title, or omit for
  now. Recommend: **small line atop the rules panel.**
- **Other card kinds** (Entropy / Eval / Feature / Equipment / Model / Commander) have
  different layouts — Eval has patterns not produce/consume; Entropy has an effect; Mastra
  commander is **pending redesign, do not build**. Scope this pass to the **18 Operator cards**;
  treat the rest as a follow-up needing their own frame treatment.
- **Old Lens frame:** keep `svg/v3/lens/` + the old `deck.rb` path as an alternate, or replace
  outright? Recommend keeping Lens available behind a `FRAME=lens|ice` env switch.

## Known gotchas (carried from the current pipeline)
- Squib font size is **points at dpi** → `pt = px × 72/300`.
- Pango weights: use un-hyphenated named weights; italics via `<i>` markup, never a `…Italic`
  family string.
- Inline embed icons need `valign: :top` + a negative `dy` (≈ −26 at 32 px) to sit on the line.
- Art clipping needs the matte/cairo approach (mask fills colour, doesn't clip).
