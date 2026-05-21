---
name: build-user-persona
description: |
  Build evidence-backed user personas from research inputs. Creates structured persona documents
  grounded in evidence, with each attribute clearly labeled as research-validated or inferred.

  Use this skill when you need personas for an FR, strategy doc, or design brief. Trigger on:
  "build a persona", "create user personas from this research", "who are our users", "describe
  our target user", "make a persona for [segment]", or when synthesised research is ready and
  needs a persona layer.
compatibility: "Requires filesystem access to project directory. Works best with research synthesis docs or raw interview notes."
version: 1.0.0
argument-hint: "[paste research or path to synthesis doc]"
allowed-tools: [Read, Write, Bash]
---

# User Persona Builder

## When to Use

Use this skill whenever you need to crystallise who you are building for. It adds the most value when:

- **Before writing a feature request** — ground the problem statement in a concrete user so the FR doesn't describe a product for a hypothetical person
- **Before authoring a product strategy** — establish the user segments the strategy is designed to serve before debating priorities
- **When onboarding new team members** — give engineers, designers, and stakeholders a shared mental model of users that is traceable to real data, not opinions
- **When aligning design and engineering on who they're building for** — prevent scope creep caused by different people imagining different users
- **After running `synthesize-user-research`** — when a synthesis doc is ready, use this skill to add the persona layer that makes themes and pain points actionable
- **Before a design review** — ensure design decisions can be evaluated against a named persona, not "users in general"

## Input Format

The skill accepts research data in any of the following formats. You can paste content directly into the chat, provide a file path, or combine both.

**Research synthesis document (output of `synthesize-user-research`):**
```
# Research Synthesis: Onboarding 2026-Q1
Sources: 8 participants / 200 surveys / 42 tickets
Themes:
  1. Manual export workaround — Validated (6/8 sources)
  2. Permissions confusion — Validated (5/8 sources)
  ...
```

**Raw interview notes:**
```
Participant 2 — ops manager, 300-person logistics firm
"I'm in the product every day but only for about 15 minutes. I need to see the
status of our three main workflows at a glance — I don't have time to dig in."
[Observation: primary use case is status monitoring, not configuration]
```

**Survey data with open-text responses:**
```
Role: Head of Operations (42% of respondents)
Primary job: Monitor workflow health across teams
Top frustration: "Too many clicks to see what I actually care about"
Top need: "A summary view I can check in under a minute"
```

**Free-form description of a user segment:**
```
We think our main users are operations managers at mid-market companies who
care about workflow visibility but don't do configuration themselves — that's
handled by their IT team. They mostly check in daily and escalate blockers.
```

**Mixed or unstructured notes** — the skill will parse and segment whatever you provide, then ask clarifying questions if the data is too thin to produce a credible persona.

## How It Works

The skill follows a four-step process designed to move from raw evidence to a credible, honest persona document without inflating sparse data into false confidence.

### Step 1 — Identify Distinct User Segments

Read all input and identify the user segments present in the data. Segment by **role, workflow context, and primary goal** — not by demographics. A "segment" is a cluster of users who are trying to accomplish the same job in the same context. Good segment signals:

- Different job titles that appear repeatedly across multiple sources
- Distinct use frequencies ("checks daily" vs. "runs quarterly reports")
- Clearly different primary goals ("monitors status" vs. "configures settings")
- Different relationships to the product (end-user vs. admin vs. buyer)

If the data clearly supports only one segment, produce one persona. Do not manufacture segment diversity.

### Step 2 — Build the Attribute Map for Each Segment

For each identified segment, extract the following attributes from the evidence:

- **Goals & Motivations** — what the user is trying to achieve (functional and emotional)
- **Pain Points** — what frustrates or blocks them in their current workflow
- **Jobs-to-be-Done** — the core job statements in "When / I want / so I can" format
- **Behaviours & Workarounds** — what users actually do, including hacks and coping strategies
- **Context** — when, where, and how frequently they interact with the product
- **Representative Quote** — the best direct quote that captures the segment's perspective

### Step 3 — Label Every Attribute by Evidence Strength

Every attribute in the persona must carry one of three evidence labels. These labels appear inline, immediately after the attribute heading or value.

- **Research-validated** — supported by 3 or more independent sources (different participants, different channels). Write it as a confident, present-tense statement.
- **Inferred** — supported by 1–2 sources. Write it as a probable pattern, not a certainty. Example: "Likely checks the dashboard at start-of-day."
- **Assumed** — no supporting evidence in the current data. Based on product intuition or general domain knowledge. Must be flagged explicitly.

Never omit the label. An unlabelled attribute is treated as assumed.

### Step 4 — Surface All Assumed Attributes as Open Questions

After building each persona, collect every attribute labelled as Assumed and rewrite it as a specific research question. These questions appear in the "Assumptions to Validate" section at the bottom of each persona file. They become the immediate input to the next round of discovery.

## Output Format

The skill saves one file per persona as `personas/[persona-slug].md` in the current project directory, where `[persona-slug]` is a short kebab-case name derived from the persona's role (e.g. `personas/ops-manager.md`). Each file follows this template exactly:

```markdown
# Persona: [Name]
> [One-sentence summary of who this person is and why they matter to the product]

**Confidence key:** Research-validated = 3+ independent sources · Inferred = 1–2 sources · Assumed = no data

---

## Role & Context
**Role:** [Job title or functional role]  
**Organisation type:** [Company size / industry / team structure]  
**Product relationship:** [End-user / Admin / Buyer / Occasional user]  
**Use frequency:** [Daily / Weekly / Event-driven]  
*Evidence label: [Research-validated / Inferred / Assumed]*

---

## Goals & Motivations
- **Primary goal:** [What they are ultimately trying to achieve] — *[label]*
- **Secondary goal:** [Supporting objective] — *[label]*
- **Emotional driver:** [What makes them feel successful or anxious] — *[label]*

---

## Pain Points
- [Pain point 1] — *[label]*
- [Pain point 2] — *[label]*
- [Pain point 3] — *[label]*

---

## Jobs-to-be-Done
**JTBD 1:** "When [situation], I want to [motivation], so I can [expected outcome]." — *[label]*  
**JTBD 2:** "When [situation], I want to [motivation], so I can [expected outcome]." — *[label]*

---

## Behaviours & Workarounds
- [Observed behaviour or coping strategy] — *[label]*
- [Workaround that signals an unmet need] — *[label]*

---

## Representative Quote
> "[Direct quote from research that best captures this persona's perspective.]"
> — [Source identifier, e.g. P3 / Survey respondent / Support ticket #1042]

---

## Evidence Sources
| Source | Type | Contribution |
|--------|------|--------------|
| [P2, P5, P7] | Interview | Goals, pain points, JTBD 1 |
| [Survey Q4 ×14] | Survey | Use frequency, primary goal |
| [Ticket #1042, #1089] | Support | Pain point 2 |

---

## Assumptions to Validate
These attributes have no supporting evidence and must be tested before using this persona to drive design or prioritisation decisions.

1. **[Assumed attribute]** — Research question: [Specific question to ask in the next interview or survey.]
2. **[Assumed attribute]** — Research question: [What you would need to see to confirm or refute this assumption.]
```

## Anti-Patterns

The following patterns undermine persona credibility. Each comes with a bad example and a corrected rewrite.

**1. Stock-photo demographics — age, gender, income, family status unless evidenced**

Bad:
> "Sarah, 34, married with two kids, earns $95k. She enjoys hiking on weekends."

Why it's wrong: None of these attributes predict product behaviour. They introduce demographic bias and give the team permission to imagine a specific kind of person, excluding everyone who doesn't match the description.

Good:
> "Ops Manager at a 200–500-person logistics firm. Checks the product daily for 10–15 minutes. Primary concern is workflow status visibility across three teams." — *Research-validated*

**2. Filler lifestyle details with no product relevance**

Bad:
> "Marcus loves craft coffee and listens to podcasts during his commute. He's tech-savvy but prefers minimal interfaces."

Why it's wrong: "Tech-savvy" and "prefers minimal interfaces" are meaningless without evidence. "Loves craft coffee" is noise.

Good:
> "Completes most product tasks on mobile because desktop access is blocked by IT policy." — *Inferred (2 sources)*
> "Prefers task completion over feature discovery — skips onboarding tooltips." — *Assumed — needs validation*

**3. Confidently stated attributes with no evidence label**

Bad:
> "Alex checks the dashboard every morning and shares reports with her director every Friday."

Why it's wrong: Reads as established fact but may be one participant's habit presented as universal behaviour.

Good:
> "Checks the dashboard at the start of the workday." — *Inferred (2 sources)*
> "Shares weekly reports with a manager or director." — *Assumed — needs validation*

**4. Single-source generalisation**

Bad:
> "Users rely on manual exports because the scheduling feature is broken."

Why it's wrong: One participant's experience is presented as a universal user behaviour.

Good:
> "One participant (P4) reported using manual export every Monday because scheduled exports failed unreliably. This is Observed, not Validated — confirm with at least 2 additional sources before treating as a product-wide pain point."

**5. Merging distinct segments into one persona**

Bad: Describing both the daily ops manager and the quarterly auditor as the same persona because they both "use the reports section."

Why it's wrong: These users have opposite needs — one needs speed and a summary view, the other needs depth and drilldown. A persona that tries to serve both serves neither.

Good: Create two separate personas with clear segment boundaries. If you only have evidence for one, build one and flag the second as a research gap.

## Example

The following is a complete persona entry showing evidence labels applied throughout.

---

**Persona: Ops Manager**
> The daily operator who monitors workflow health across teams and escalates blockers — the user who opens the product first thing every morning.

**Confidence key:** Research-validated = 3+ independent sources · Inferred = 1–2 sources · Assumed = no data

---

**Role & Context**  
Role: Operations Manager or Head of Operations  
Organisation type: Mid-market (200–500 employees), logistics or professional services  
Product relationship: Primary end-user (not admin, not buyer)  
Use frequency: Daily, 10–15 minute sessions  
*Research-validated — reported by 6 of 8 interview participants and confirmed in survey segment analysis*

**Goals & Motivations**  
- Primary goal: Know the status of critical workflows without digging through multiple views — *Research-validated*
- Secondary goal: Surface and escalate blockers to their team before they become incidents — *Research-validated*
- Emotional driver: Feels accountable for things they did not cause and anxious when they cannot see what is happening — *Inferred (3 sources, but framing is interpretive)*

**Pain Points**  
- Cannot see a consolidated status view — must open three separate sections to assess overall health — *Research-validated*
- Scheduled export failures force a manual workaround every Monday — *Inferred (2 sources)*
- Mobile experience is too limited to act on alerts away from desk — *Assumed — no mobile usage data collected*

**Jobs-to-be-Done**  
JTBD 1: "When I start my workday, I want to see the status of all active workflows at a glance, so I can prioritise my first hour and know what to escalate." — *Research-validated*  
JTBD 2: "When a workflow falls behind, I want to share a status update with my director without leaving the product, so I can keep leadership informed without manual reporting." — *Inferred (2 sources)*

**Behaviours & Workarounds**  
- Exports data to a personal spreadsheet to build a summary view the product does not provide — *Research-validated*
- Uses Slack to send screenshots of product screens to their director as status updates — *Inferred (2 sources)*
- Skips the onboarding tour and navigates by memory — *Assumed — no onboarding observation data*

**Representative Quote**  
> "I need to know if anything is broken in under a minute. If I have to click more than twice, I've already lost that time."  
> — P6, Head of Operations, 350-person professional services firm

**Evidence Sources**  
| Source | Type | Contribution |
|--------|------|--------------|
| P2, P3, P6, P7, P8 | Interview | Goals, pain points, JTBD 1, behaviours |
| Survey Q4 ×14 respondents | Survey | Use frequency, primary goal |
| Ticket #1042, #1089 | Support | Scheduled export failure pain point |

**Assumptions to Validate**  
1. Mobile usage limitation — Research question: Do ops managers regularly attempt to use the product on mobile, or is mobile access not part of their workflow at all? Validate in the next round of interviews by asking about device usage patterns explicitly.
2. Director reporting behaviour — Research question: How frequently do ops managers share product data with managers or directors, and what format do they use? Validate by including a Likert-scale question in the next survey.
3. Skipping onboarding — Research question: Is onboarding completion low for this segment? Validate by pulling onboarding completion rates from analytics, segmented by job role.

---

## How to Trigger

Ask your assistant to build user personas by saying things like:

- "Build a persona from this research synthesis"
- "Create user personas from these interview notes"
- "Who are our users? Here's the research we have."
- "Describe our target user for this feature request"
- "Make a persona for the ops manager segment"
- "Turn this synthesised research into personas we can use for the design brief"

This skill will automatically, run the four-step process, and save each persona as a structured markdown file in the `personas/` directory of your project.
