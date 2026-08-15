# Mastra & Commander — build to-do

Running work log for the card build. Rules/design decisions live in
[`game-design.md`](game-design.md); this is the task list.

## Frame / pipeline
- [ ] **Token frame: add a flavor-text line.** The `svg/v4/token/` variant has no text area;
  add a thin flavor/quote line so token quotes print (Agent: *"An agent is an LLM calling
  tools in a loop."*). Design-side: `spec.json` textBox + a layer.
- [x] **Wire per-card `art:`** — done. `deck.rb` clips each art to the variant aperture
  (ImageMagick, cached in `output/art-clipped/`); token = near-full art.
- [x] **Wire `flavor:`** — done (italic, under the rules). ⚠ On the densest cards the short
  rules panel squeezes the flavor out (e.g. Human-in-the-Loop) — fixed by the frame redesign
  (bigger text area / dedicated flavor line), not a data change.
- [ ] **Deferred art:** Social Media Manager, Jailbreak (kept, no art yet).
- [ ] **Remove subheads (Sam).** Drop the subtitle/traits plate across variants — the
  category tab is enough. Design-side.
- [ ] **Confirm bigger art/text (Sam).** Art enlarged in framework 3.2.0; verify text sizing.

## Card content (Sam's feedback batch)
- [x] Rename **AgentBrowser → Browserbase** — done (cost attention+tech → value+attention,
  subhead Browser, art `browserbase.png`, flavor "…since links2").
- [x] Rename **Y-Combinator → YC** — done (kept Event + ramp; art `yc-acceptance.jpeg`;
  blurb "Getting rejected by YC…").
- [x] **Social Media Manager** — kept as-is (Skill); flavor + art deferred. (Not renamed.)
- [x] Rename **Parallelism → Parallel Subagents** — done (rules → two Agent tokens,
  Entropy 1; art `paralellism.jpeg`; flavor "Trading time for tokens").
- [ ] Design **Dario's AI Doom** (stubbed) — own card, mechanics TBD, wants a Dario
  AI-doom quote. NOT related to Theo Rant; not a rant archetype.
- [ ] Design **Theo Rant** (stubbed) — own card, mechanics TBD. Unrelated to Dario's.
- [x] **Jailbreak** — kept as-is; MechaHitler split into a new card **Algorithmic
  Intervention** (Subversion; "replace the eval with one differing by ≤2 elements";
  art `mechahitler.jpeg`; "A little more Mechahitler, please").
- [x] Token Limiter + PII Leak blurbs — done.
- [ ] Blurb still pending: **Sandbox** (*"…the solution to your agent running rm -rf /"*).

## Open decisions
- [x] ~~Browserbase cost~~ — set to `attention`+`technology` → `value`+`attention`.
- [x] ~~Token Limiter vector~~ — set to **Constraint**.
- [ ] **Terminology: "Agent-owned row" → "context"** (owner: a context *is* the unit).
  `game-design.md` currently says "Agent-owned row" throughout — reconcile to "context"
  (coordinate with the other session that authored the row vocabulary).
- [ ] **`generic` → "Wild"** rename in the docs (only Value/Automation done so far).
- [ ] **Subhead policy** — decide per card which keep a mechanical subhead
  (Tool/Skill/Response) vs. drop it (Sam: "category tab is enough"; Mastra: subhead =
  descriptors). Human-in-the-Loop **dropped** its `Response` subhead — revisit.
  Sandbox subhead **left blank** — revisit (Loadout descriptor?).

## Larger
- [ ] Expand past the first 15 cards (design the rest of the sorted roster).
- [ ] Resolve the remaining `❓` open questions in `game-design.md`.
