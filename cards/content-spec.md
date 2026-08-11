# Mastra Trading Cards — Content Spec

Working spec for the card set. Source of truth for *what cards exist*; mechanics
(cost, rules text, stats) and the card-type taxonomy are designed separately and
filled into [`cards.yml`](cards.yml) per card.

Status: **first pass — enumerated concepts only.** The roster below is in `cards.yml`
as name-only stubs. The next step (with the owner) is to walk the Mastra docs
hierarchy and expand toward the full set.

## Theme

Cards based on **Mastra** content — the concepts, technologies, models, and culture
around building AI agents. Mix of straight concept cards (agents, workflows, RAG) and
"fun"/zeitgeist cards.

## Open decisions (pending)

- **Target size:** propose a total of **40–50 cards**, and pick the **10** for the
  initial starter deck. *(Deferred to the docs-hierarchy review step.)*
- **Docs hierarchy:** review <https://mastra.ai/docs> to surface additional concept
  cards (agents, workflows, and whatever else the hierarchy suggests).
- **Card-type taxonomy:** no in-game type system defined yet. The category headings
  below are the *source grouping*, not final card types. Until decided, `type` is left
  blank on the stubs.
- **Mechanics:** cost / rules / flavor / stat undefined for every card so far.
- **Integrations:** owner will secure a sponsor; at least one **integration vendor**
  card is planned (placeholder `Integration Partner` for now). Integrations may become
  its own category to expand.
- **Codex vs Claude Code:** likely **Claude Code only** for the initial deck; Codex is a
  later candidate.

## Enumerated cards (first pass)

Grouped by the owner's source categories. Each is a stub in `cards.yml`.

### Technologies
- Agent
- Subagent
- Agent Swarm
- Agentic Workflow
- RAG Pipeline
- Browser
- Sandbox
- Claude Code  *(Codex deferred)*
- Integration Partner  *(sponsor TBD)*

### Models
Two tiers given (grouping to be confirmed):
- Frontier line: **Opus**, **Fable**, **GPT-5.6**
- Challenger / open-weight line: **Qwen**, **Kimi**, **Deepseek**

### Use Cases
- GTM Agent
- Customer-Facing Agent
- AI SRE
- Document Processing

### Other / Zeitgeist
- AI Psychosis
- Conscientious Objector  *(anti–water-use stance)*
- AI-Pilled CEO
- Blackwell  *(NVIDIA silicon)*

### Fun / Wildcards
- Prompt Injection
- FelonyBench
- AI Girlfriend  — visual ref: the film *Her*
- Got Into YC / YC Acceptance — visual ref: the phone-screen shot at the end of
  <https://x.com/pk_iv/status/1851270308701106383>
- The Agent Book — *Principles of Building AI Agents*
- Slop Detector

**Count so far: 29** stubs (of the 40–50 target).

## Candidate additions (not yet in the roster)

See [`card-candidates.md`](card-candidates.md) — the maximalist pool of **100
concept candidates** (docs-derived + zeitgeist), grouped for the heavy prune.
Survivors of the prune get mechanics in the design pass and move into `cards.yml`.

Still parked separately:
- Codex (if the deck expands beyond the initial 10).
- Additional integration-vendor cards once sponsors are known.
