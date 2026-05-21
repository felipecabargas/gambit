---
name: synthesize-user-research
description: |
  Synthesize raw user research (interview notes, survey results, support tickets, NPS verbatims)
  into structured insights: themes, pain points, jobs-to-be-done, and research gaps.

  Use this skill when you need to make sense of qualitative research data before writing a feature
  request or building personas. Trigger on: "synthesize my research", "what are the themes in these
  interviews", "extract insights from this feedback", "summarize what users are saying", "pull out
  the key themes from this data", or when someone pastes raw research notes.
compatibility: "Requires filesystem access to project directory. Works best with markdown and text research documents."
version: 1.0.0
argument-hint: "[paste research notes or describe what you have]"
allowed-tools: [Read, Write, Bash]
---

# User Research Synthesizer

## When to Use

Use this skill whenever you have raw qualitative data that needs to be shaped into actionable product insights. It adds the most value when:

- **Before writing a feature request** — surface the real user problems before jumping to a solution
- **Before building personas** — ground personas in observed behaviour, not assumptions
- **After conducting user interviews** — turn scattered notes into structured themes while context is fresh
- **Auditing assumptions before planning** — validate that your roadmap priorities reflect actual user pain, not internal guesses
- **After a support ticket review** — find patterns across many individual complaints to identify systemic issues
- **After an NPS or CSAT campaign** — extract meaning from open-text verbatims that quantitative scores can't capture

## Input Format

The skill accepts research data in any of the following formats. You can paste content directly into the chat, provide a file path, or combine both.

**Free-form interview notes:**
```
Participant 3 — 2026-04-12
"I always have to export to a spreadsheet to do anything useful with the data.
The filters just don't go deep enough."
[Observation: workaround behaviour — manual export as daily habit]
Works at a 200-person logistics company, ops team.
```

**Survey verbatims:**
```
Q: What is the biggest frustration with the current product?
- "Finding old projects takes forever. There's no search."
- "I wish I could share a view with my clients without giving them full access."
- "The mobile experience is unusable. I only use it on desktop."
```

**NPS comments:**
```
Score: 6 — "The core idea is great but onboarding took us two weeks. Way too long."
Score: 9 — "Love the integrations, wish the reporting was stronger."
Score: 4 — "Support response times are too slow and docs are out of date."
```

**Support ticket exports (CSV or plain text):**
```
#1042 | Category: Data export | "Unable to export more than 500 rows — is this a limit or a bug?"
#1089 | Category: Permissions | "Need to give read-only access to a contractor, can't find how."
#1091 | Category: Data export | "Export button does nothing on Firefox."
```

**Mixed or unstructured notes** — the skill will parse and segment whatever you provide.

## How It Works

The skill follows a five-step synthesis process, designed to move from raw observation to validated insight without hallucinating meaning the data does not contain.

### Step 1 — Read and Segment by Source
The skill reads all input and groups every piece of data by its origin: participant, survey response, ticket ID, NPS score band, or any available identifier. This preserves provenance so insights can be traced back to specific sources and the confidence level of each insight can be assessed honestly.

### Step 2 — Extract Raw Observations
From each segment, the skill extracts discrete, atomic observations — one per note. An observation is a concrete, neutral statement of what a user said, did, or reported. No interpretation yet. Every observation is tagged with its source identifier.

Example observation: `[P3] Uses daily manual export to spreadsheet as workaround for insufficient filter depth.`

### Step 3 — Cluster by Affinity
Observations are grouped into affinity clusters: sets of observations that point at the same underlying behaviour, frustration, workflow, or need. Clusters are named descriptively. Observations that do not cluster are retained as singletons and flagged — they may represent edge cases or emerging signals.

### Step 4 — Derive Insights and JTBD Statements
From each cluster, the skill derives:
- A **theme insight**: a concise statement of what the cluster reveals about user needs or behaviour
- A **Jobs-to-be-Done (JTBD) statement**: the functional job the user is trying to accomplish, written in the standard format: *"When [situation], I want to [motivation], so I can [expected outcome]."*

Insights are labelled by confidence: **Validated** (supported by 3 or more independent sources) or **Observed** (supported by 1–2 sources). Only validated insights are presented as established findings.

### Step 5 — Identify Research Gaps
The skill explicitly lists the questions the data cannot answer. These are questions that arose during synthesis but have no supporting evidence in the input — areas where assumptions are being made, where only one participant was heard, or where conflicting signals exist. Research gaps are presented as a prioritised list of follow-up questions.

## Output Format

The skill saves the synthesis as `research-synthesis-[slug].md` in the current project directory, where `[slug]` is a short kebab-case label derived from the research topic (e.g. `research-synthesis-onboarding-2026-q1.md`). The output follows this structure:

```markdown
# Research Synthesis: [Topic]

**Sources:** [N] participants / [N] surveys / [N] tickets  
**Date synthesised:** [date]  
**Confidence key:** Validated = 3+ independent sources · Observed = 1–2 sources

---

## Themes

### 1. [Theme Name] — Validated
**Frequency:** [N] of [N] sources  
**Severity:** High / Medium / Low  
**Summary:** One-sentence summary of the insight.  
**Evidence:**
- [P2]: "Direct quote or paraphrase supporting this theme."
- [P5]: "Another supporting quote."
- [Ticket #1042]: Description of supporting signal.

---

## Jobs-to-be-Done

### JTBD 1: [Short label]
**Job statement:** "When [situation], I want to [motivation], so I can [expected outcome]."  
**Confidence:** Validated  
**Context:** Where and how this job arises in the user's workflow.  
**Evidence sources:** P2, P5, Survey Q3 (×4 respondents)

---

## Pain Points

Ranked by frequency across all sources.

| # | Pain Point | Frequency | Confidence | Representative Quote |
|---|---|---|---|---|
| 1 | [Pain point label] | [N]/[N] sources | Validated | "Exact user quote." |
| 2 | [Pain point label] | [N]/[N] sources | Observed | "Exact user quote." |

---

## Research Gaps

The following questions are **not answered** by the current data and should be investigated before building.

1. **[Gap label]** — [Why this matters and what evidence is missing.]
2. **[Gap label]** — [What conflicting signals exist and what would resolve them.]
3. **[Gap label]** — [Which user segment is underrepresented in the current data set.]
```

## Quality Rules

These rules ensure the synthesis is trustworthy and honest about its own limitations.

- **Validated vs. Observed**: An insight is Validated only when it is supported by 3 or more *independent* sources (different participants, different channels). An insight supported by only 1–2 sources is labelled Observed. Never promote an Observed insight to Validated.
- **No single-point generalisation**: If only one participant mentioned something, do not write "users struggle with X." Write "one participant reported X" and flag it as a research gap requiring follow-up.
- **No invented insights**: Never add themes, pain points, or JTBD statements that are not traceable to the input data. If an insight feels obvious but has no evidence in the notes, list it explicitly as a research gap, not as a finding.
- **Preserve verbatims**: Always include at least one direct quote per theme and per pain point. Paraphrases must be clearly marked as such. Quotes must not be altered to change their meaning.
- **Surface contradictions**: When two sources say opposite things, do not average them away. Report both signals, note the contradiction, and list it as a research gap.
- **Scope the synthesis**: If the input only covers one user segment, product area, or time period, state that explicitly in the output header. Never imply the findings represent all users.

## Example

**Raw note (before):**
```
Interview with P4 — enterprise ops manager, 400-person company
"Every Monday I have to pull the weekly report manually because the scheduled 
export never works reliably. I've raised a ticket twice but nothing changed. 
It's not blocking but it's just death by a thousand cuts."
[Note: mentioned workaround used by two other people on their team as well]
```

**Synthesised insight (after):**

**Theme: Unreliable scheduled exports force manual workaround — Observed**
Frequency: 2 of 8 sources | Severity: Medium
Summary: Enterprise users with weekly reporting cadences cannot rely on scheduled exports, creating a recurring manual task that erodes trust in the product.
Evidence: [P4]: "Every Monday I have to pull the weekly report manually because the scheduled export never works reliably." (Team of 3 affected per participant report)

**JTBD:** "When my team's weekly reporting is due, I want scheduled exports to run reliably without intervention, so I can spend Monday morning on analysis rather than data collection."

**Research gap:** Only reported by enterprise tier. Is this a segment-specific configuration issue or a platform-wide reliability problem? Needs investigation with 3+ additional enterprise accounts before prioritising a fix.

## How to Trigger

Ask your assistant to synthesise user research by saying things like:

- "Synthesize my research" followed by pasting your notes
- "What are the themes across these user interviews?"
- "Extract insights and pain points from this feedback"
- "Summarize what users are saying about onboarding"
- "Pull out the key themes from this NPS data"
- "Here are my support tickets — what patterns do you see?"

This skill will automatically, run the five-step synthesis process, and save the results as a structured markdown file in your project directory.
