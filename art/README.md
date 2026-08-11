# Card art

Drop card artwork here. Images are **git-ignored for now** (this README is the only
tracked file in the folder).

## How it's wired

A card in [`../cards/cards.yml`](../cards/cards.yml) references art by filename:

```yaml
- name: Agent
  art: agent.png      # → art/agent.png
```

`deck.rb` places the image in the lens window at **x 61, y 61, 703×1003 px** on the
825×1125 canvas and clips it with `svg/v3/lens/aperture-mask.svg` (the tilted-lens
alpha). A card with no `art:` falls back to `art-placeholder.svg`.

## Conventions

- **Format:** PNG (the current pipeline loads art with Squib's `png`). Ask if you need
  JPG/SVG support wired in.
- **Size / aspect:** the window is **703×1003** (~0.70 : 1). Supply art at that size or
  larger with the same aspect; it's scaled to fit and masked to the lens.
- **Safe area:** the title plate covers the top band and the type-bar/textbox cover the
  bottom band of the lens — keep the subject centered. The lens bleeds off the two
  right-hand corners, so let backgrounds run to the edge and keep key detail off the
  extreme corners.
- **Filenames:** lowercase, hyphenated, matching the `art:` value (e.g. `agent-swarm.png`).
