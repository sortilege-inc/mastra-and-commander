# Mastra & Commander — cards

Card content, printed frames, and the Squib render pipeline for the trading card
game **Mastra & Commander** (an asymmetric "alignment duel"). The play engine
lives in the sibling repo `../mastra-and-commander-server`.

Design docs (living, status-tagged) are in [`cards/`](cards/):
- [`game-design.md`](cards/game-design.md) — the ruleset (🔒 locked / 🟨 proposed / ❓ open).
- [`content-spec.md`](cards/content-spec.md), [`card-candidates.md`](cards/card-candidates.md) — card roster / candidate pool.
- [`frame-design-brief.md`](cards/frame-design-brief.md), [`art-direction.md`](cards/art-direction.md) — frame + art direction.
- [`squib-rebuild-brief.md`](cards/squib-rebuild-brief.md) — the brief this pipeline was built from.

## The frames — "Ice Chrome" family (`svg/v4/`)

Translucent glassy sci-fi frames (Netrunner-meets-Arkham, bright/crisp) on an
**825×1125 @ 300dpi** canvas (manifest `svg/v4/index.json`, `version` 3.2.0 — expanded
art window, shorter rules panel). **One variant per card kind** (`svg/v4/<id>/` with its
own `spec.json`). Each shares the chrome material + a **subtitle traits plate**, a rotated
**type-overlay** bar, and a **collector** footer, and differs by **accent tone** + slot groups:

| variant | kind | accent | slots |
|---|---|---|---|
| `ice` | Operator | cyan | produce (L,5) · consume (R,5) · contributes (B,3) |
| `entropy` | Entropy | oxblood | vector badge (no rails) |
| `eval` | Objective | gold | hand (≤5) · difficulty (1–3) · par |
| `feature` | Feature | violet | one effect slot · "NO ENTROPY" tab |
| `loadout` | Loadout | teal-green | grants (≤3) |
| `model` | Model | indigo | grants (≤3) · tier marker |
| `framework` | Framework | platinum | Mastra prestige frame |
| `token` | Token | ubuntu-orange | near-full art · no rules panel · no slots |

**Card backs** (`svg/v4/backs/`): two shared, all-baked, 180°-symmetric backs — `operator`
(cyan; used by every non-Entropy deck) and `entropy` (oxblood). `deck.rb` renders them to
`output/back_operator.png` / `output/back_entropy.png`.

## Card content — `cards/cards.yml`

One entry per card (currently the 18 **Operator** placeholders transcribed from the
engine repo's `testSet.ts`). Fields mirror the face:

| field | notes |
|---|---|
| `name` | title |
| `traits` | type line (list) |
| `consume` | right rail cost, ≤5 — Value `capital` · Attention `attention` · Automation `technology` · `generic` |
| `produce` | left rail output, ≤5 — same pips |
| `contributes` | bottom, ≤3 — `"color/shape"`; colors `pink cyan amber violet green`, shapes `circle triangle square pentagon hexagon` |
| `rules` | rules text; mini-syntax `**bold**` + inline `{gear}{eye}{coin}{blank}` |
| `supertype`/`ecosystem`/`keywords` | mechanics; not rendered yet |

Pip and contribution icons are **generated inline** by `deck.rb` (light on the dark
rail sockets, dark inline on the light rules panel) — no icon asset files.

## Build

Needs Ruby 3.3+, the cairo/pango/rsvg/gdk-pixbuf dev libs + `libgirepository1.0-dev`,
and the **Chakra Petch** + **Barlow** fonts (OFL) installed for Pango. Then:

```bash
bundle install
bundle exec ruby cards/deck.rb            # render every card → output/
ONLY=Agent bundle exec ruby cards/deck.rb # just matching cards (fast)
GUIDES=1  bundle exec ruby cards/deck.rb  # overlay frame guides
```

Outputs (git-ignored) land in `output/`: `card_NN.png` (825×1125) + `mastra_cards.pdf`.
`deck.rb` is driven entirely by `svg/v4/ice/spec.json`.

## Status / next

- **All 43 cards render** across the 7 variants (18 operator, 10 entropy, 6 eval,
  4 feature, 2 equipment, 2 model, 1 framework), with per-kind content: operator
  rails, eval **hand strip + par + difficulty**, feature **effect glyph**, entropy
  **vector**, equipment/model **grants**.
- Eval hand marks use a small token grammar (`color/shape`, `color/*`, `*/shape`,
  `!color`, `*`); feature effects are `draw` / `shield` / `grant/PIP`.
- **Follow-ups:** long titles (e.g. "GPU Unavailability") need title auto-shrink.
- Per-card **art** not wired yet (all cards use the placeholder art window); real art
  drops into `art/` and gets clipped to the octagon aperture.
- Card content is **placeholder** (`TEST-` set) pending the owner's card-design pass.
