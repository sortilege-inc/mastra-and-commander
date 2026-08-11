# Mastra & Commander — cards

Card content, printed frames, and the Squib render pipeline for the trading card
game **Mastra & Commander** (an asymmetric "alignment duel"). The play engine
lives in the sibling repo `../mastra-and-commander-server`.

Design docs (living, status-tagged) are in [`cards/`](cards/):
- [`game-design.md`](cards/game-design.md) — the ruleset (🔒 locked / 🟨 proposed / ❓ open).
- [`content-spec.md`](cards/content-spec.md), [`card-candidates.md`](cards/card-candidates.md) — card roster / candidate pool.
- [`frame-design-brief.md`](cards/frame-design-brief.md), [`art-direction.md`](cards/art-direction.md) — frame + art direction.
- [`squib-rebuild-brief.md`](cards/squib-rebuild-brief.md) — the brief this pipeline was built from.

## The frame — "Ice Chrome" (`svg/v4/ice/`)

Translucent glassy sci-fi frame (Netrunner-meets-Arkham, but bright/crisp), on an
**825×1125 @ 300dpi** canvas (2.5×3.5in + bleed). Layered SVGs + `spec.json`
(layer origins/z-order, slot centres, text-box fonts, palette). The card face has:

- **Title** (top) · **art window** (beveled octagon) · **rules panel** (lower).
- **Produce** — left rail, ≤5 pip slots (output currencies).
- **Consume / cost** — right rail, ≤5 pip slots (input cost).
- **Contributes** — bottom rail, ≤3 slots (color + shape; the Eval currency).
- **Traits** — slim type line atop the rules panel.

No stat badge / set-symbol / type bar (removed with the old Lens frame).

## Card content — `cards/cards.yml`

One entry per card (currently the 18 **Operator** placeholders transcribed from the
engine repo's `testSet.ts`). Fields mirror the face:

| field | notes |
|---|---|
| `name` | title |
| `traits` | type line (list) |
| `consume` | right rail cost, ≤5 — pips: `capital` `attention` `technology` `generic` |
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

- Rendering **Operator cards** only. Entropy / Eval / Feature / Model / Commander
  cards need their own layouts (different faces) — a follow-up pass.
- Per-card **art** not wired yet (all cards use the placeholder art window); real art
  drops into `art/` and gets clipped to the octagon aperture.
- Card content is **placeholder** (`TEST-` set) pending the owner's card-design pass.
