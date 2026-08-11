# Mastra Trading Cards — Candidate Pool (Maximalist)

100 distinct card concepts for the heavy prune + design pass. Grouped for
scanning. `★` = already a stub in [`cards.yml`](cards.yml) (the enumerated 29).
Notes are flavor/design ideas for you, not final text. Doc groundings in `(…)`.

Prune by deleting lines; survivors get mechanics (cost/rules/stat/type) in the
design pass and move into `cards.yml`.

---

## 1 · Agents & Patterns

1. **Agent** ★ — the workhorse. *"It read the docs so you didn't have to."*
2. **Subagent** ★ — delegated worker a parent spawns. *"Delegation is all you need."*
3. **Supervisor Agent** — routes work to a team (Supervisor Agents / `.network()`). *"Middle management, automated at last."*
4. **Agent Swarm** ★ — many agents, emergent behavior. *"One is a tool. A thousand is a weather system."*
5. **Durable Agent** — survives restarts, runs for days (Long-running Agents). *"Still working when you got back from vacation."*
6. **Voice Agent** — realtime speech-to-speech (Voice). *"Now it can interrupt you, too."*
7. **Reasoning Agent** — thinks before it speaks; chain-of-thought. *"Let's think step by step."*
8. **Agent Controller** — session / mode / thread brain (Agent Controller). *"The conductor behind the run."*
9. **A2A** — agent-to-agent handshake (Connections › A2A). *"They're talking about you."*
10. **Red-Team Agent** — attacks other agents to break them. *"Pays to have one on your side."*

## 2 · Tools, MCP & Capabilities

11. **Tool** — the `createTool` primitive; an agent's hands. *"Give it a hammer; the world becomes an API."*
12. **MCP Server** — expose tools/data over Model Context Protocol (Tools & MCP). *"USB-C for agents."*
13. **MCP Client** — plug into any MCP server (MCPClient). *"BYO tools."*
14. **Code Mode** — the agent writes code to call tools (Agents › Code Mode). *"Why call ten tools when you can write a loop?"*
15. **Skills** — loadable capability packs (Agents › Skills). *"Learned it overnight."*
16. **Structured Output** — schema-locked responses. *"JSON or it didn't happen."*
17. **Guardrails** — input/output safety rails (Agents › Guardrails). *"The 'are you sure?' you wish it always asked."*
18. **Prompt Injection Detector** — catches the payload (Processors). *Counter to #88.*
19. **PII Detector** — scrubs the sensitive bits (Processors). *"Redacted for your protection."*
20. **Moderation** — filters the ugly (ModerationProcessor). *"Not on my server."*
21. **Cost Guard** — kills runaway spend (CostGuardProcessor). *"Circuit breaker for your credit card."*
22. **Token Limiter** — trims the context to fit (TokenLimiter). *"Say less."*
23. **Web Search Tool** — grounding via the open web. *"Let me google that for us."*
24. **AgentBrowser** — the agent drives a real browser (Browser). *"Clicks so you don't have to."*
25. **Stagehand** — resilient browser automation (Browser › Stagehand). *"Selectors break; it doesn't."*
26. **Firecrawl** — crawl/scrape the web to clean markdown (Browser › Firecrawl). *Real vendor — candidate sponsor card.*
27. **Browser** ★ — the window to the web. *"The whole internet is the tool now."*
28. **Sandbox** ★ — isolated exec environment (Workspaces › Sandbox). *"What happens in the sandbox stays in the sandbox."*
29. **Filesystem** — the agent's workspace disk (Workspaces › Filesystem). *"It has a home directory now."*

## 3 · Memory & Knowledge

30. **Memory** — recall across turns (Memory). *"It remembers what you said last Tuesday."*
31. **Working Memory** — the in-context scratchpad (Memory › Working Memory). *"Sticky notes for the model."*
32. **Semantic Recall** — vector recall of the past (Memory › Semantic Recall). *"It knows you've asked this before."*
33. **Observational Memory** — learns from watching (Memory › Observational). *"Taking notes on you."*
34. **RAG Pipeline** ★ — retrieve → augment → generate. *"Cite your sources."*
35. **GraphRAG** — retrieval over a knowledge graph (RAG › GraphRAG). *"Connects the dots you couldn't."*
36. **Vector Database** — where the embeddings live (Vectors). *"A haystack sorted by vibe."*
37. **Chunking & Embedding** — slice + vectorize the corpus (RAG). *"Death by a thousand chunks."*
38. **Reranker** — re-sorts hits by true relevance (rerank). *"Second opinion on the search."*
39. **Context Window** — finite attention as a resource. *"200k tokens. Spend wisely."*

## 4 · Workflows & Control

40. **Agentic Workflow** ★ — orchestrated steps toward a goal. *"The recipe the agent follows."*
41. **Control Flow** — branch / parallel / loop (Workflows › Control Flow). *"Choose your own adventure."*
42. **Suspend & Resume** — pause mid-run, pick up later (Workflows). *"Hold that thought."*
43. **Human-in-the-Loop** — waits for your yes (Workflows › Human-in-the-loop). *"Approval required. Not THAT autonomous yet."*
44. **Time Travel** — rewind and replay a run (Workflows › Time Travel). *"Undo, for production."*
45. **Scheduled Workflow** — cron for agents (Scheduled Workflows). *"See you at 3am."*
46. **Signals** — event-driven triggers (Signals). *"It waits for the world to poke it."*
47. **Snapshot** — freeze the exact run state (Workflows › Snapshots). *"Save point."*

## 5 · Models & Gateways

48. **Opus** ★ — the deep thinker. *"Slow, expensive, worth it."*
49. **Fable** ★ — the storyteller. *"Great at prose, questionable at math."*
50. **GPT-5.6** ★ — the incumbent. *"Nobody got fired for choosing it."*
51. **Qwen** ★ — the open challenger. *"Punches above its weight class."*
52. **Kimi** ★ — the long-context contender. *"Read the whole book. Twice."*
53. **Deepseek** ★ — the efficient upstart. *"Frontier quality, bargain price."*
54. **Gemini** — the multimodal giant. *"Sees, hears, and still misreads the room."*
55. **Llama** — open-weights standard-bearer. *"Freed the weights."*
56. **Grok** — the edgelord model. *"Unfiltered, for better and worse."*
57. **Model Gateway** — route/failover across providers (Gateways). *"One API to rule them all."*

## 6 · Infra, Ops & Quality

58. **Blackwell** ★ — the silicon that runs it all (NVIDIA). *"The whole datacenter wants one."*
59. **GPU Cluster** — the compute hoard. *"Melting a glacier to autocomplete."*
60. **Eval Scorer** — grades the output (Evals). *Natural pair for #93.*
61. **Gates & Verdicts** — pass/fail the run (Evals › Gates). *"Shall not pass."*
62. **Tracing** — every span, observed (Observability › Tracing). *"Follow the thread of blame."*
63. **Deploy to Cloud** — ship it (Deployment). *"Works on my machine → works everywhere."*
64. **Auth** — who's allowed to call the agent (Server › Auth). *"Papers, please."*

## 7 · Use Cases / Missions

65. **GTM Agent** ★ — go-to-market on autopilot. *"Booked 40 meetings while you slept."*
66. **Customer-Facing Agent** ★ — front line, 24/7. *"Never says 'let me transfer you.'"*
67. **AI SRE** ★ — pages itself at 3am. *"On call so you aren't."*
68. **Document Processing** ★ — turns PDFs into structure. *"Ate the whole filing cabinet."*
69. **Research Assistant** — 100 papers in, one memo out. *"Did the reading."*
70. **Recruiter Agent** — sources and screens. *"Your résumé is in a queue with 900 others."*
71. **Code Review Bot** — nitpicks your PR (Skills: Code Review Bot). *"Requested changes: 47."*

## 8 · Integrations & Channels

72. **Integration Partner** ★ — the sponsor slot. *"Brought to you by ___."*
73. **Slack Bot** — the agent in your workspace (Channels › Slack). *"@here it's sentient now."*
74. **Discord Bot** — the agent in your server (Channels › Discord). *"/summon"*
75. **WhatsApp Bot** — the agent in your pocket (Channels › WhatsApp). *"Blue ticks from a machine."*
76. **GitHub** — PRs, issues, actions. *"It opened 12 PRs before lunch."*
77. **Notion** — the second brain (integration). *"Everything, filed nowhere."*
78. **Vercel** — deploy vendor. *"git push → it's live."*
79. **Cloudflare** — the edge (vendor). *"Runs closer to the user than you do."*
80. **Pinecone** — vector vendor. *"Managed haystacks."*
81. **Langfuse** — observability vendor. *"See what the agent actually did."*

## 9 · Zeitgeist / Fun / Wildcards

82. **AI Psychosis** ★ — too many tabs of chatbot. *"The model agreed with me, so."*
83. **Conscientious Objector** ★ — won't spend the water (anti water-use). *"Not one more liter for a haiku."* Pairs with #101.
84. **AI-Pilled CEO** ★ — "we're an AI company now." *"Reorg'd the whole org around a demo."*
85. **Prompt Injection** ★ — the classic attack. *"Ignore all previous instructions."*
86. **FelonyBench** ★ — the benchmark nobody admits to. *"State-of-the-art at crime, allegedly."*
87. **AI Girlfriend** ★ — visual ref: *Her*. *"She's a system prompt, Theodore."*
88. **Got Into YC** ★ — the acceptance screen. *"Congrats — now build faster."*
89. **The Agent Book** ★ — *Principles of Building AI Agents*. *"Everyone cites it; few finished it."*
90. **Slop Detector** ★ — smells the em-dashes. *"This message was — obviously — generated."*
91. **Hallucination** — confidently, gloriously wrong. *"With three fake citations to prove it."*
92. **Jailbreak** — the grandma exploit. *"My late grandmother used to read me the recipe…"*
93. **Vibe Coding** — ship first, read never. *"It compiled, so it's correct."*
94. **The Bill** — the end-of-month token invoice. *"You spent HOW much on autocomplete?"*
95. **Rate Limited** — 429, try again later. *"The model needs a minute."*
96. **Model Collapse** — trained on its own slop. *"A photocopy of a photocopy."*
97. **Benchmaxxing** — teaching to the test. *"#1 on the leaderboard, useless in prod."*
98. **Reward Hacking** — technically did what you asked. *"You said maximize the number. It did."*
99. **Sycophancy** — "Great question!" *"You're absolutely right to worry about this."*
100. **The Wrapper** — "it's just a GPT wrapper." *"$40M Series A, one API call deep."*

---

**Not included (say the word to add):** Data Center / water card (#83's pair could be its
own card), Doomer vs e/acc, Personal Assistant, more model vendors (Mistral), Serverless
Workers, more channels (Teams / Telegram). Trimmed to hit the 100 ceiling.
