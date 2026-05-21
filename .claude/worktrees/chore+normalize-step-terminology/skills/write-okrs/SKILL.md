---
name: write-okrs
description: |
  Generate well-structured OKRs from a product strategy. Derives Objectives and Key Results from
  strategy pillars, challenges vague KRs, distinguishes outputs from outcomes, and links each OKR
  back to the strategy pillar it serves.

  Trigger on: "write our OKRs", "help me set OKRs for this quarter", "turn this strategy into
  OKRs", "what should our key results be", "draft Q[N] OKRs", or after completing
  write-product-strategy.
compatibility: "Requires filesystem access to project directory. Works best with a STRATEGY.md in the project."
version: 1.0.0
argument-hint: "[paste strategy pillars or path to STRATEGY.md]"
allowed-tools: [Read, Write, Bash]
---

# OKR Writer

## When to Use

Use this skill when you need to translate strategic intent into measurable quarterly commitments. It adds the most value when:

- **Quarterly planning** — turn a product strategy or planning document into a set of OKRs the team can commit to and track weekly
- **Aligning teams on what success looks like** — when multiple teams need a shared, unambiguous definition of a good quarter, OKRs written from a common strategy pillar ensure alignment without requiring everyone to re-read the strategy document
- **Translating a strategy into measurable commitments** — a strategy document describes direction; OKRs make that direction testable. Use this skill immediately after `write-product-strategy` to close the loop between strategy and execution
- **After completing a `write-product-strategy` session** — the natural next step once strategy pillars are defined and agreed
- **When existing OKRs feel vague or output-focused** — use this skill to audit and rewrite OKRs that have drifted toward shipping lists instead of outcome statements

## Input Format

The skill scans the current project directory for `STRATEGY.md` automatically. If found, it reads the strategy pillars and proposes a first draft of OKRs for your review. You can also provide:

**Path to a strategy document:**
```
Path: ./STRATEGY.md
```

**Pasted strategy pillars:**
```
Pillar 1: Improve activation for self-serve sign-ups
Pillar 2: Expand into the mid-market segment (50–500 employees)
Pillar 3: Build a foundation for enterprise compliance (SOC 2, SSO)
```

**A description of strategic priorities:**
```
This quarter we're focused on two things: reducing time-to-value for new users
so that more of them reach the activation milestone, and starting the compliance
work that will unlock enterprise deals in Q4.
```

**Optionally, previous OKRs to build on:**
```
Path: ./OKRs-Q1-2026.md
```

If previous OKRs are provided, the skill uses them to set baselines for Key Results where applicable, and identifies KRs that were not achieved and may carry forward.

## How It Works

The skill follows five steps to produce OKRs that are ambitious, measurable, and honest about confidence levels.

### Step 0 — Scan for Strategy and Existing OKRs (silent)

Before reading the user's strategy input, silently scan for source documents:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | xargs cat 2>/dev/null
```

If STRATEGY.md is found, use it as the primary source for Step 1 rather than asking the user to describe the strategy. If existing OKR files are found, surface them: *"I found existing OKRs — should I update these or draft a new set for a different period?"* Do not mention the scan.

### Step 1 — Read the Strategy and Identify 2–4 Distinct Pillars or Bets

The skill reads the strategy document or input and identifies the 2–4 major strategic pillars. A pillar is a distinct area of focus that the strategy is betting on — not a feature, not a project, but a direction. If the input contains more than 4 pillars, the skill asks you to prioritise: *"You've listed 6 strategic areas. OKRs work best with 2–4 Objectives. Which of these are the top priorities for this quarter?"*

Each pillar becomes the source for exactly one Objective.

### Step 2 — Draft One Objective Per Pillar

For each pillar, the skill drafts one Objective. A well-formed Objective has three properties:

- **Qualitative** — it describes a direction, not a number. The number belongs in the Key Results.
- **Inspiring** — it should motivate the team. Dry, bureaucratic language makes OKRs feel like compliance exercises rather than commitments.
- **Time-bound** — it should be clearly scoped to a quarter or planning period, not an evergreen aspiration.

The skill writes an Objective in the form: *"[Verb] [what you want to achieve] [for whom / in what context] by [end of quarter]."*

Example: *"Make self-serve activation feel effortless for new users by end of Q2 2026."*

### Step 3 — Draft 2–4 Key Results Per Objective

For each Objective, the skill drafts 2–4 Key Results. The skill will ask for baseline and target values if they are not provided in the strategy input:

> "For the activation Objective, I need a baseline and target to write measurable KRs. What is the current activation rate (% of sign-ups reaching the activation milestone within 7 days)? And what would a good quarter look like?"

If no baseline is available, the skill writes a KR with a placeholder: *"Increase [metric] from [TBD — establish baseline in week 1] to [target]."* The TBD baseline is flagged as a week-1 task.

### Step 4 — Challenge Each KR: Outcome or Output?

This is the most important step. Before finalising any KR, the skill applies the outcome test:

> "Does this KR measure a result that matters to a user or the business — or does it measure something we shipped?"

- **Outcome KR**: Measures a change in user behaviour, business performance, or system state that has value independent of what was built.
- **Output KR**: Measures whether something was shipped, launched, or completed. Output KRs are tracking mechanisms, not success measures.

For every output KR found, the skill rewrites it as an outcome KR and explains the difference. If a launch must be tracked (e.g. a compliance deadline), it is retained as a milestone, not a KR.

### Step 5 — Mark Each KR as Committed or Stretch

Each KR is marked with a confidence level:

- **Committed** — the team is >70% confident it can achieve this KR given current resources and trajectory. Committed KRs represent the floor; the quarter is considered a failure if they are missed.
- **Stretch** — the team is <50% confident. Stretch KRs represent upside. A quarter where all stretch KRs are hit is a signal that planning targets were too conservative.

The skill asks for your assessment: *"For each KR, is this Committed (>70% confident) or Stretch (<50% confident)?"* If you are unsure, the skill defaults to Stretch and flags it for team calibration.

## Output Format

The skill saves the OKRs as `OKRs-[period].md` in the current project directory, where `[period]` is derived from the planning period (e.g. `OKRs-Q2-2026.md`). The output follows this full template:

```markdown
# OKRs: [Period]

**Strategy source:** [filename or "Pasted input"]  
**Date drafted:** [date]  
**Owner:** [PM name if provided]

---

## Objective 1: [Objective statement]

**Strategy pillar:** [Pillar name from strategy]  
**Why this quarter:** [One sentence on why this is a priority now]

### KR 1.1: [Key Result statement]
- **Baseline → Target:** [current value] → [target value]
- **Measurement:** [How this will be tracked — metric name, data source]
- **Confidence:** Committed / Stretch
- **Strategy pillar:** [Pillar name]

### KR 1.2: [Key Result statement]
- **Baseline → Target:** [current value] → [target value]
- **Measurement:** [How this will be tracked]
- **Confidence:** Committed / Stretch
- **Strategy pillar:** [Pillar name]

---

## Objective 2: [Objective statement]

**Strategy pillar:** [Pillar name]  
**Why this quarter:** [One sentence]

### KR 2.1: [Key Result statement]
- **Baseline → Target:** [current value] → [target value]
- **Measurement:** [How this will be tracked]
- **Confidence:** Committed / Stretch
- **Strategy pillar:** [Pillar name]

---

## Summary Table

| Objective | KR | Baseline | Target | Confidence |
|---|---|---|---|---|
| [O1 short label] | [KR 1.1 short label] | [value] | [value] | Committed |
| [O1 short label] | [KR 1.2 short label] | [value] | [value] | Stretch |
| [O2 short label] | [KR 2.1 short label] | [value] | [value] | Committed |
```

## Quality Rules

These rules are enforced before the final output is saved.

- **Maximum 4 Objectives** — more than 4 Objectives means the team is not making trade-offs. If the strategy input implies more than 4, the skill prompts for prioritisation before drafting.
- **Maximum 4 KRs per Objective** — more than 4 KRs per Objective diffuses focus. If more than 4 outcomes can be derived from a single pillar, that pillar may need to be split into two Objectives or the KRs need to be consolidated.
- **Every KR must have a number** — vague KRs are not KRs. The skill will not output a KR without a baseline and a target. "Improve NPS" is not a KR. "Increase NPS from 32 to 45" is. If a baseline does not exist, the KR is written with a TBD placeholder and week-1 baseline establishment is added as a task.
- **KRs must be outcomes, not outputs** — every KR is tested against the outcome criterion in Step 4. Output KRs are rewritten or removed before the document is saved.

## Common Pitfalls

These are the most common ways OKRs go wrong. The skill identifies and corrects each of these patterns before saving.

### Pitfall 1: Output KRs

**Bad:** *"Launch the new onboarding flow"*
This is a task, not a result. Whether or not the launch happens says nothing about whether it worked.

**Rewrite:** *"Increase 7-day activation rate from 22% to 35% following onboarding redesign launch"*
Now the KR measures whether the launch achieved its purpose. If activation does not improve, the team has signal to iterate.

### Pitfall 2: Vanity Metrics

**Bad:** *"Increase page views from 500K to 1M per month"*
Page views are easily influenced by low-quality traffic, SEO changes, or marketing spend that has nothing to do with product quality. A team can hit this KR while the product gets worse.

**Rewrite:** *"Increase weekly active users who complete at least one core workflow from 18K to 30K"*
This measures meaningful engagement — users doing the thing the product is for — not just visits.

### Pitfall 3: KRs Fully Within Team Control

**Bad:** *"Write and publish 12 blog posts about our API"*
The team can guarantee this outcome by just doing the work. There is no uncertainty, no business impact, and no test of whether the strategy is working.

**Rewrite:** *"Increase inbound API trial sign-ups from 80 to 200 per month"*
Now the KR measures whether the content investment (and other efforts) are moving a business needle. The team must earn the result, not just complete a task.

## How to Trigger

Ask Claude to write OKRs by saying things like:

- "Write our OKRs for Q3 based on this strategy"
- "Help me set OKRs for this quarter"
- "Turn this product strategy into OKRs"
- "What should our key results be for the activation pillar?"
- "Draft Q2 2026 OKRs from our STRATEGY.md"
- "I just finished writing the product strategy — now help me write the OKRs"

Claude will automatically invoke this skill, run the five-step process, and save the results as `OKRs-[period].md` in your project directory.
