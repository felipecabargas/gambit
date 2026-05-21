---
name: competitive-analysis
description: |
  Structure a competitive landscape analysis — player profiles, capability comparison matrix,
  whitespace opportunities, and strategic implications.

  Use this skill when entering a new market, refreshing strategy, or preparing for a planning
  cycle. Trigger on: "do a competitive analysis", "who are our competitors", "compare us to X
  and Y", "what's the competitive landscape for [space]", "where is there whitespace in the
  market", "how do we stack up against [competitor]".
compatibility: "Requires filesystem access to project directory."
version: 1.0.0
argument-hint: "[list competitors and your product context]"
allowed-tools: [Read, Write, Bash]
---

# Competitive Analysis

## When to Use

Use this skill when you need a structured view of the competitive landscape. It adds the most value when:

- **Entering a new market** — understand who is already there, how they are positioned, and where the gaps are before committing investment
- **Refreshing strategy** — competitive landscapes shift; use this skill at the start of each planning cycle to ensure strategy reflects the current market, not last year's assumptions
- **Validating differentiation** — before writing a product strategy or feature request, confirm that your proposed differentiators are not already claimed or commoditised by competitors
- **Preparing for a board or investor review** — investors will probe competitive positioning; a structured analysis gives you credible, evidence-backed answers
- **Evaluating a potential acquisition or partnership** — understand a player's capability profile, market segment, and weaknesses before a strategic conversation
- **After a competitor launches something significant** — assess the impact on your positioning and identify where you need to respond

## Input Format

Provide the following to get the most complete analysis. You can paste content directly into the chat or describe it verbally.

**Competitor names and URLs:**
```
Competitors: Notion, Coda, Confluence
Your product: Acme Docs — a structured documentation tool for software teams
Target users: Engineering leads at companies with 50–500 engineers
```

**Your product context (who you serve and what you do):**
```
Acme Docs helps engineering leads at scaling companies document architecture decisions,
runbooks, and on-call procedures. Unlike general wikis, every page has a structured
template and a required owner. We charge per workspace, not per seat.
```

**Optional — evaluation dimensions you care about:**
```
Focus areas: pricing model, API/integration depth, permissions model, mobile experience
```

If no dimensions are specified, the skill defaults to the five standard dimensions (see Phase 1).

## Phase 0: Scan Existing Artefacts (Automatic)

Before scoping the analysis, silently scan for existing strategy and competitive analysis documents:

```bash
cat STRATEGY.md 2>/dev/null
cat COMPETITIVE-ANALYSIS.md 2>/dev/null
find . -maxdepth 3 -name "competitive-analysis.md" 2>/dev/null | head -3 | xargs cat 2>/dev/null
```

Based on what you find:
- **If COMPETITIVE-ANALYSIS.md exists**: summarise what's already documented and ask whether to update the existing analysis or start fresh. If updating, carry forward existing players and dimensions as the baseline.
- **If STRATEGY.md exists**: extract the strategic priorities that inform which competitive dimensions matter most for this context.
- **If nothing is found**: proceed to Phase 1 as normal.

Do not mention the scan to the user.

## Phase 1: Scope

Before analysing competitors, the skill confirms which dimensions matter most for your context. It will ask:

> "Which of these dimensions are most important for your analysis? Pick up to five, or accept the defaults."
>
> - Core Capabilities
> - Pricing Model
> - Target Segment
> - Key Differentiators
> - Weaknesses
> - UX / Ease of Use
> - Integration Ecosystem
> - Compliance & Security
> - Support Model
> - Mobile / Offline Experience

**Default dimensions (used when none are specified):**

| # | Dimension | What it covers |
|---|---|---|
| 1 | Core Capabilities | The features and functions each competitor is known for |
| 2 | Pricing Model | Free tier, per-seat, per-workspace, enterprise licensing |
| 3 | Target Segment | The buyer and user profiles each competitor primarily serves |
| 4 | Key Differentiators | The things each competitor does demonstrably better than the field |
| 5 | Weaknesses | Known gaps, complaints, or areas where competitors consistently underperform |

If the user provides evaluation dimensions, those replace or extend the defaults. The analysis always evaluates every competitor on the same dimensions so the comparison matrix is valid.

## Phase 2: Analysis

For each competitor listed, the skill builds a structured profile.

### Competitor Profile

Each profile covers:

- **Positioning statement** — how the competitor describes itself, who it claims to serve, and what it leads with in its messaging
- **Target user and buyer** — the primary user role (e.g. "developer", "ops manager") and the economic buyer (e.g. "CTO", "VP Engineering") based on public information and product design
- **Business model** — revenue model, pricing tiers, and any notable go-to-market characteristics (PLG, sales-led, channel)

### Capability Assessment

For each dimension selected in Phase 1, the skill assesses each competitor on a three-point scale:

| Rating | Meaning |
|---|---|
| Strong | This competitor is a recognised leader on this dimension; it is likely a stated differentiator |
| Adequate | This competitor covers the dimension at a functional level; not a differentiator, not a gap |
| Weak | This competitor has a known or apparent gap on this dimension; may be a source of customer complaints |

Each rating is accompanied by a one-sentence rationale and a confidence note (Public — visible on website or in press / Inferred — based on product design, pricing page, or reviews / Assumed — reasoning from market position, needs validation).

### Strengths and Weaknesses Summary

After the dimension assessment, each profile closes with:

- **Top 2–3 strengths** — what this competitor does well enough to win deals or retain users
- **Top 2–3 weaknesses** — where this competitor is most vulnerable or where customers most often complain

## Phase 3: Synthesis

Once all competitor profiles are complete, the skill synthesises across the full landscape.

### Comparison Matrix

A table comparing all competitors across all chosen dimensions, using the Strong / Adequate / Weak ratings. Your product is included as a row if you provided enough context; cells where your position is unknown are marked as TBD.

```markdown
| Dimension          | Your Product | Competitor A | Competitor B | Competitor C |
|--------------------|-------------|--------------|--------------|--------------|
| Core Capabilities  | Strong      | Strong       | Adequate     | Weak         |
| Pricing Model      | TBD         | Adequate     | Strong       | Adequate     |
| Target Segment     | ...         | ...          | ...          | ...          |
```

### Whitespace Map

The whitespace map identifies unserved segments or unmet needs that no current competitor addresses well. A whitespace opportunity is valid when:

1. Two or more competitors rate Weak or Adequate on the same dimension for the same user segment, AND
2. There is evidence (from reviews, forums, sales conversations, or research) that users in that segment actually care about the dimension

Each whitespace opportunity is written as a concise statement:

> **[Segment] × [Dimension]:** [Description of the gap and why it matters to this segment.]

Example: *Enterprise compliance buyers × Audit logging: No current competitor offers granular, exportable audit logs at the team tier — only at enterprise pricing. Mid-market companies with SOC 2 requirements are underserved.*

### Strategic Implications

For each whitespace opportunity, the skill derives at least one strategic implication — a concrete direction your product could take. Strategic implications are written as choices, not mandates:

> **Differentiate here** — where investing would give you a durable advantage no competitor currently holds
> **Avoid or deprioritise** — where the market is crowded, commoditised, or where a category leader has a structural advantage you cannot close
> **Monitor** — where a competitor is investing heavily and may close a gap you currently hold

## Output Format

The skill saves the analysis as `COMPETITIVE-ANALYSIS.md` in the current project directory. The output follows this structure:

```markdown
# Competitive Analysis: [Market / Space]

**Date:** [date]  
**Competitors analysed:** [N]  
**Dimensions evaluated:** [list]  
**Confidence key:** Public · Inferred · Assumed

---

## Executive Summary

[3–5 sentence overview: who the major players are, where competition is most intense,
and the most significant whitespace opportunity.]

---

## Competitor Profiles

### [Competitor Name]

**Positioning:** [One sentence — how they describe themselves]  
**Target user:** [Role / segment]  
**Target buyer:** [Economic buyer role]  
**Business model:** [Pricing structure and GTM motion]

**Capability Assessment:**

| Dimension | Rating | Rationale | Confidence |
|---|---|---|---|
| Core Capabilities | Strong | [reason] | Public |
| Pricing Model | Adequate | [reason] | Inferred |

**Strengths:** [bullet list]  
**Weaknesses:** [bullet list]

---

## Comparison Matrix

| Dimension | Your Product | [Comp A] | [Comp B] | [Comp C] |
|---|---|---|---|---|
| [Dimension 1] | [rating] | [rating] | [rating] | [rating] |
| [Dimension 2] | [rating] | [rating] | [rating] | [rating] |

---

## Whitespace Opportunities

### 1. [Segment] × [Dimension]
[Description of the gap, evidence for why this segment cares, and which competitors
are weak here.]

---

## Strategic Implications

### Differentiate Here
- **[Whitespace opportunity]:** [Why this is a durable advantage and what it would take to win it.]

### Avoid or Deprioritise
- **[Crowded area]:** [Why the competitive dynamics make this unattractive.]

### Monitor
- **[Emerging threat]:** [What to watch and when it would become a concern.]
```

## Quality Rules

These rules ensure the analysis is honest, actionable, and useful for strategy decisions.

- **Distinguish public information from assumptions**: Every capability rating must carry a confidence note. Public means it is visible on the competitor's website, pricing page, or in press coverage. Inferred means it is derived from product design, review sites, or hiring patterns. Assumed means it is reasoning from market position — flag these prominently and recommend validation.
- **Flag anything needing validation**: If a rating or claim is based on limited evidence, add a note: *"Needs validation — [recommended method, e.g. trial account, customer reference call, G2 review analysis]."*
- **Connect every whitespace finding to a strategic implication**: A whitespace map with no strategic implications is just a list of gaps. Every whitespace opportunity must link to at least one concrete direction (differentiate, avoid, or monitor). Orphaned whitespace findings should be removed or deferred to an appendix.
- **Include your product as a row**: If sufficient product context was provided, include your product in the comparison matrix. Cells where your position is unknown are marked TBD, not omitted — TBD cells are prompts for internal validation.
- **No invented competitor weaknesses**: Do not speculate about weaknesses not grounded in reviews, customer feedback, or observable product decisions. If a weakness is commonly reported, cite the source type (e.g. "G2 reviews", "support forum posts", "sales call notes").
- **Scope the analysis**: State clearly if the analysis covers a specific geography, segment, or product category. Never imply the findings represent the entire market if the input was narrower.

## How to Trigger

Ask Claude to run a competitive analysis by saying things like:

- "Do a competitive analysis of the documentation tools market — our competitors are Notion, Confluence, and Coda"
- "Who are our competitors and how do we stack up against them?"
- "Compare us to Figma and Sketch — I need to know where we have whitespace"
- "What's the competitive landscape for AI writing assistants?"
- "Where is there whitespace in the project management market?"
- "How do we stack up against Linear and Jira for developer teams?"

Claude will automatically invoke this skill, run the three-phase analysis, and save the results as `COMPETITIVE-ANALYSIS.md` in your project directory.
