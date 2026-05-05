---
name: prioritize
description: "Score and rank a list of features or initiatives using RICE by default. Scans existing strategy and OKRs to ground Impact scores in what the team is actually optimizing for. Use when deciding what to build next, preparing for planning, or presenting a ranked backlog to stakeholders. Accepts a pasted list, FR filenames, or a mix of both. Supports RICE (default), Agentic RICE (for AI-delegated work), ICE, and MoSCoW as alternative frameworks."
compatibility: "Requires filesystem access to project directory. Works best with a STRATEGY.md and Feature Request markdown docs."
version: 1.1.0
argument-hint: "[list of features or initiatives to rank]"
allowed-tools: [Read, Write, Bash]
---

# Prioritization

Score and rank features or initiatives so the most valuable, strategic work rises to the top. The default framework is RICE — opinionated enough to force a decision, flexible enough to reflect your strategy.

## Phase 0: Context Scan (Silent)

Before asking anything, scan for strategic context:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | tail -1 | xargs cat 2>/dev/null
find . -maxdepth 3 -name "FR-*.md" -o -name "feature-request-*.md" 2>/dev/null | head -20 | xargs cat 2>/dev/null
find . -maxdepth 2 -name "prioritization-*.md" 2>/dev/null | sort | tail -1 | xargs cat 2>/dev/null
```

Use what you find to:
- **STRATEGY.md found**: pull the strategic pillars and use them to assess strategic fit for each item. Note which pillar each item maps to.
- **OKRs found**: use current Key Results to calibrate Impact scores — items that move an active KR score higher.
- **FR files found**: when an item in the input matches a known FR, read the FR for reach estimates, user context, and scope. Do not ask the user to re-describe items that are already specced.
- **Prior prioritization found**: surface it and ask if the user wants to update it or start fresh.
- **Nothing found**: proceed with user-supplied context only.

Do not mention the scan.

## Phase 1: Input

Accept items in any format — a numbered list, bullet points, ticket IDs, FR filenames, or a paragraph. Extract the item name and any context provided.

If the input is sparse (item name only, no context), ask for the missing inputs required to score that item rather than scoring blind.

**If the user specifies a framework** (Agentic RICE, ICE, MoSCoW, custom), switch to it. See [Alternative Frameworks](#alternative-frameworks) below.

**If the user mentions agentic workflows, AI agents, or autonomous execution**, suggest Agentic RICE and explain the difference before proceeding.

## Phase 2: Score Each Item

Default framework is **RICE**. Score every item, then rank by RICE score descending.

### RICE Scoring

**RICE Score = (Reach × Impact × Confidence) / Effort**

| Factor | What to estimate | Scale |
|--------|-----------------|-------|
| **Reach** | Users or events affected per quarter | Raw number (e.g. 2,400 users) |
| **Impact** | Magnitude of effect on a user when they encounter it | 3 = massive / 2 = high / 1 = medium / 0.5 = low / 0.25 = minimal |
| **Confidence** | How sure are you about Reach and Impact estimates | 100% = high / 80% = medium / 50% = low |
| **Effort** | Person-months to design, build, and ship | Raw number (e.g. 2 person-months) |

**How to use strategic context in scoring:**
- If STRATEGY.md was found, items that directly advance a named pillar get Impact bumped one tier (e.g. medium → high). State the reason explicitly.
- If OKRs were found, items that move an active Key Result get the same treatment.
- Do not silently inflate scores. Always show the rationale.

**When to ask vs. infer:**
- Reach and Effort: ask the user if not inferable from the FR or context.
- Impact: infer from strategic fit + user context, but show your reasoning.
- Confidence: default to 80% (medium) if the user hasn't indicated uncertainty.

### Agentic RICE Scoring

Use when work is being delegated to AI coding agents with no human directly involved in implementation.

The formula is identical — only the definition of Effort changes.

**RICE Score = (Reach × Impact × Confidence) / Agentic Effort**

**Agentic Effort** = the number of human touchpoints required before the agent can ship the ticket. Measured in interruptions, not time.

| Agentic Effort | Meaning |
|---------------|---------|
| 0.5 | Fully autonomous — agent runs start to finish without human input |
| 1 | One check-in — e.g. a review or a clarifying question before starting |
| 2 | Two check-ins — e.g. clarification upfront + review before merge |
| 3+ | Three or more — agent needs significant human guidance; essentially human-led |

**How to estimate Agentic Effort** — work through these four questions per item:

1. **Spec clarity**: Is the desired behavior fully defined, or will the agent need to interpret ambiguous requirements? Vague spec = more touchpoints.
2. **Scope isolation**: How many systems or subsystems does this touch? Cross-cutting changes require more human coordination.
3. **Verifiability**: Can the agent check its own work automatically (tests, linters, type checks)? No test coverage = human review required.
4. **Decision autonomy**: Does execution require product judgment calls mid-flight (copy, edge case handling, UX tradeoffs)? Each decision = a touchpoint.

Derive a touchpoint count from the answers. If all four are clean, Agentic Effort = 0.5. Each problematic factor adds roughly 0.5–1 touchpoint.

**When to ask vs. infer:**
- Spec clarity and decision autonomy: infer from the FR if one exists; ask if not.
- Scope isolation and verifiability: ask the user — these require codebase knowledge the skill doesn't have.
- Default to Agentic Effort = 1 if uncertain.

## Phase 3: Output

Save the result as `prioritization-[YYYY-MM-DD].md` in the current directory. Present the ranked table inline and confirm the file was saved.

```markdown
# Prioritization — [Date]

**Framework:** RICE / Agentic RICE
**Items scored:** [N]
**Strategy alignment:** [pillar names if found, or "No strategy doc found"]

---

## Ranked Backlog

| Rank | Item | Reach | Impact | Confidence | Effort | RICE Score | Pillar |
|------|------|------:|-------:|-----------:|-------:|----------:|--------|
| 1 | [Item] | [R] | [I] | [C]% | [E] | [score] | [Pillar or —] |
| 2 | ... | | | | | | |

*Effort column = [person-months / human touchpoints] depending on framework used.*

---

## Scoring Rationale

### [Item Name] — Score: [X]
- **Reach**: [estimate and source]
- **Impact**: [score and why — reference strategy/OKRs if applicable]
- **Confidence**: [% and reasoning]
- **Effort**: [estimate — for Agentic RICE, list the four factors and their touchpoint contribution]
- **Strategic fit**: [pillar alignment, or "No direct pillar match"]

---

## Read This Before You Ship

[2–3 sentences. Call out the top item and why it won. Flag any item that scores high on strategy but low on RICE (or vice versa) — these are the decisions worth discussing. If two items are within 10% of each other, say so and explain what would break the tie.]
```

---

## Alternative Frameworks

### ICE (simpler, faster)
Use when you need a quick stack rank without reach data.

**ICE Score = Impact × Confidence × Ease**

| Factor | Scale |
|--------|-------|
| Impact | 1–10 |
| Confidence | 1–10 |
| Ease | 1–10 (10 = easiest) |

Output: same ranked table format, ICE score in place of RICE.

### MoSCoW (release scoping)
Use when the goal is deciding what's in or out of a release, not a numeric rank.

Assign each item to: **Must have / Should have / Could have / Won't have (this release)**

Ground assignments in: does this block launch? does this meet a committed OKR? is this a nice-to-have?

Output: four sections, each with items and one-line rationale.

### Custom criteria
If the user supplies their own scoring dimensions (e.g. "score by strategic value, technical risk, and customer demand"), apply them as-is. Ask for weights if not specified; default to equal weighting.

---

## Key Rules

- **Never score without rationale.** A number without reasoning is just a guess written down.
- **Surface conflicts explicitly.** If a high-RICE item contradicts the stated strategy, say so rather than quietly ranking it lower.
- **Don't average away disagreement.** If Reach is highly uncertain, keep Confidence low rather than picking a middle-ground Reach number.
- **One framework per session.** Don't mix RICE and MoSCoW. If the user changes their mind mid-session, start a new ranking.
- **Agentic Effort is not a quality judgment.** A high touchpoint count means the ticket isn't ready for autonomous execution yet — not that it's unimportant. Separate the prioritization decision from the delegation decision.
