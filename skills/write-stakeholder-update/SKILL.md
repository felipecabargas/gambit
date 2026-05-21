---
name: write-stakeholder-update
description: |
  Write a concise, data-led PM status update for leadership. Leads with a clear status signal
  (on track / at risk / blocked), surfaces concrete impact with numbers, shows OKR progress,
  flags decisions needed, and fits on one page.

  Trigger on: "write a stakeholder update", "draft my weekly PM update", "write a status update
  for leadership", "what should I tell leadership this week", "write my monthly PM report", or
  after a sprint-review session.
compatibility: "Requires filesystem access to project directory."
version: 1.0.0
argument-hint: "[paste sprint data or describe what shipped]"
allowed-tools: [Read, Write, Bash]
---

# Stakeholder Update Writer

## When to Use

Use this skill when you need to communicate product progress to leadership in a way that is clear, honest, and decision-ready. It adds the most value when:

- **Weekly or monthly PM cadence** — recurring leadership updates are time-consuming to write well. This skill produces a consistent, one-page format that gives leaders exactly what they need to stay informed without requiring them to read a sprint report.
- **Post-sprint leadership communication** — after each sprint, a well-structured update closes the loop between the team's work and leadership's awareness. Use after `sprint-review` to convert sprint data directly into a stakeholder-ready document.
- **Escalation or risk communication** — when something is at risk or blocked, leadership needs to know immediately and clearly. The status signal at the top of this format ensures the message lands, and the Decisions Needed section gives leaders a specific action to take rather than leaving them to infer what you're asking for.

## Input Format

The skill accepts a range of inputs, from structured documents to a quick verbal summary. The more concrete the input, the more specific the output.

**Sprint review output from `sprint-review`:**
```
Path: ./sprint-review-2026-05-05.md
```

**Release notes (from `write-release-notes`):**
```
Path: ./release-notes-2026-05-05.md
```

**OKR progress (optional but recommended):**
```
KR 1.1: Activation rate — current 28%, target 35%, baseline 22%
KR 1.2: Time to activation — current 4.2 days, target 3 days, baseline 5.5 days
KR 2.1: Mid-market pipeline — current $180K, target $500K, baseline $0
```

**Pasted sprint summary or freeform description:**
```
This sprint we shipped the CSV export feature and fixed the mobile upload crash.
The activation rate is up to 28% (from 22% at the start of the quarter). We're
blocked on the SSO integration because the enterprise customer hasn't provided
their IdP configuration yet. We need a decision on whether to delay the Q3
compliance milestone or proceed without that customer.
```

**Risks or decisions needed (optional):**
```
Risk: SSO integration blocked pending customer IdP config. Impacts Q3 compliance timeline.
Decision needed: Should we adjust the Q3 milestone date or escalate to the customer's executive sponsor?
```

Freeform input is welcome. The skill will extract what it needs and ask for anything critical that is missing.

## How It Works

The skill follows four steps to produce an update that leads with signal, backs it up with evidence, and makes any required leadership action explicit.

### Step 0 — Scan for Prior Updates and Strategy Context (silent)

Before determining the status signal, silently scan for context:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | tail -1 | xargs cat 2>/dev/null
ls stakeholder-update-*.md 2>/dev/null | sort | tail -3 | xargs cat 2>/dev/null
```

Use any found artefacts to:
- Pre-populate OKR progress from scanned OKR files
- Reference prior update commitments (e.g. *"last update said X would ship by Y"*)
- Anchor the status signal to concrete OKR evidence rather than relying solely on user description

Do not mention the scan.

### Step 1 — Determine Status Signal from OKR Progress and Blockers

The first line of the update is the status signal. Leadership should know the health of the product area before reading a single sentence of detail.

The skill determines the signal from three inputs:
- OKR progress: are Key Results on track, behind, or stalled?
- Active blockers: is there anything preventing the team from executing?
- Trend: is performance improving, flat, or declining?

Status signals:
- **On Track** — OKRs are progressing as planned, no critical blockers, team is executing to plan
- **At Risk** — one or more KRs are behind target, or a blocker exists that may affect delivery if unresolved within 1–2 weeks
- **Blocked** — the team cannot make meaningful progress on a critical item without external action (a decision, a resource, a dependency being resolved)

The signal is not softened. If something is at risk, the update says "At Risk." The purpose of the signal is to help leadership allocate their attention — a buried risk is a failure of communication.

If OKR data is not provided, the skill derives a signal from the qualitative description and flags the assumption: *"Based on your description, I've assessed this as 'At Risk'. If you have OKR data, share it and I'll revise if needed."*

### Step 2 — Identify 2–3 Most Impactful Shipped Items with Concrete Results

The update surfaces 2–3 shipped items from the current period, prioritised by customer impact, not effort. A major feature that moved a key metric outranks a technically impressive refactor that was invisible to users.

For each item, the skill writes a single bullet that:
- Names what shipped
- States the concrete result (number preferred, directional language acceptable if no data is available)
- Links to an OKR or strategy pillar where possible

**Examples:**

- "Shipped CSV export — [KR 2.3: data export adoption] baseline established at 12% of active users in week 1"
- "Fixed mobile upload crash — support tickets related to this issue down 84% week-over-week"
- "Activation rate reached 28% (target: 35%, baseline: 22%) — on pace to hit KR 1.1 by end of quarter"

If no concrete results are available yet (e.g. a feature just shipped), the skill notes when results are expected: *"[Feature] shipped on [date]. Impact measurement begins [date]; results in next update."*

### Step 3 — Summarise OKR Progress

If OKR data is provided, the skill generates a progress table showing current vs. target for each Key Result. This gives leadership a snapshot of the quarter at a glance.

If OKR data is not provided, this section is omitted and the skill notes: *"OKR progress table omitted — no KR data provided. Add current vs. target values for each KR to include this section."*

The table uses a simple traffic light indicator based on progress-to-date relative to time elapsed in the quarter:
- On track: current progress is within 10% of the expected run-rate
- At risk: current progress is 10–25% behind expected run-rate
- Behind: current progress is more than 25% behind expected run-rate

### Step 4 — Identify Decisions or Actions Needed from Leadership

This is the most important section for leadership. The skill extracts every item that requires a decision, approval, or action from outside the immediate team and lists them explicitly.

A well-formed decision request has three parts:
1. **Context** — one sentence on the situation
2. **Options** — two or more options (not just "approve or reject")
3. **Ask** — what specifically is needed from leadership, and by when

**Example:**

> **Decision: SSO milestone timeline**
> Context: SSO integration is blocked pending IdP configuration from enterprise customer [Name]. Configuration has been outstanding for 3 weeks.
> Options: (A) Extend Q3 compliance milestone by 4 weeks and notify the customer. (B) Escalate to the customer's executive sponsor to unblock within 1 week. (C) Proceed with SOC 2 scope excluding SSO and revisit in Q4.
> Ask: Decision needed by [date] to avoid delaying the broader compliance timeline.

If no decisions are needed, the section reads: *"No decisions required from leadership this period."* — it is never omitted, because its absence is also signal.

## Output Format

The skill saves the update as `stakeholder-update-[date].md` in the current project directory, using today's date.

```markdown
# Stakeholder Update — [Date]

**Status: [ON TRACK / AT RISK / BLOCKED]**
**Period:** [Sprint name or date range]
**Owner:** [PM name if provided]

---

## Shipped This Period

- **[Item 1]:** [What shipped and the concrete result. Link to OKR if applicable.]
- **[Item 2]:** [What shipped and the concrete result.]
- **[Item 3]:** [What shipped and the concrete result.]

---

## OKR Progress

| Objective | Key Result | Baseline | Current | Target | Status |
|---|---|---|---|---|---|
| [O1 short label] | [KR 1.1 short label] | [value] | [value] | [value] | On Track |
| [O1 short label] | [KR 1.2 short label] | [value] | [value] | [value] | At Risk |
| [O2 short label] | [KR 2.1 short label] | [value] | [value] | [value] | On Track |

---

## Risks & Blockers

- **[Risk/Blocker]:** [One sentence description. Impact if unresolved. Timeline.]

---

## Decisions Needed from Leadership

**[Decision title]**
Context: [One sentence.]
Options: (A) [Option A]. (B) [Option B]. (C) [Option C if applicable].
Ask: [Specific action from leadership, and deadline.]

---

## Next Period Focus

[1–2 sentences on what the team is prioritising next period and why.]
```

If there are no risks or blockers, that section reads: "None this period." If there are no decisions needed, that section reads: "No decisions required from leadership this period." Neither section is ever omitted — their absence is meaningful signal.

## Tone Rules

The stakeholder update has a specific voice that differs from other PM documents. These rules are non-negotiable.

- **Lead with signal, not activity** — the first thing leadership reads is the status signal and what shipped. Not "the team worked hard this sprint", not a list of meetings, not a summary of process. Signal first, then evidence.
  - Good: *"On Track: activation rate reached 28%, CSV export shipped, mobile crash fixed."*
  - Bad: *"The team had a productive sprint and worked on several important initiatives."*

- **Numbers over adjectives** — "activation rate increased from 22% to 28%" is more useful than "activation rate improved significantly". If a number is not available, say so and say when it will be: *"Impact measurement in progress — results by [date]."* Do not substitute adjectives for absent data.

- **One page maximum** — the entire document should fit on one screen without scrolling. Leadership reads many updates; brevity is respect. If the content genuinely requires more, it goes in an appendix linked at the bottom, not in the body of the update.

- **Decisions Needed must be explicit** — leadership should not have to infer what you are asking. Every item in the Decisions section has a clear context, options, and a specific ask. Vague asks ("your thoughts on the SSO situation") are rewritten as specific decisions before the document is saved.

## How to Trigger

Ask your assistant to write a stakeholder update by saying things like:

- "Write a stakeholder update for leadership based on this sprint"
- "Draft my weekly PM update for this week"
- "Write a status update for leadership — here's what shipped"
- "What should I tell leadership this week?"
- "Write my monthly PM report based on our OKR progress"
- "I just finished the sprint review — now write the stakeholder update"

This skill will automatically, run the four-step process, and save the result as `stakeholder-update-[date].md` in your project directory.
