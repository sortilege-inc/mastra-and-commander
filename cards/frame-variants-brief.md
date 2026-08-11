# Card Frame Variants — Design Brief for Claude Design

**Goal:** extend the existing **Ice Chrome** card frame into **five more style variants**, one
per non-Operator card kind, plus an optional **Commander** prestige frame. Each variant keeps
the Ice Chrome material and layout language but has (a) its **own accent color tone** and (b)
**slight frame variations** appropriate to that card kind's data. Output must stay
pipeline-compatible (same conventions as the base).

## Base to vary

The existing **Operator** frame (your "Card Frame – Ice Chrome" project). Recall from its
`spec.json`:
- 825×1125 @ 300dpi; translucent glassy chrome; chamfered sockets (size 62, icon box ≤53).
- Every accent hairline uses **one hue** (`#00c2d4`) — so a variant is largely a **find/replace
  recolor of that accent** plus the frame/zone edits below.
- Fonts: **Chakra Petch** (titles, bold, uppercase, `#14323f`), **Barlow** (rules, `#1a3441`).
- Layer set + `spec.json` (layers w/ x/y/w/h + z, zones, slots, textBoxes, palette).

## Shared conventions (all variants)

- Same canvas, trim, layer-file-per-artwork + `spec.json` format, and backing style as the base.
- Deliver each variant as **its own folder** `svg/v4/<variant-id>/` (mirroring `svg/v4/ice/`):
  the layer SVGs it needs **plus a `spec.json`** with that variant's `accent`, `layers`, `zones`,
  `slots`, and `textBoxes`. Reuse/inherit base layers where unchanged; only redraw what differs.
- Keep title-plate + rules-panel in every variant (all card kinds have a name + rules text).
- Icons are composited by our pipeline — provide **empty slot backings** at slot centres, never
  specific icons.

## The six variants

Accent tones (from the base palette's `accentAlternates`, plus two new):

| Variant | id | Accent | Frame changes vs. Operator base | Renders (data) |
|---|---|---|---|---|
| **Operator** | `ice` | cyan `#00c2d4` | — (exists) | produce (L,5) · consume (R,5) · contributes (B,3) |
| **Entropy** | `entropy` | oxblood `#7d1c2b` | **Remove all three rails.** Enlarge the rules panel to fill the freed space. Add a **vector badge** (a prominent tab, top-left) and subtle **glitch/corruption** accent detailing. Menacing. | name · a **vector** (Pollution / Subversion / Hijack / Noise / Targeted, from `traits`) · rules |
| **Eval / Objective** | `eval` | gold `#d9a12a` | Recast the art window as an **objective/target panel**. Add a **difficulty track** (3 pips, top-right) and a **par readout** (a numeric well). Add a **required-hand strip** along the bottom (≤5 slots) for the target contribution pattern. "Mission dossier." | name · target hand (patterns) · **par** · **difficulty 1–3** · rules |
| **Feature** | `feature` | violet `#6b57c9` | **Compact:** smaller/omitted art window, no rails. One central **effect-icon slot**. A **"NO ENTROPY" tab**. | name · one effect icon · rules |
| **Equipment** | `equip` | teal-green `#0f9a92` | Remove consume + contributes. Keep **one "grants" rail** (repurpose the left rail, ≤3 slots) for the resources it grants. Simplified body. | name · **grants** pips (≤3) · rules |
| **Model** | `model` | indigo `#3f7fd0` (new) | Like Equipment (one **grants** rail) **plus an upgrade/tier marker** (a small chevron/tier pip near the title). | name · **grants** pips (≤3) · rules |
| **Commander** *(optional)* | `commander` | platinum / warm-white prestige (distinct from Eval gold via **ornamentation**, not just hue) | An **ornate prestige frame** — heavier bezel, a **command-zone marker**, one ability/rules zone; no rails. Content is a placeholder (the Mastra card is being redesigned) — design the **frame** only. | name · rules |

## `spec.json` per variant

Same shape as the base, adjusted:
- `accent`: the variant hue above (and recolor the hairlines to it).
- `layers`: only those the variant uses (drop rail layers it removes; add new ones like
  `vector-badge`, `difficulty-track`, `par-well`, `grants-rail`, `effect-slot`, `hand-strip`).
- `slots`: rename/replace to match — e.g. Equipment/Model → `grants: [[…]]`; Eval →
  `hand: [[…]]` + `difficulty: [[…]]`; Entropy → none (or a `vector` anchor point).
- `textBoxes`: keep `title` + `rules`; Eval adds a `par` box; give the enlarged Entropy rules
  panel a bigger `rules` box.

## Notes
- Keep the variants clearly a **family** — same chrome material, bevels, corner notches, and
  typography; the tone + the rail/zone edits are what distinguish them.
- Equipment and Model share the "one grants rail" body; differentiate by **accent + the Model
  tier marker** only.
- Return the folders + `spec.json`s; our Squib pipeline selects a frame per card kind and
  composites the icons/text.
