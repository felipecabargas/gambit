# Getting Started with Gambit

This guide walks you through installing and using Gambit in your Claude environment.

## Installation

### Option A: Claude Plugin (recommended)

From within Claude Code, run:

```bash
/plugin marketplace add felipecabargas/gambit
/plugin install gambit@felipecabargas-gambit
```

Skills are immediately available as model-invoked skills and slash commands. No restart required.

### Option B: Manual Install

Use this if you are not using Claude Code or prefer manual control.

Clone the repository and copy skills into your Claude skills directory:

```bash
git clone https://github.com/felipecabargas/gambit.git

# Copy all skills at once
cp -r gambit/skills/* ~/.claude/skills/

# Copy all agents at once
cp -r gambit/agents/* ~/.claude/skills/
```

Create the directory first if it doesn't exist: `mkdir -p ~/.claude/skills`

Restart Claude Code to load the newly installed skills.

---

## What's Included

Gambit ships **13 skills** across four categories and **4 chained workflow agents**.

### Skills

| Category | Skill | What it does |
|---|---|---|
| Core | `verify-acceptance-criteria` | Score ACs against five quality dimensions, identify gaps, rewrite weak criteria |
| Core | `write-feature-request` | Guided FR authoring with auto-generated ACs for every requirement |
| Core | `write-product-strategy` | Generate a `STRATEGY.md` with pillars, research citations, and roadmap horizons |
| Core | `sprint-review` | Turn ticket lists or sprint data into a polished stakeholder report |
| Core | `prioritize` | Score and rank features using RICE, ICE, or MoSCoW |
| Discovery | `synthesize-user-research` | Pull themes, pain points, and jobs-to-be-done from raw research |
| Discovery | `build-user-persona` | Build evidence-backed personas with research-validated vs. inferred attributes |
| Discovery | `competitive-analysis` | Player profiles, capability matrix, and whitespace opportunities |
| Communication | `write-okrs` | Derive Objectives and Key Results from a product strategy |
| Communication | `write-roadmap` | Horizon-based roadmap (Now/Next/Later) from strategy and OKRs |
| Communication | `write-release-notes` | Customer-facing release notes from sprint tickets and PRs |
| Communication | `write-stakeholder-update` | Data-led leadership status update with OKR progress |
| Handoff | `write-technical-brief` | Engineering handoff document from a verified Feature Request |

### Agents

Agents chain multiple skills in sequence, pausing for confirmation between steps.

| Agent | Chain | When to use |
|---|---|---|
| `discovery-to-fr` | synthesize-user-research → build-user-persona → write-feature-request | You have raw research and want a finished FR |
| `fr-to-ready` | write-feature-request → verify-acceptance-criteria → write-technical-brief | You have a feature idea and want a dev-ready handoff package |
| `strategy-to-roadmap` | write-product-strategy → write-okrs → write-roadmap | Start of a planning cycle |
| `sprint-to-stakeholders` | sprint-review → write-release-notes → write-stakeholder-update | End of every sprint |

---

## Using the Skills

Skills activate from natural language — just describe what you need. You can also invoke them directly as slash commands.

### Core Skills

**verify-acceptance-criteria**
```
Review these acceptance criteria and tell me if they're good:
- The user can search for products
- Results display within 2 seconds
- Filters work correctly
```
Returns a scored evaluation (80+ = ready for dev), issues by severity, and rewritten versions of weak criteria.

**write-feature-request**
```
Write a feature request for a bulk export feature in our analytics dashboard
```
Runs as a multi-step conversation: gathers problem and requirements, generates testable ACs for each, assembles a complete FR in Markdown.

**write-product-strategy**
```
Help me write a product strategy for our developer tooling product
```
Scans your project for existing docs, asks targeted questions, and saves a `STRATEGY.md` with strategic pillars tied to research evidence.

**sprint-review**
```
Write my sprint review for Sprint 42 — here are the completed tickets: [paste list]
```
Accepts ticket titles, JIRA sprint IDs, or GitHub date ranges. Saves a `sprint-review-[sprint-name].md`.

**prioritize**
```
Rank these features by RICE score against our current strategy
```
Reads your `STRATEGY.md` and OKRs to ground Impact scores in what the team is actually optimizing for.

### Discovery Skills

**synthesize-user-research**
```
Synthesize these interview notes into themes and pain points
```
Produces structured themes, pain points, jobs-to-be-done, and research gaps from raw inputs (interview notes, survey results, NPS verbatims, support tickets).

**build-user-persona**
```
Build a user persona from these research findings
```
Creates a structured persona document with each attribute labeled as research-validated or inferred — no made-up archetypes.

**competitive-analysis**
```
Analyze our competitive landscape — here are the players we're tracking: [list]
```
Outputs player profiles, a capability comparison matrix, whitespace opportunities, and strategic implications.

### Communication Skills

**write-okrs**
```
Generate Q3 OKRs based on this strategy document
```
Derives Objectives and Key Results from strategy pillars, challenges vague KRs, and distinguishes outputs from outcomes.

**write-roadmap**
```
Create a Now/Next/Later roadmap from our strategy and OKRs
```
Organises themes (not features) into horizons, marks items as committed vs. directional, and ties each to a strategy pillar.

**write-release-notes**
```
Turn these sprint tickets into customer-facing release notes
```
Filters internal and infra work, rewrites ticket titles as user benefits, and groups by category (New / Improved / Fixed).

**write-stakeholder-update**
```
Write a leadership update for this week — here's our OKR status and what shipped
```
Leads with a clear status signal (on track / at risk / blocked), surfaces concrete numbers, and shows OKR progress.

### Handoff Skills

**write-technical-brief**
```
Write a technical brief from this feature request for the engineering team
```
Covers scope boundaries, technical constraints, edge cases with recommended handling, and open questions engineering needs to resolve.

---

## Common Workflows

### Full Planning Cycle

Run the `strategy-to-roadmap` agent or work through the skills individually:

1. `/gambit:write-product-strategy` — define where to play and how to win
2. `/gambit:write-okrs` — derive measurable outcomes from strategy pillars
3. `/gambit:write-roadmap` — organize work into Now/Next/Later horizons

### Research to Spec

Run the `discovery-to-fr` agent or:

1. `/gambit:synthesize-user-research` — structure raw research into themes and JTBD
2. `/gambit:build-user-persona` — ground the FR in a specific user archetype
3. `/gambit:write-feature-request` — produce the spec with generated ACs

### Feature to Dev-Ready Handoff

Run the `fr-to-ready` agent or:

1. `/gambit:write-feature-request` — author the FR
2. `/gambit:verify-acceptance-criteria` — catch gaps before handoff
3. `/gambit:write-technical-brief` — package for engineering

### End-of-Sprint Communications

Run the `sprint-to-stakeholders` agent or:

1. `/gambit:sprint-review` — recap what shipped
2. `/gambit:write-release-notes` — rewrite for customers
3. `/gambit:write-stakeholder-update` — package for leadership

---

## Tips for Best Results

**Be rough with inputs.** Skills ask for what they need — you don't need to format inputs perfectly.

**Add context when it matters.** Mentioning domain, platform, or audience improves output:
```
These are ACs for a mobile ecommerce checkout flow — review with mobile UX in mind.
```

**Use agents for end-to-end flows.** Agents handle context-passing between steps so you don't have to copy-paste outputs manually.

**Let prioritize read your strategy.** If you have a `STRATEGY.md`, the prioritize skill grounds Impact scores in your actual OKRs rather than guessing.

---

## Troubleshooting

### Skills not appearing after plugin install

1. Start a fresh conversation — skills load at session start
2. Confirm the install succeeded with `/plugin list`
3. Reinstall if needed: `/plugin marketplace add felipecabargas/gambit` then `/plugin install gambit@felipecabargas-gambit`

### Skills not appearing after manual install

1. Verify files are in `~/.claude/skills/[skill-name]/SKILL.md`
2. Restart Claude Code
3. Try a fresh conversation

### Unexpected output

1. Add more context to your prompt
2. Try a different phrasing or format
3. Share an example of what you're expecting
