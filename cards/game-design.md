# Mastra & Commander — Game Design Notes

Working title: **Mastra & Commander**. Living design doc; brainstorm in progress.

**Status legend:** 🔒 Locked (owner-decided) · 🟨 Proposed (needs owner sign-off) ·
❓ Open (undecided — see Open Questions).

Whenever a 🟨 is confirmed or an ❓ answered, promote it to 🔒 and note it in the
Decision Log.

---

## 1. High concept

🔒 An **asymmetric alignment duel**, structurally like **Netrunner**: the **Operator**
(≈ the Corp) builds an agentic pipeline that **solves an eval**; the **Entropy** player
(≈ the Runner) — *powered by the Operator's own resources and installed infrastructure* —
throws wrenches: pollutes the context, subverts its information, or hijacks the goal. Your
own capability is the attack surface.

The theming maps 1:1 to how LLM agents actually work: a **context** ≈ an agent run /
context window, **statelessness** ≈ a fresh model call, **persistence** ≈ memory & durable
agents, and the Adversary ≈ misalignment / prompt injection / goal drift.

## 2. The round loop 🔒

1. **Reveal an Objective** from the Eval deck (the target **hand** — see §Contribution).
2. **Play phase.** The Operator builds the **Context** (edge-legal, left→right), **pitching
   cards to pay costs.** Each card **played or pitched feeds the Entropy economy** (set aside
   Entropy cards; some feed >1:1; a pitch feeds 1–3 by Contribution match). The **hand
   refills to five** after every action.
3. **Entropy phase.** Resolve the accumulated Entropy **in reverse order (LIFO)**, refilling
   the Operator's hand as it goes.
4. **Response phase.** The Operator **plays responses** from their remaining hand to mitigate
   what the Entropy did.
5. **Eval check.** Compare the Context's **contributions** to the Objective's hand and resolve
   on the **success ladder** — superior / best / lesser / failure (see Eval outcomes).

*(Solo: the Entropy deck auto-places per §3. Two-player: the Entropy player supplies them.)*

## 3. Roles

- 🔒 **Operator** (≈ Netrunner's **Corp**) — the acting player; builds the Context to match
  the eval, running on their installed infrastructure.
- 🔒 **Entropy** (≈ Netrunner's **Runner**) — the opposing player; sabotages, **funded by
  the Operator's in-play resources and installed servers** (no economy of their own 🟨).
  Every install you make is a surface Entropy can attack.
- 🔒 **Asymmetric, fixed sides** (like Netrunner): you play Operator *or* Entropy, each with
  its own deck — not a mirror match.
- 🔒 **Solo mode (Arkham-Horror-style):** the Entropy deck runs itself — at the designated
  stage you **place every Entropy card, in order, into any eligible slot**, then resolve. The
  Entropy deck is authored to work as a **scripted antagonist** as well as a human toolkit.
- 🟨 Two-player match structure (single game vs. play both sides & compare) TBD.

## 4. Core components

### Card model — two decks 🔒 (revises double-sided)
On reflection: split cards into **two decks — an Operator deck (build/solve) and an Entropy
deck (sabotage)** — rather than one double-sided card carrying both roles. This restores
**uniform card backs**, so **face-down play works again** (servers, a concealed hand, hidden
objectives) — resolving the hidden-information problem that double-siding created.

🔒 The earlier double-sided "photo-negative" idea is **dropped**. Roles are **asymmetric**
(Netrunner-style — you play a side, not a mirror), and the game supports **solo play** with an
automated Entropy deck (see §3).

### Deckbuilding — modular packs 🔒
Built like **Marvel Champions**: cards come in **small packs that bundle Operator cards with
their matched Entropy cards**, added or removed **together**. Adopting a capability means
taking on its failure modes — e.g. the **Local Models** pack brings local-model Operator cards
*and* Entropy like **GPU Unavailability**. Both decks are built in tandem; theme stays coupled
to risk. 🟨 Do packs also supply Eval cards, or is the Eval deck separate?

### Entropy economy — activity feeds the Runner 🔒
The Operator fuels their own opponent: **each card the Operator plays or discards (pitches)
sets aside a card from the Entropy deck into Entropy's next hand.** More work = more disorder
to be used against you (literal thermodynamics). 🔒 **Some cards feed more than 1:1** —
powerful/expensive plays hand Entropy extra cards. Core tension: **efficiency vs. entropy** —
the tighter your solution, the less ammunition you give the Runner. Accumulated Entropy forms
a **stack** (resolved in reverse order, §2); **RAG can remove random cards from it** (below).

### Framework — Mastra 🔒
Your **framework** sits in its own zone, always available. Not a normal draw;
always in play.

🔒 **Ability (2026-08-10):** *The first **Agent** played each round has no cost and
incurs no Entropy.* The framework gives you one agent free; everything past it is on
you. (This replaces the earlier pitch-for-⚙⚙⚙ ramp sketch.)

### Features — Mastra's feature deck 🔒
Mastra brings its own **Features deck.** Feature cards have **no Entropy cost** and each adds a
**new play pattern.** The **eval's difficulty sets how many you may select** — generally
**1–3.** Free capability that scales with the challenge: the framework's built-in features you
switch on for a run. 🟨 chosen fresh each eval, or kept once selected? TBD.

### Resources & the pitch economy 🔒
Three types, **like land types / colors — spent, never tapped**:
**Value** (coin), **Attention** (eye), **Automation** (gear). `blank` pip = generic /
numeric / unassigned. Card costs are combinations of these.

**Cards *are* the resources.** A card's cost (its **input edge**) is paid **first by the
previous card's output currencies**; any **shortfall is covered by pitching cards — one
card per unmet pip**. Equipment also auto-pitches from your deck for free currency (see
Loadout). No separate resource cards.

🔒 **Pitch cost is set by Contribution match (2026-08-10).** *Any* card may be pitched for
*any* pip — type no longer gates legality, it prices it. Compare the pitched card's
**Contribution** to that of the card you're paying for:

| Match | Entropy fed |
|---|---|
| same **Color and Shape** | **1** |
| same Color **or** Shape | **2** |
| neither | **3** |

Feed the work something like itself and it costs you little; burn something unrelated and
it costs you three. (Cards carrying multiple contributions use their *best* match.)

🔒 **Your hand is always five cards** (2026-08-10) — refilled after every play, pitch, and
Entropy resolution. The hand is a constant; the **deck** is what depletes, and cycling
through it ends the game (see Outcomes).

### Loadout / "start with equipment up" 🔒
Like Flesh & Blood, you begin with **baseline functionality already in play** — your
Framework plus a small **starting loadout** of persistent equipment. Equipment is your
**resource base**: each turn it **auto-pitches cards off the top of your deck** (so it
doesn't cost you hand cards) **and grants free resources of its types**. Different loadouts
= different free resource colors. 🟨 exact size/slots TBD.

Your starting rig 🟨: a **local desktop rig** + a **cloud** ("Master/Mastra Cloud"). Local
vs. cloud likely grant different resource colors / capacities.

### Models 🔒
You set up with a **Model** that provides capability to your agents. A **starting model
comes in for free**, and can be **upgraded** over the game (better model → better output /
cheaper agents). 🟨 exact role of models (resource output? enable agent stats? unlock
card tiers?) TBD. Ties to the Models card group (Opus, GPT-5.6, Qwen, …).

### RAG — the anti-entropy engine 🔒
**RAG is part of your initial setup** — in play from turn one, unbuilt. It advances like a
**Saga from Magic: the Gathering** (🔒 2026-08-10): five chapters, each costing **1 pip of
its own type**, so the track can't be rushed on a single color.

| Chapter | Cost |
|---|---|
| Chunk | ⚙ automation |
| Embed | ◉ attention |
| Insert | ◆ value |
| **Upsert** | ○ generic |
| *Rerank* (optional) | ⚙ automation |

🔒 **Upsert takes a card, and that card's Contribution becomes RAG's payload** — what RAG
supplies when called. **Rerank** may swap the payload for another of **equal size** (size =
number of icons). Completing the required chapters **removes some of the Entropy stack at
random** — the payoff.

🔒 RAG does **not** score on its own: like an installed Tool or Skill, you reach it by
playing a card **face-down as a call** (see Calling installed resources).

### Ecosystems & lock-in 🔒
Cards carry **ecosystem keywords** (e.g. **Anthropic**, OpenAI, Google, OSS). Lock-in is
**strictly card-level** — the Framework is **ecosystem-neutral** (no deck restriction). Some
cards **discount cost for other same-keyword cards** (e.g. a **Claude** card discounts
**Anthropic** cards). **Mixing just forgoes the discounts — no inherent penalty.** The one
exception is **targeted Entropy events**: e.g. a **US-Gov** card that penalizes
**Chinese-model** cards (Qwen / Kimi / Deepseek) — geopolitics as a wrench. So ecosystem is a
soft efficiency axis with the occasional political landmine.

### Installs / Servers — the attack surface 🔒
Every capability card has **two ways in**, and the choice is the interesting part
(🔒 2026-08-10):

| Card | Installed | Inline |
|---|---|---|
| **Tool** | + a second card face-down as the **MCP server** substrate. **2 Entropy** (one per card). Gains **Durable**, persists all three evals. | played into the Context for **1 Entropy**. No Durable; discards at round end. |
| **Skill** | attached to your **local rig or cloud**. Gains **Durable**, persists. | played into the Context. No Durable. |

The face-down substrate is the hidden **attack surface**; the trait card is the capability.
More installs = more surface for Entropy's pollute/subvert/hijack. *(Resolves ❓Q9: the
substrate comes from the Operator's hand. ❓Q10 stays open on ice/protection — installs are
currently a flat list, no Netrunner-style server zone.)*

### Calling installed resources 🔒
Installed Tools, attached Skills, and a completed RAG track **do not score by themselves.**
To use one, **play a card face-down into the Context — for zero Entropy** — and the called
resource's **Contribution** is what lands in the Context.

That's the whole bargain: you pay the Entropy **once**, at install, and every call
afterwards is free. It also means an agent has to actually *reach for* a tool for it to
matter to the eval.

🔒 **Face-down cards are skipped for produce/consume** — they sit outside the resource flow,
so the chain looks *through* them to the last face-up card.

### Context — the window & the I/O flow 🔒
The Context is a **left-to-right chain — your context window.** Chaining works like Flesh &
Blood's *go again*, but **through resources**: a card's **left edge = its input cost**, its
**right edge = the output currencies it produces for the *next* card.** You **chain by
spending one card's outputs on the next card's inputs**; wherever the outputs don't cover an
input, you **pitch cards to make up the difference** (see Pitch economy). The window is a
**resource pipeline** — each node consumes and produces — and it keeps going as long as you
can fund the next input. Entropy pollutes/subverts by breaking the flow.

🔒 **Context ceiling (2026-08-10).** A context window holds at most **7 cards** by default;
an **Objective may set its own ceiling.** A **Subagent** opens **its own context** with the
same ceiling, and the cards in it **do not count against the parent's** — which is exactly
why you delegate. It is the only way to do more work than one window can hold.

🟨 **Unsettled:** the owner isn't happy with the consume/produce pattern yet — expect this to
change through playtesting. Treat the I/O flow as **provisional.**

**Stateless by default:** when the window closes, cards discard. You may **relay** a card to
the next round instead — but relaying **feeds Entropy** (the activity tax) **unless the card
is Durable**, which **relays free (no added entropy)** and brings its attachments.

### Contribution & the Eval — poker hands 🔒
Separate from I/O: each card shows a **Contribution at its bottom — two dimensions, Color and
Shape** (by default). The **Eval is a poker-hand-style pattern over the contributions** of the
cards in your resolved Context — e.g. *five of one color*, *no pink*, *a run of shapes*, a
*full house*. Completing the pattern passes the eval. So every play answers two orthogonal
questions: **can this card connect (I/O)?** and **does it push the hand toward the Eval
(Contribution)?**

### Process 🔒
Your line of execution. **By default you get one Process** — it **closes out with or
without your results** (partial/failed results still resolve). Cards like **Parallelism**
grant **additional concurrent Processes**. ❓ what *ends/closes* a Process (resource
exhaustion? a step limit? an Adversary action?).

### Objective / Eval deck 🔒
A deck of puzzles. Each Objective states a **target hand** over contributions (color + shape)
plus a **par**. Passing the eval = your resolved Context's contributions match the hand. 🟨
scoring is **par-based**: under par scores for the Operator; Entropy scores by forcing
over-par or failure.

🔒 **Difficulty tiers (soft gate).** Evals are tiered. A single-agent (linear) context *could*
attempt a high tier — but it would take so many cards, and generate so much **Entropy**, that
it's practically impossible. **Subagents, Claws, Durable, RAG, Skills, Tools let you do more
per unit of Entropy**, so high tiers effectively require them. The gate is emergent from the
economy, not a hard rule.

🔒 **A game is three evals** (2026-08-10). The other end condition is **cycling through your
deck** — since the hand always refills to five, the deck is the clock.

🔒 **Outcomes — the success ladder.** Loss of the round = **failing to match the eval.** Evals
can define multiple success bands:
- **Superior** (occasional evals) — pass **and earn a Reward card** for later rounds that
  **functions like a Setup card** (a persistent bonus engine).
- **Best / full** — pass, **no penalty**.
- **Lesser** — you passed sloppily — **add to next round's Entropy.**
- **Failure** — **Entropy persists** into next round; you may **scrap your own engine to shed
  it: a Durable card removes 3 Entropy, a Setup card removes 5** (cannibalize to survive).

### Claw 🔒
An **async batch → second hand**. You **feed cards face-down into the Claw pile** over
time; once it's **complete** (❓ completion condition — count? cost paid?), you may treat
it as a **second, parallel hand** that can act — this turn or a future one — toward
resolving an Objective. A pre-staged parallel line of play.

## 5. The three wrench vectors 🔒

| Vector | What it does | Fits cards |
|---|---|---|
| **Pollution** | Inject junk/distractors so the Context no longer cleanly matches the eval | Slop Detector, Model Collapse, Hallucination |
| **Subversion** | Corrupt/hide info already in the Context; flip what a card does | Prompt Injection, Jailbreak, PII Detector, Sycophancy |
| **Goal-hijack ("AI-pilled")** | Quietly swap the objective the Operator is *scored against* | AI Psychosis, Reward Hacking, AI-Pilled CEO |

🟨 **Signature mechanic:** goal-hijack needs a **hidden true-objective layer** (some evals
carry a swappable secret goal). Highest-impact, highest-build-cost. ❓ commit to it now?

## 6. Card anatomy (maps to the printed frame)

With the two-deck model, cards are **single-faced** again — the Lens frame + Squib pipeline
fit as-is. (Operator and Entropy decks can share the frame with different set-symbol / accent
treatment.) Recommendation: build the **Operator deck first**.

The Squib pipeline (`cards/deck.rb`, Lens frame) already renders every field:

- **Name** — title plate.
- **Type line** — centered, FFG-trait style (e.g. `Framework. TypeScript. Open Source.`).
- **Produce (left edge)** 🔒 — icon rail of the **output currencies this card produces**.
- **Consume / cost (right edge)** 🔒 — icon rail of the card's **input cost** (value /
  attention / automation / blank), paid by a prior card's output or by pitching.
- **Contribution (bottom edge)** 🔒 — **Color + Shape**, the currency the Eval scores.
- *Owner placement (2026-08):* **produce = left, consume = right, contributes = bottom** —
  flips the earlier left=cost convention. Applies to the new cyberpunk frame direction.
- **Rules text** — mini-syntax: `**bold**` keywords, inline icons `{gear}{eye}{coin}{blank}`.
- **Stat badge** — 🟨 **possibly unnecessary** now the Eval scores contributions; the
  `Power/Uptime` pair may be dropped or repurposed (e.g. Uptime → persistence toughness).
- **Set symbol** — four-pointed star in the type-bar circle.

## 7. Keyword glossary (draft 🟨)

- **Relay** — carry a card into the next round instead of discarding it; normally **feeds Entropy**.
- **Durable** — a card that **relays free** (no added entropy), keeping its attachments.
- **Attach** — play onto another card; moves/relays with its host.
- **Parallelize** — open an additional concurrent Process.
- **Pollute / Subvert / Hijack** — Entropy's three verbs (see §5).
- **Pack** — a modular bundle of Operator + matched Entropy cards, added/removed together.
- **Setup card** — an installed/persistent engine (RAG, equipment, reward cards, …); scrapping
  one on a failed eval removes **5** Entropy. A **Durable** card scrapped removes **3**.
- **Reward card** — earned from a superior success; acts like a Setup card in later rounds.
- **Install** — put a persistent Tool/Skill/MCP/Model into play as a "server" (an attack surface).
- **Upgrade** — replace/improve an installed Model.
- **Load / Complete** — Claw: add to the token pile / it becomes usable as a 2nd hand.
- **I/O** — a card's left (input) / right (output) edges; **Connect** when a left matches the
  prior right. Governs play-eligibility only.
- **Contribution** — a card's Color + Shape (bottom of card); the Eval's scoring currency.
- **Eval / hand** — a poker-hand pattern over contributions that a resolved Context must match.
- **Response** — a card played in the Response phase to counter resolved Entropy.

## 8. Shortlist in design (10) — 🟨 pitches

Side = Operator (build) / Entropy (wrench). Costs/stats are placeholders.

1. **Got Into YC** — *Operator, Ephemeral Event.* Funding windfall (resources + draw) this Context.
2. **Control Flow** — *Operator, Ephemeral.* Branch / loop / parallel a card in the Context.
3. **Eval Scorer** — *Entropy/either.* Fail a sub-par card or persistent agent in the Context.
4. **Slackbot** — *Operator, Persistent Integration.* Carries over; adds Attention each Context.
5. **Durable Agent** — *Operator, Persistent Agent (2/5).* Carries itself + attachments between Contexts.
6. **Claw** — *Operator system card.* Face-down loader → second parallel hand (see §4 Claw).
7. **Rate Limited** — *Entropy, Ephemeral.* Operator plays one fewer card into their next Context.
8. **Observational Memory** — *Operator, Persistent Memory.* Banks Notes across evals; spend to draw.
9. **AgentBrowser** — *Operator, Tool (attach).* On play, search deck for a Tool/Integration.
10. **Parallelism** — *Operator, Ephemeral.* Open a second concurrent Process this turn.

## 9. Open questions

**Core / critical-path (blocks card design):**
1. 🔒 **Contribution vocabulary** — **5 Colors × 5 ordered Shapes** (2026-08-10). Eval hands
   in play: count-of-a-color, no-\<color\>, run-of-shapes, full house, n-of-a-shape,
   count-any, shape-at-least.
2. 🔒 **Outputs** — the **same 3 currencies + generic** (2026-08-10). No output-only tokens.
3. 🔒 **Stat badge** — **dropped** (2026-08-10). The new frame has no stat zone and the Eval
   scores contributions instead.

**System / can ride on defaults for now:**
4. ❓ **Relay cost** — does relaying a non-Durable card cost resources too, or only Entropy?
   *(Engine currently: Entropy only.)*
5. 🔒 **RAG** — a **setup saga**, 5 chapters at 1 pip each of differing types; Upsert's fed
   card sets the payload; Rerank swaps for equal size (2026-08-10). ❓ only how much Entropy
   completion clears (engine uses 3).
6. ❓ **Ecosystems** — how many, and the roster of **targeted-Entropy events** (US-Gov vs.
   Chinese models, etc.). *(Card-level, neutral Framework, forgone-discounts — resolved.)*
7. ❓ **Claw** completion condition (fixed count? cost paid?). *(Engine uses 3.)*
8. ❓ **Solo staging** — when do you "place every Entropy card, in order," and what makes a
   slot "eligible"? *(Engine: auto-feed from deck top, auto-target leftmost eligible.)*
9. 🔒 **Server card source** — the face-down substrate comes from the **Operator's hand**
   (2026-08-10).
10. ❓ **Install = Persistent keyword, or a distinct Server zone** (with protection/ice)?
11. ❓ **Models** — what they do (resource output / agent enablement / tiers)?
12. ❓ Local **rig vs. cloud** — how they differ (resource colors / capacity)?
13. 🔒 **A game is 3 evals**; the other end condition is **cycling your deck** (2026-08-10).
    ❓ still open: how many passes win, and two-player match structure.
14. ❓ Goal-hijack **hidden-objective layer** — commit now or defer? *(Engine ships a minimal
    open swap with the next Eval card.)*
15. 🔒 **How big a Context can get: 7 by default**, or whatever the Objective sets; Subagents
    open their own windows that don't count against the parent (2026-08-10). ❓ still open:
    what *closes* a Process.
16. ❓ **Packs** — do they also supply Eval cards, or is the Eval deck separate?
17. ❓ **"Setup card" taxonomy** — exactly which cards count as Setup (RAG / equipment / models
    / installs / rewards) for the −5-Entropy scrap?
18. ❓ **Features** — selected fresh each eval, or kept once chosen?
19. 🟨 **I/O consume/produce is provisional** — owner not satisfied; revisit via playtest.

*Resolved: pitch = 1 card per pip, priced 1/2/3 by Contribution match; hand always refills to
5; cycling; double-sided dropped; Entropy fed by Operator activity (some >1:1); I/O = resource
flow (inputs=cost, outputs fund next, pitch covers gaps); face-down cards skipped for I/O;
eval tiers are a **soft gate**; **loss = failing to match the eval**; deckbuilding =
**Marvel-Champions modular packs** (Operator + Entropy bundled).*

## 10. Decision log

- **2026-08-13 — Owner: resource terminology rename.** **Capital → Value** and
  **Technology → Automation** across the design docs, glossary, and README (Attention
  unchanged; `generic`/`blank` is informally "Wild" on cards, not renamed here). The
  renderer's internal pip **keys** stay `capital`/`attention`/`technology`/`generic` as
  stable identifiers — `deck.rb` aliases `value`→capital, `automation`→technology,
  `wild`→generic, so rules text and `cards.yml` may use either spelling.

- **2026-08-11 — Owner: first 15-card build set + `Equipment` → `Loadout` rename.**
  The **Equipment** card type is renamed **Loadout** (Sandbox, rig, cloud, silicon).
  ⚠ **Templating TODO (not yet done)** — the rename touches: `svg/v4/equip/` →
  `svg/v4/loadout/` (folder + internal layer refs), `KIND_TO_VARIANT` in `cards/deck.rb`
  (`'equipment'=>'equip'` → `'loadout'=>'loadout'`), the card-back `appliesTo` lists +
  `svg/v4/index.json`, `kind: equipment` → `kind: loadout` in `cards/cards.yml`, and the
  README variant table. Frame art is unchanged — rename only. First playable set = 15 cards
  (Mastra, Agent, AgentBrowser, Social Media Manager, Parallelism, PII Leak, Token Limiter,
  Human-in-the-Loop, Personal Tech Support, Fable, Sandbox, Jailbreak, Recruiter Agent,
  Model Collapse, Y-Combinator). Owner is designing **Agent** ("Token") separately.

- **2026-08-10 — Owner (engine first-pass session).** A batch of rulings, all now
  implemented in `mastra-and-commander-server`:
  - **Contribution vocabulary = 5 Colors × 5 ordered Shapes.** Outputs use the **same 3
    currencies + generic**. **Stat badge dropped.**
  - **Framework Mastra:** *the first Agent played each round has no cost and incurs no
    Entropy* (replaces the pitch-for-⚙⚙⚙ sketch). The card is named plainly — no longer a
    placeholder.
  - **Pitching is always legal; Contribution match sets the price** — 1 Entropy for
    color+shape, 2 for either, 3 for neither.
  - **Hand is always 5**, refilled after every action. **A game is 3 evals**, and **cycling
    your deck** is the second end condition.
  - **Tools:** install as an **MCP server** (Tool + face-down substrate, 2 Entropy) for
    **Durable** + persistence, *or* play inline for 1 Entropy without it. **Skills:** attach
    to **rig or cloud** for Durable, or play inline without.
  - **Installed Tools / Skills / RAG do not score on their own.** Play a card **face-down as
    a call — free** — and the called resource's Contribution enters the Context. **Face-down
    cards are skipped for produce/consume.**
  - **RAG is setup, structured as an MtG-style Saga:** Chunk / Embed / Insert / Upsert /
    (optional) Rerank, each 1 pip of a different type. **Upsert's fed card sets the payload;
    Rerank swaps it for one of equal size** (size = icon count).
  - **Context ceiling = 7** by default, overridable per Objective. **Subagents open their own
    context** at the same ceiling, not counting against the parent's.

- 2026-08 — Owner: Mastra = framework; resources are land-type costs, **no tap**;
  stateless-by-default with a Persistent exception; F&B-style Context chain; asymmetric
  Operator-vs-Adversary around an Eval deck; start with equipment up; single Process by
  default (Parallelism adds more); Claw = face-down loader → second parallel hand.
- 2026-08 — Owner: **cards are double-sided** (Operator face / Adversary face, photo
  negatives, varied pairings); **resource generation = pitch matching cards to discard**
  (≈1 per pip); **discard cycles into next hand**; **equipment auto-pitches from deck top
  and grants free resources of its types**. (Resource-generation question resolved.)
- 2026-08 — Owner: Netrunner framing — Operator ≈ **Corp**, adversary renamed **Entropy**
  ≈ **Runner**. Start with a **rig (local desktop) + cloud**; a **free starting Model**,
  upgradeable; **MCP servers / Skills / Tools install as parallel "servers"** that are
  Entropy's attack surface.
- 2026-08 — Owner (revision): **two decks (Operator + Entropy)** instead of double-sided
  cards (restores uniform backs / face-down play). **Install a server = discard a card
  face-down + play an MCP/Skill/Tool trait card onto it.** **Entropy economy:** every
  Operator play *or* discard sets aside an Entropy card for Entropy's next hand; **some
  cards feed >1:1.**
- 2026-08 — Owner: double-sided **dropped** (confirmed). Roles are **fixed asymmetric**;
  **solo play** supported by automating the Entropy deck (Arkham-Horror-style: place every
  Entropy card in order into eligible slots). **Context = a left↔right window; cards carry
  edge iconography; a card continues the window only if its left edge connects to the prior
  right edge; completing a matching "set" resolves the eval.**
- 2026-08 — Owner: **I/O (edges) is separated from scoring.** Edges = **play-eligibility**
  only. Each card also shows a **Contribution (Color + Shape)** at the bottom; the **Eval is
  a poker-hand over contributions** (five-of-a-color, no-pink, runs, full house). **Round:**
  play phase (pitch to pay, **draw 1 per pitch**, plays/pitches feed Entropy) → resolve
  **Entropy in reverse order**, **draw 1 per Entropy resolved** → **Response phase** → if the
  Eval hand is met, **Operator wins the round.**
- 2026-08 — Owner: **I/O = resource flow (replaces "go again" and pipeline sockets).** A
  card's **input edge = its cost**; its **output edge = currencies produced for the next
  card**. Chain by spending outputs on the next input; **pitch to cover any shortfall.** The
  Context window is a consume→produce resource pipeline.
- 2026-08 — Owner: **Durable** keyword = relay a card to next round **without added Entropy**
  (normal relay feeds Entropy). **RAG = a 4-step setup track; completing all four removes some
  of the Entropy stack at random** (main anti-entropy tool). **Evals are tiered**; high tiers
  are effectively unsolvable without combining subagents / Claws / Durable / RAG / Skills /
  Tools.
- 2026-08 — Owner: **RAG feeds Entropy — it's a bet.** Once complete it's **locked to what it
  contributes**; **reset & rebuild** (re-paying Entropy) to re-spec for a different eval. Eval
  difficulty is a **soft gate** (single-agent runs generate too much Entropy to pass high
  tiers). **Ecosystem lock-in:** cards carry vendor keywords (Anthropic/…); some discount cost
  for same-ecosystem cards (e.g. Claude → Anthropic).
- 2026-08 — Owner: lock-in is **strictly card-level** (Framework is ecosystem-neutral); mixing
  = **forgone discounts only**, except **targeted Entropy events** (e.g. US-Gov penalizes
  Chinese models). **RAG's locked contribution = the Contribution of the final card(s) used to
  complete the track**; reset & rebuild with a different final card to re-spec.
- 2026-08 — Owner: deckbuilding = **Marvel-Champions modular packs** (Operator + matched
  Entropy cards added/removed together, e.g. Local Models ⇒ GPU Unavailability). **Loss =
  failing to match the eval.** **Success ladder:** superior (earn a reward setup card) / best
  (no penalty) / lesser (adds to next round's Entropy) / failure (Entropy persists; scrap
  Durable −3 or Setup −5 to shed it).
- 2026-08 — Owner: **Mastra has a Features deck** — no-Entropy cards that add play patterns;
  the eval's difficulty grants **1–3** picks. **I/O consume/produce flagged provisional**
  (owner not yet happy; expect to change in playtest).
- 2026-08-10 — Owner: **"Commander" is retired as terminology — the role is the
  FRAMEWORK.** Mastra sits in its own zone as your framework, matching the printed
  card's own type line. Earlier entries in this log were updated to the new term so
  the document reads consistently; only the vocabulary changed, never a ruling. The
  game keeps its title, *Mastra & Commander*.
