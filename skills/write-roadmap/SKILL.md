---
name: write-roadmap
description: |
  Create a horizon-based product roadmap from strategy and OKRs. Organises work into Now/Next/Later
  themes derived from strategy pillars, marks items as committed vs. directional, and avoids fake
  precision (no hard dates unless explicitly provided).

  Trigger on: "write a roadmap", "create our ROADMAP.md", "help me plan the next few quarters",
  "what should we build and when", "turn this strategy into a roadmap", "build a Now/Next/Later
  plan", or after write-okrs.
compatibility: "Requires filesystem access to project directory. Works best with STRATEGY.md and OKRs docs."
version: 1.0.0
argument-hint: "[paste strategy/OKRs or describe your priorities]"
allowed-tools: [Read, Write, Bash]
---

# Roadmap Writer

## When to Use

Use this skill when you need to translate strategy and OKRs into a clear, communicable picture of what the team is working on and why. It adds the most value when:

- **Starting a planning cycle** — turn a freshly written strategy or set of OKRs into a roadmap the team and stakeholders can reason about. Use immediately after `write-okrs` to close the loop from strategy through measurement to planned work.
- **Communicating priorities to stakeholders** — when leadership, sales, or external partners ask "what are you building and when?", a horizon-based roadmap gives an honest, durable answer without over-committing to specific dates.
- **Aligning engineering on what's coming** — engineers need enough forward visibility to make good technical decisions (avoiding premature optimisation, planning for capacity, flagging risks early). A Now/Next/Later roadmap provides that signal without locking in requirements before they're understood.

## Input Format

The skill scans the current project directory for `STRATEGY.md` and any OKR documents automatically. If found, it reads strategy pillars and Key Results to derive roadmap themes. You can also provide:

**Path to strategy and OKR documents:**
```
Strategy: ./STRATEGY.md
OKRs: ./OKRs-Q2-2026.md
```

**Pasted priorities or strategic pillars:**
```
Pillar 1: Improve activation for self-serve sign-ups
Pillar 2: Expand into the mid-market segment
Pillar 3: Lay the compliance foundation for enterprise deals
```

**A description of current priorities:**
```
We're focused on activation this quarter, with mid-market expansion as our next
big push. Compliance work (SOC 2, SSO) is important but 2+ quarters out.
```

**Optionally, backlog items to place on the roadmap:**
```
- Redesigned onboarding flow
- API rate limiting
- SSO integration
- Mobile app (iOS)
- Advanced analytics dashboard
```

If backlog items are provided, the skill assigns each item to a horizon and a theme rather than listing them as raw tickets. The roadmap stays theme-based even when the input is feature-level.

## Horizon Model

The roadmap uses three horizons rather than fixed quarters or release dates. This avoids fake precision — committing to dates before requirements are understood damages trust when plans change.

### Now — Committed, In Progress or Imminent

Work that is actively in flight or will start within the current planning period (typically the current quarter). Items in Now are **Committed**: the team has scoped them, allocated capacity, and is accountable for delivery. A Now theme that slips is a planning failure, not a reprioritisation.

### Next — Directional, Next 1–2 Quarters

Work the team intends to tackle after Now is complete. Items in Next are **Directional**: the strategy points here, the intent is strong, but details may change as Now-horizon work reveals new information. Next themes should have enough definition to start architecture discussions but should not be fully scoped.

### Later — Exploratory, Beyond the Current Horizon

Important strategic bets that are not yet prioritised. Items in Later are **Directional**: they reflect strategic intent but no capacity commitment. Later themes should not be listed as "maybe one day" — every Later item must connect to a strategy pillar. If it does not, it belongs in "Explicitly Not Doing."

### Quarterly Option

If the team strongly prefers quarters over horizons (e.g. for board reporting), the skill can label horizons as Q[N] / Q[N+1] / Q[N+2] instead of Now/Next/Later. Request this with: *"Use quarters instead of horizons."* Date labels do not change the commitment model — committed vs. directional still applies within each quarter.

## How It Works

The skill follows four steps to produce a roadmap that is honest about uncertainty and traceable to strategy.

### Step 1 — Read Strategy Pillars and OKRs to Derive Themes

The skill reads the strategy document and OKRs (or pasted input) and identifies the major strategic pillars. Each pillar becomes a **theme** on the roadmap — a named area of investment with an expected outcome. Themes are not feature lists; a theme describes the problem being solved and the result the team is trying to achieve.

If more than 5–6 themes emerge, the skill asks you to consolidate: *"I've identified 7 potential themes. Roadmaps with more than 5–6 themes are hard to communicate clearly. Can we merge any of these, or identify which are least strategic this period?"*

### Step 2 — Assign Themes to Horizons Based on Strategic Priority and Dependencies

The skill assigns each theme to a horizon using two criteria:

- **Strategic priority** — which themes serve the most urgent OKRs or strategy pillars? These go into Now.
- **Known dependencies** — themes that depend on Now-horizon work being complete land in Next or Later. Dependencies are called out explicitly in the roadmap to help engineering and stakeholders anticipate sequencing.

If the user has provided capacity constraints (team size, known leave, competing projects), the skill uses these to sanity-check whether the Now horizon is realistic, and will flag overloads: *"You've assigned 4 themes to Now with a team of 3 engineers. This looks overloaded — which 2 themes are most critical?"*

### Step 3 — For Each Theme, Describe the Expected Outcome

For each theme, the skill writes a one-to-two sentence outcome statement: what will be true for users or the business when this theme is complete? This is not a feature description.

- **Theme, not feature list:** "Activation" is a theme. "New onboarding flow, email drip sequence, in-app tooltips" is a feature list masquerading as a theme.
- **Outcome, not deliverable:** "Users reach the activation milestone within 3 days of sign-up" is an outcome. "Launch new onboarding" is a deliverable.

If the input contains only feature lists, the skill derives themes and outcomes from them and surfaces these for your confirmation before writing the document.

### Step 4 — Mark Each Item: Committed or Directional

Every theme in every horizon is marked with its commitment status:

- **Committed** — scoped, resourced, and on track to deliver in the stated horizon. The team is accountable.
- **Directional** — strategically intended but not yet fully scoped or resourced. The team's best current thinking. May change.

All Now-horizon themes are Committed by default (if a Now theme cannot be committed to, it should move to Next). Next and Later themes are Directional unless the team has explicitly pre-committed capacity.

## Output Format

The skill saves the roadmap as `ROADMAP.md` in the current project directory. The output follows this template:

```markdown
# Product Roadmap

**Strategy source:** [filename or "Pasted input"]
**Last updated:** [date]
**Owner:** [PM name if provided]

---

## Introduction

[2-sentence summary of the product strategy this roadmap serves. What is the team trying to achieve, and for whom?]

---

## Now — [Current Quarter or "Current Period"]

> Committed work. The team is accountable for delivery this period.

### Theme: [Theme Name]
**Outcome:** [What will be true for users or the business when this is done?]
**Strategy pillar:** [Pillar name from strategy]
**Status:** Committed

### Theme: [Theme Name]
**Outcome:** [Expected outcome]
**Strategy pillar:** [Pillar name]
**Status:** Committed

---

## Next — [Next 1–2 Quarters or "Next Period"]

> Directional. Strong intent, details may evolve as Now-horizon work completes.

### Theme: [Theme Name]
**Outcome:** [Expected outcome]
**Strategy pillar:** [Pillar name]
**Status:** Directional
**Depends on:** [Now-horizon theme name, if applicable]

---

## Later — [Beyond Current Horizon]

> Exploratory. Strategic intent established, not yet prioritised or resourced.

### Theme: [Theme Name]
**Outcome:** [Expected outcome]
**Strategy pillar:** [Pillar name]
**Status:** Directional

---

## Explicitly Not Doing

The following areas are out of scope for this roadmap period and the reasons why.

| Area | Reason |
|---|---|
| [Area name] | [Why it is excluded — strategic fit, capacity, timing] |
| [Area name] | [Reason] |

---

## Open Dependencies

| Theme | Depends On | Owner | Status |
|---|---|---|---|
| [Theme] | [External system / team / Now-horizon theme] | [Owner] | [Resolved / Open] |
```

## Key Rules

These rules are enforced before the roadmap is saved.

- **No feature lists** — every roadmap item is a theme with an outcome statement, not a list of features. A theme can inspire a feature list; the roadmap is not that list. This keeps the document strategically useful and avoids premature commitment to solutions.
- **No dates unless the user provides them** — the skill never invents delivery dates. If the user provides dates ("we need the compliance work done by October for a customer audit"), those dates are included verbatim. Fabricated dates create false expectations and erode trust when plans change.
- **Every theme links to a strategy pillar or Key Result** — a theme that cannot be traced to a pillar or KR is either a tactical task (not roadmap-level work) or a sign that the strategy is incomplete. Unlinked themes are flagged and the user is asked to either link them or move them to "Explicitly Not Doing."
- **"Explicitly Not Doing" section is required** — a roadmap without explicit exclusions is not a roadmap, it is a list. The value of a roadmap is as much in what it says no to as what it says yes to. Exclusions prevent scope creep, give stakeholders a clear answer when they ask about missing items, and demonstrate that the team has made deliberate trade-offs. The skill will not save a roadmap without at least two entries in this section.

## How to Trigger

Ask Claude to write a roadmap by saying things like:

- "Write a roadmap from our strategy and OKRs"
- "Create our ROADMAP.md for the next few quarters"
- "Help me plan the next few quarters based on these priorities"
- "Turn this strategy into a Now/Next/Later plan"
- "What should we build and when — here are our strategy pillars"
- "I just finished writing OKRs — now build the roadmap"

Claude will automatically invoke this skill, run the four-step process, and save the result as `ROADMAP.md` in your project directory.
