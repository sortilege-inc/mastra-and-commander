# Mastra — Card Frame System (The Lens)

Trading-card frame system for Mastra, imported from the Claude Design project
*Custom AI trading card design* and implemented as a standalone static page.

The card is a single tilted **lens** of art filling almost the whole face, bleeding out
of both right-hand corners. Title plate, type bar and text box sit *on* the lens; the
frame runs underneath them. The only parchment left is the crescent down the left — where
the cost pips ride.

## Files

- **`index.html`** — the implementation. Self-contained: open it directly in a browser
  (no build step, no runtime). The layer/pip galleries are generated from a small data
  table, and the top bar reimplements the design doc's Preview controls (Guides on/off,
  Stat badge on/off, Ink/Colour pip tone).
- **`Card Frame System.dc.html`** + **`support.js`** — the original Claude Design canvas
  doc and its runtime, kept verbatim for provenance. Renders via the DC runtime (pulls
  React from unpkg; needs a network connection).
- **`svg/v3/lens/`** — the card-frame layer set. Each SVG is cropped to its own artwork;
  place it at the origin in `spec.json` on the 825×1125 canvas and the stack lines up.
- **`svg/08-pips/{ink,color}/`** — the cost pips (200×200), placed at 76px on the card.
  Colour cuts are provisional, awaiting the Mastra palette.
- **`svg/v3/lens/spec.json`** — machine-readable layer origins/sizes, pip centres,
  set-symbol position and the shared plate envelope.

## Canvas & layer geometry

825×1125 px @ 300dpi (2.5×3.5in card, 37.5px bleed, 750×1050 trim, 40px corner radius).

| Layer | Size | Origin (x,y) |
|---|---|---|
| `card-base.svg` | 825×1125 | 0, 0 |
| `frame.svg` | 731×1031 | 47, 47 |
| `aperture-mask.svg` | 703×1003 | 61, 61 (clip) |
| `art-placeholder.svg` | 703×1003 | 61, 61 |
| `title-plate.svg` | 712×174 | 56, 42 |
| `type-bar.svg` | 712×146 | 56, 684 |
| `textbox.svg` | 712×302 | 56, 760 |
| `stat-badge.svg` | 240×136 | 528, 930 |
| `guides.svg` | 825×1125 | 0, 0 (non-printing) |

All four plates share one outer envelope (left 76 / right 748); the parchment plate rule
sits at 63.5 / 761.5. Multi-rules are stroke sandwiches on a single path, so they stay
exactly concentric everywhere.

## Card production pipeline (Squib)

Cards are rendered from the Lens frame system with [Squib](https://squib.rocks), a
Ruby card-prototyping DSL that composites via cairo/pango/rsvg.

### Setup (once)

Needs Ruby (3.3+) and the cairo/pango/rsvg/gdk-pixbuf dev libs plus
`libgirepository1.0-dev`. Then, from the repo root:

```bash
bundle install
```

Gems install into `vendor/bundle` (git-ignored). The four display fonts — Cinzel,
Cormorant Garamond, Bebas Neue, JetBrains Mono — must be installed for Pango
(e.g. under `~/.local/share/fonts`, then `fc-cache -f`).

### Build

```bash
bundle exec ruby cards/deck.rb            # render every card
GUIDES=1 bundle exec ruby cards/deck.rb   # overlay bleed/trim/zone guides
TONE=ink bundle exec ruby cards/deck.rb   # ink pips instead of colour
```

Outputs land in `output/` (git-ignored): one `card_NN.png` per card (825×1125)
plus `mastra_cards.pdf`, a print sheet laid out at 2.5×3.5in trim.

### Content — `cards/cards.yml`

One YAML entry per card. Fields:

| field | notes |
|---|---|
| `name` | title (top plate) |
| `type` | type line, e.g. `Agent — Dolor` |
| `cost` | list of up to 5 pips top→bottom: `capital` / `attention` / `technology` / `blank` |
| `rules` | rules text (multi-line OK) |
| `flavor` | italic flavor line (optional) |
| `stat` | stat-badge text, e.g. `"3 / 4"` — omit to hide the badge |
| `art` | filename under `art/`, clipped to the lens aperture — omit for the placeholder |
| `artist` | credit line (optional) |

### How it maps to the frame

`deck.rb` stacks the `svg/v3/lens/` layers at their `spec.json` origins, then places
text and pips at the design coordinates. Font sizes are the design's CSS px converted
to points (`px × 72 / 300`). Real art support is wired (`art/<file>` masked by
`aperture-mask.svg`) and activates as soon as a card names an `art:` file.

## Open

- The four type frames — Agent, Reaction, Infrastructure, Resource — as variations on this
  skeleton.
- Colour: needs the Mastra palette and the two remaining resource names.
- Earlier explorations live in the design project under `svg/v2/`.
