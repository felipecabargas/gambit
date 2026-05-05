# Gambit v2 — Skills & Agents Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 8 new standalone skills and 4 chained workflow agents to Gambit, turning it into a full PM workflow engine.

**Architecture:** Skills are added as individual `SKILL.md` files under `skills/<skill-name>/SKILL.md`. Agents follow the same format under `agents/<agent-name>/SKILL.md`. Each skill is independent; agents reference their component skills by name and orchestrate them in sequence. Documentation (README, CLAUDE.md, skill-framework.md) is updated at the end.

**Tech Stack:** Markdown skill files, YAML frontmatter, bash validation script.

---

## File Structure

**Create:**
- `scripts/validate-skill.sh` — validates a SKILL.md file has required frontmatter and sections
- `skills/synthesize-user-research/SKILL.md`
- `skills/build-user-persona/SKILL.md`
- `skills/competitive-analysis/SKILL.md`
- `skills/write-technical-brief/SKILL.md`
- `skills/write-okrs/SKILL.md`
- `skills/write-roadmap/SKILL.md`
- `skills/write-release-notes/SKILL.md`
- `skills/write-stakeholder-update/SKILL.md`
- `agents/discovery-to-fr/SKILL.md`
- `agents/fr-to-ready/SKILL.md`
- `agents/strategy-to-roadmap/SKILL.md`
- `agents/sprint-to-stakeholders/SKILL.md`

**Modify:**
- `README.md` — add new skills and agents sections
- `CLAUDE.md` — add new skill and agent names to available skills list
- `docs/skill-framework.md` — add agent pattern documentation
- `package.json` — bump version to 2.0.0

---

## Phase 0 — Validation Tooling

### Task 0: Write skill validation script

**Files:**
- Create: `scripts/validate-skill.sh`

- [ ] **Step 1: Create the validation script**

```bash
#!/usr/bin/env bash
set -e

SKILL_FILE=$1
if [ -z "$SKILL_FILE" ]; then
  echo "Usage: $0 <path-to-SKILL.md>"
  exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
  echo "ERROR: File not found: $SKILL_FILE"
  exit 1
fi

# Frontmatter must open and close with ---
DELIMITERS=$(grep -c "^---$" "$SKILL_FILE" || true)
if [ "$DELIMITERS" -lt 2 ]; then
  echo "ERROR: Missing frontmatter delimiters (---) in $SKILL_FILE"
  exit 1
fi

# Required frontmatter fields
for field in name description compatibility version argument-hint allowed-tools; do
  if ! grep -q "^$field:" "$SKILL_FILE"; then
    echo "ERROR: Missing required frontmatter field '$field' in $SKILL_FILE"
    exit 1
  fi
done

# Required body sections (skills)
for section in "## When to Use" "## How" "## Output"; do
  if ! grep -q "$section" "$SKILL_FILE"; then
    echo "WARNING: Expected section '$section' not found in $SKILL_FILE"
  fi
done

echo "✓ $SKILL_FILE — valid"
```

- [ ] **Step 2: Make it executable and run it on an existing skill to confirm it works**

```bash
chmod +x scripts/validate-skill.sh
./scripts/validate-skill.sh skills/verify-acceptance-criteria/SKILL.md
```

Expected output: `✓ skills/verify-acceptance-criteria/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add scripts/validate-skill.sh
git commit -m "chore: add skill validation script"
```

---

## Phase 1 — Discovery Skills (closes #6, #7, #8)

> These three skills unlock the `discovery-to-fr` agent. Write them before any agent work.

### Task 1: synthesize-user-research (closes #6)

**Files:**
- Create: `skills/synthesize-user-research/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

The file must open with this exact frontmatter:

```yaml
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
```

The body must include these sections, following the skill-framework.md design pattern:

1. **## When to Use** — list the scenarios where this skill adds value (before writing an FR, before building personas, after conducting user interviews, auditing assumptions before planning)
2. **## Input Format** — accepts: free-form interview notes, survey verbatims, NPS comments, support ticket exports, paste or file path
3. **## How It Works** — describe the five-step process:
   - Step 1: Read and segment all input by source/participant
   - Step 2: Extract raw observations (one per note)
   - Step 3: Cluster observations into themes by affinity
   - Step 4: Derive insights and JTBD statements from clusters
   - Step 5: Identify research gaps (questions the data cannot answer)
4. **## Output Format** — the skill saves `research-synthesis-[slug].md` with:
   - **Themes** (each with: name, frequency, supporting evidence, severity)
   - **Jobs-to-be-Done** (each with: job statement, context, evidence)
   - **Pain Points** (top N, ranked by frequency, each with a representative quote)
   - **Research Gaps** (what would need to be answered before building)
5. **## Quality Rules** — distinguish validated (3+ sources) from observed (1-2 sources); never generalise from a single data point without flagging it; never add insights not in the source data
6. **## Example** — show a short before (raw note) / after (synthesised insight) pair
7. **## How to Trigger** — list 5-6 natural language trigger phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/synthesize-user-research/SKILL.md
```

Expected: `✓ skills/synthesize-user-research/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/synthesize-user-research/SKILL.md
git commit -m "feat: add synthesize-user-research skill (closes #6)"
```

---

### Task 2: build-user-persona (closes #7)

**Files:**
- Create: `skills/build-user-persona/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
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
```

Required body sections:

1. **## When to Use** — before writing an FR that needs user context, when onboarding new team members, when aligning design and engineering on who they're building for
2. **## Input Format** — research synthesis doc (from `synthesize-user-research`), raw interview notes, survey data, or a free-form description of a user segment
3. **## How It Works** — four steps:
   - Step 1: Identify distinct user segments from the research (by role, context, goal — not demographics)
   - Step 2: For each segment, build the attribute map from evidence
   - Step 3: Label each attribute: ✅ Research-validated (3+ sources) / ⚠️ Inferred (1-2 sources) / ❓ Assumed (no data)
   - Step 4: Surface all ❓ Assumed attributes as open questions to validate
4. **## Output Format** — saves `personas/[persona-slug].md` per persona with: Name (fictional, role-based not demographic), Role & Context, Goals & Motivations, Pain Points, Jobs-to-be-Done, Behaviours & Workarounds, Representative Quote, Evidence Sources, Assumptions to Validate
5. **## Anti-Patterns** — no stock-photo demographics (age/gender/income unless evidenced); no "she loves hiking" filler; every attribute needs a source or an ❓ flag
6. **## Example** — show one complete persona entry with evidence labels
7. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/build-user-persona/SKILL.md
```

Expected: `✓ skills/build-user-persona/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/build-user-persona/SKILL.md
git commit -m "feat: add build-user-persona skill (closes #7)"
```

---

### Task 3: competitive-analysis (closes #8)

**Files:**
- Create: `skills/competitive-analysis/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
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
```

Required body sections:

1. **## When to Use** — entering a new market, refreshing strategy, validating differentiation, preparing for a board or investor review
2. **## Input Format** — competitor names + URLs, your product context (who you serve, what you do), optional: evaluation dimensions you care about
3. **## Phase 1: Scope** — the skill asks: which dimensions matter most? (pricing, features, UX, integrations, market segment, support, compliance). Default dimensions if none given: Core Capabilities, Pricing Model, Target Segment, Key Differentiators, Weaknesses
4. **## Phase 2: Analysis** — for each competitor: profile (positioning, target user, business model), capability assessment per dimension, strengths and weaknesses
5. **## Phase 3: Synthesis** — comparison matrix, whitespace map (unserved segments or unmet needs), strategic implications (where to differentiate, what to avoid)
6. **## Output Format** — saves `COMPETITIVE-ANALYSIS.md` with: Executive Summary, Competitor Profiles, Comparison Matrix table, Whitespace Opportunities, Strategic Implications
7. **## Quality Rules** — distinguish public information from assumptions; flag anything that needs validation; connect every whitespace finding to a strategic implication
8. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/competitive-analysis/SKILL.md
```

Expected: `✓ skills/competitive-analysis/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/competitive-analysis/SKILL.md
git commit -m "feat: add competitive-analysis skill (closes #8)"
```

---

## Phase 2 — Handoff & Communication Skills (closes #9, #10, #11, #12, #13)

### Task 4: write-technical-brief (closes #13)

**Files:**
- Create: `skills/write-technical-brief/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: write-technical-brief
description: |
  Write an engineering handoff document from a verified Feature Request. Covers scope boundaries,
  technical constraints, edge cases with recommended handling, open questions engineering needs
  answered, and integration points. Bridges PM spec and engineering without designing the solution.

  Trigger on: "write a technical brief", "help me hand this off to engineering", "what does eng
  need to know to build this", "create a technical handoff doc", "make this FR ready for the
  engineering team", or at the end of a feature request authoring session.
compatibility: "Requires filesystem access to project directory. Works best with Feature Request markdown docs."
version: 1.0.0
argument-hint: "[paste FR or path to FR file]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## When to Use** — after an FR is written and ACs are verified, before handing to engineering, when starting a sprint and realising the spec has gaps
2. **## Input Format** — a Feature Request markdown doc (from `write-feature-request`) or a pasted FR description; optionally, existing technical notes or architecture context
3. **## How It Works** — five steps:
   - Step 1: Read the FR and identify all requirements and ACs
   - Step 2: Derive scope (what is and is not in this implementation, explicitly)
   - Step 3: Identify constraints (technical, compliance, dependency, performance)
   - Step 4: Enumerate edge cases (scenarios ACs don't cover) and recommend handling for each
   - Step 5: Surface open questions (decisions engineering needs PM to make before starting)
4. **## Output Format** — saves `technical-brief-[feature-slug].md` with: Scope (In/Out), Constraints, Edge Cases table (Scenario | Recommended Handling | Open?), Open Questions for PM, Integration Points, Out of Scope (explicit list)
5. **## Key Rule** — does not design the solution; describes the problem space. Every "how should this work?" becomes an open question, not a decision
6. **## Length Target** — 1–2 pages. If it's longer, scope is too broad or there are too many unresolved open questions
7. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/write-technical-brief/SKILL.md
```

Expected: `✓ skills/write-technical-brief/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-technical-brief/SKILL.md
git commit -m "feat: add write-technical-brief skill (closes #13)"
```

---

### Task 5: write-okrs (closes #9)

**Files:**
- Create: `skills/write-okrs/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
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
```

Required body sections:

1. **## When to Use** — quarterly planning, aligning teams on what success looks like, translating a strategy into measurable commitments
2. **## Input Format** — STRATEGY.md (scanned automatically if present), pasted strategy pillars, or a description of strategic priorities; optionally, previous OKRs to build on
3. **## How It Works** — five steps:
   - Step 1: Read the strategy and identify 2–4 distinct pillars or bets
   - Step 2: Draft one Objective per pillar (qualitative, inspiring, time-bound)
   - Step 3: Draft 2–4 Key Results per Objective — ask for baseline and target if not provided
   - Step 4: Challenge each KR: is it an outcome (user/business result) or an output (thing you ship)? Rewrite outputs as outcomes
   - Step 5: Mark each KR as Committed (>70% confidence) or Stretch (<50% confidence)
4. **## Output Format** — saves `OKRs-[period].md` with: each O + KRs, confidence level, baseline → target, pillar link
5. **## Quality Rules** — max 4 Objectives; max 4 KRs per Objective; every KR must have a number (no "improve NPS", must be "increase NPS from 32 to 45"); KRs must be outcomes not outputs
6. **## Common Pitfalls** section — output KRs ("launch X feature"), vanity metrics ("increase page views"), KRs that are 100% within team control (not real stretch)
7. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/write-okrs/SKILL.md
```

Expected: `✓ skills/write-okrs/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-okrs/SKILL.md
git commit -m "feat: add write-okrs skill (closes #9)"
```

---

### Task 6: write-roadmap (closes #10)

**Files:**
- Create: `skills/write-roadmap/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
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
```

Required body sections:

1. **## When to Use** — starting a new planning cycle, communicating priorities to stakeholders, aligning engineering on what's coming
2. **## Input Format** — STRATEGY.md and/or OKRs (auto-scanned if present), pasted priorities, or a description of what you're trying to accomplish; optional: backlog items to place
3. **## Horizon Model** — explain Now (committed, in progress or imminent) / Next (next 1-2 quarters, directional) / Later (beyond that, exploratory); or quarterly if the user prefers dates
4. **## How It Works** — four steps:
   - Step 1: Read strategy pillars and OKRs to derive themes
   - Step 2: Assign themes to horizons based on strategic priority and known dependencies
   - Step 3: For each theme, describe the expected outcome (not a feature list)
   - Step 4: Mark each item: Committed (we're doing this) / Directional (current thinking, subject to change)
5. **## Output Format** — saves `ROADMAP.md` with: Introduction (strategy summary in 2 sentences), Now/Next/Later sections (each with themes, outcomes, commitment status), Explicitly Not Doing (what's out of scope and why), Open Dependencies
6. **## Key Rules** — no feature lists; themes only. No dates unless the user provides them. Every theme links to a strategy pillar or KR. "Explicitly Not Doing" section is required — roadmaps without explicit exclusions create scope creep
7. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/write-roadmap/SKILL.md
```

Expected: `✓ skills/write-roadmap/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-roadmap/SKILL.md
git commit -m "feat: add write-roadmap skill (closes #10)"
```

---

### Task 7: write-release-notes (closes #11)

**Files:**
- Create: `skills/write-release-notes/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: write-release-notes
description: |
  Convert sprint tickets and PRs into customer-facing release notes. Filters internal/infra work,
  rewrites ticket titles as user benefits, groups by category (New / Improved / Fixed), and adapts
  tone to the target channel.

  Trigger on: "write release notes", "turn these tickets into release notes", "what should we put
  in the changelog", "draft our release announcement", "write our changelog for [version]", or
  after a sprint-review session.
compatibility: "Requires filesystem access to project directory. Works best with sprint review docs or ticket lists."
version: 1.0.0
argument-hint: "[paste tickets/PRs or sprint name]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## When to Use** — after every sprint or release, when publishing a changelog, when preparing a product announcement
2. **## Input Format** — sprint review output (from `sprint-review`), ticket list, PR list, or pasted sprint summary; optionally, a channel context (in-app, email, public changelog, marketing)
3. **## Filtering Rules** — customer-visible only: exclude infra, refactors, dependency bumps, internal tooling, test changes, CI/CD. When in doubt, ask: "Would a customer notice if this wasn't shipped?" If no, exclude
4. **## How It Works** — four steps:
   - Step 1: Filter to customer-visible items only
   - Step 2: Rewrite each item title as a user benefit ("Refactor auth middleware" → "Faster, more reliable login")
   - Step 3: Group into New (new capabilities), Improved (enhancements to existing), Fixed (bug fixes)
   - Step 4: Write 2–3 sentence Highlights section for the most impactful items
5. **## Output Format** — saves `release-notes-[version-or-date].md` with: Version/date header, Highlights (2-3 sentences), New / Improved / Fixed groups
6. **## Tone Guidance** — in-app: concise, present tense ("You can now..."); email: slightly warmer, benefit-first; public changelog: neutral, factual; marketing: lead with customer impact
7. **## Never Do** — invent features; embellish impact; include implementation details in customer-facing copy
8. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/write-release-notes/SKILL.md
```

Expected: `✓ skills/write-release-notes/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-release-notes/SKILL.md
git commit -m "feat: add write-release-notes skill (closes #11)"
```

---

### Task 8: write-stakeholder-update (closes #12)

**Files:**
- Create: `skills/write-stakeholder-update/SKILL.md`

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
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
```

Required body sections:

1. **## When to Use** — weekly or monthly PM cadence, post-sprint leadership communication, escalation or risk communication to leadership
2. **## Input Format** — sprint review output, release notes, OKR progress (optional), any risks or decisions needed; freeform is fine
3. **## How It Works** — four steps:
   - Step 1: Determine overall status signal (On Track / At Risk / Blocked) based on OKR progress and blockers
   - Step 2: Identify 2–3 most impactful shipped items with concrete results (numbers preferred)
   - Step 3: Summarise OKR progress if available (current vs. target for each KR)
   - Step 4: Identify decisions or actions needed from leadership
4. **## Output Format** — saves `stakeholder-update-[date].md` with: Status signal (header line), Shipped This Period (2-3 bullets with impact), OKR Progress table (optional), Risks & Blockers, Decisions Needed from Leadership, Next Period Focus (1-2 sentences)
5. **## Tone Rules** — leads with signal not activity ("On Track: shipped X, Y, Z" not "The team worked hard on..."); numbers over adjectives; one page maximum; decisions needed section is explicit — leadership should not have to infer what you're asking
6. **## How to Trigger** — 5-6 natural language phrases

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh skills/write-stakeholder-update/SKILL.md
```

Expected: `✓ skills/write-stakeholder-update/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-stakeholder-update/SKILL.md
git commit -m "feat: add write-stakeholder-update skill (closes #12)"
```

---

## Phase 3 — Agents (closes #2, #3, #4, #5)

> Agents are written last — each one requires its component skills to exist first.
> Agent SKILL.md files live in `agents/<name>/SKILL.md`. They use the same frontmatter format but
> orchestrate other skills instead of performing a standalone task.

### Task 9: discovery-to-fr agent (closes #2)

**Files:**
- Create: `agents/discovery-to-fr/SKILL.md`

**Prerequisite:** Tasks 1, 2 (synthesize-user-research, build-user-persona) must be complete.

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: discovery-to-fr
description: |
  End-to-end research-to-spec workflow. Takes raw user research and produces a complete Feature
  Request with persona context — running synthesize-user-research, build-user-persona, and
  write-feature-request in sequence.

  Use when you have research data and want to go straight to a finished FR without managing
  each skill separately. Trigger on: "run discovery-to-fr", "turn my research into a feature
  request", "I have interview notes and need a feature spec", "go from research to FR",
  "full discovery pipeline".
compatibility: "Requires synthesize-user-research, build-user-persona, and write-feature-request skills to be installed."
version: 1.0.0
argument-hint: "[paste research notes or describe what you have]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## Overview** — explain this is a chained workflow, not a standalone skill; list the three component skills and what each produces
2. **## Chain**
   ```
   synthesize-user-research → build-user-persona → write-feature-request
   ```
3. **## How It Runs** — step-by-step:
   - Step 1: Run `synthesize-user-research` on the provided input. Save synthesis doc. Present key themes and JTBD to user for a quick sanity check before proceeding
   - Step 2: Run `build-user-persona` using the synthesis output. Present persona(s) to user for confirmation
   - Step 3: Run `write-feature-request` with the persona and key insights pre-loaded as context, so the guided FR conversation starts from a stronger foundation
   - Step 4: Present the completed FR bundle: synthesis doc, persona(s), and FR
4. **## Pause Points** — the agent pauses for user confirmation after each step before proceeding. Explain why: each output informs the next, and catching errors early saves time
5. **## Outputs** — three saved files: `research-synthesis-[slug].md`, `personas/[name].md`, and the FR in standard write-feature-request format
6. **## When to Use vs. Individual Skills** — use this agent when you're starting cold from raw research. Use individual skills when you only need one piece (e.g., you already have personas)

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh agents/discovery-to-fr/SKILL.md
```

Expected: `✓ agents/discovery-to-fr/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add agents/discovery-to-fr/SKILL.md
git commit -m "feat: add discovery-to-fr agent (closes #2)"
```

---

### Task 10: fr-to-ready agent (closes #3)

**Files:**
- Create: `agents/fr-to-ready/SKILL.md`

**Prerequisite:** Task 4 (write-technical-brief) must be complete.

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: fr-to-ready
description: |
  Feature-request-to-dev-ready workflow. Takes a raw feature idea or existing FR through authoring,
  AC verification, and engineering handoff — running write-feature-request, verify-acceptance-criteria,
  and write-technical-brief in sequence.

  Use when you want a complete, dev-ready handoff package in one session. Trigger on: "run
  fr-to-ready", "make this FR dev-ready", "I need a complete handoff package for this feature",
  "get this feature ready for engineering", "full FR pipeline".
compatibility: "Requires write-feature-request, verify-acceptance-criteria, and write-technical-brief skills to be installed."
version: 1.0.0
argument-hint: "[feature idea or paste existing FR]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## Overview** — three-skill chain that closes the gap between idea and dev-ready state
2. **## Chain**
   ```
   write-feature-request → verify-acceptance-criteria → write-technical-brief
   ```
3. **## How It Runs** — step by step:
   - Step 1: Run `write-feature-request` to produce the full FR with ACs (full guided conversation)
   - Step 2: Pass all ACs into `verify-acceptance-criteria`; auto-rewrite any that fail (critical/major issues); present diff to user for confirmation
   - Step 3: Run `write-technical-brief` using the verified FR as input; return the brief
   - Step 4: Present the bundle: FR, verification report, and technical brief
4. **## Pause Points** — pause after Step 1 (user reviews FR before AC verification) and after Step 2 (user approves rewrites before brief is written)
5. **## Outputs** — three files: FR in standard format, AC verification report, `technical-brief-[feature-slug].md`
6. **## When to Use vs. Individual Skills** — use the agent when starting from scratch or when you want the complete package. Use `verify-acceptance-criteria` alone to audit an existing FR

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh agents/fr-to-ready/SKILL.md
```

Expected: `✓ agents/fr-to-ready/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add agents/fr-to-ready/SKILL.md
git commit -m "feat: add fr-to-ready agent (closes #3)"
```

---

### Task 11: strategy-to-roadmap agent (closes #4)

**Files:**
- Create: `agents/strategy-to-roadmap/SKILL.md`

**Prerequisite:** Tasks 5, 6 (write-okrs, write-roadmap) must be complete.

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: strategy-to-roadmap
description: |
  Full strategy-to-execution workflow. Takes product context through strategy, OKRs, and roadmap —
  running write-product-strategy, write-okrs, and write-roadmap in sequence to produce three
  aligned planning documents.

  Use at the start of a planning cycle when you want all three artefacts built and aligned in one
  session. Trigger on: "run strategy-to-roadmap", "help me build our strategy and roadmap", "I
  need a full planning cycle", "take me from strategy to execution plan", "full strategy pipeline".
compatibility: "Requires write-product-strategy, write-okrs, and write-roadmap skills to be installed."
version: 1.0.0
argument-hint: "[product context or paste existing strategy]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## Overview** — three-skill chain that produces the complete planning artefact set
2. **## Chain**
   ```
   write-product-strategy → write-okrs → write-roadmap
   ```
3. **## How It Runs** — step by step:
   - Step 1: Run `write-product-strategy` (full guided session); save STRATEGY.md
   - Step 2: Feed strategy pillars and success criteria into `write-okrs`; challenge vague KRs; save OKRs-[period].md
   - Step 3: Feed strategy + OKRs into `write-roadmap` to produce horizon-based ROADMAP.md
   - Step 4: Present the complete set with a brief summary of how each document connects to the others
4. **## Pause Points** — pause after Step 1 (strategy review before deriving OKRs) and after Step 2 (OKR review before roadmap)
5. **## Outputs** — three files: `STRATEGY.md`, `OKRs-[period].md`, `ROADMAP.md`
6. **## When to Use vs. Individual Skills** — use the agent for a full planning cycle from scratch. Use individual skills to update one layer without regenerating the others

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh agents/strategy-to-roadmap/SKILL.md
```

Expected: `✓ agents/strategy-to-roadmap/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add agents/strategy-to-roadmap/SKILL.md
git commit -m "feat: add strategy-to-roadmap agent (closes #4)"
```

---

### Task 12: sprint-to-stakeholders agent (closes #5)

**Files:**
- Create: `agents/sprint-to-stakeholders/SKILL.md`

**Prerequisite:** Tasks 7, 8 (write-release-notes, write-stakeholder-update) must be complete.

- [ ] **Step 1: Write the SKILL.md**

Frontmatter:

```yaml
---
name: sprint-to-stakeholders
description: |
  Full sprint-to-communications workflow. Takes sprint data and produces all three stakeholder
  artefacts — running sprint-review, write-release-notes, and write-stakeholder-update in sequence.

  Use at the end of every sprint to produce the complete communication package in one run. Trigger
  on: "run sprint-to-stakeholders", "generate all my sprint comms", "write everything I need for
  end of sprint", "produce the full sprint communication package", "sprint comms pipeline".
compatibility: "Requires sprint-review, write-release-notes, and write-stakeholder-update skills to be installed."
version: 1.0.0
argument-hint: "[sprint name, number, or paste ticket list]"
allowed-tools: [Read, Write, Bash]
---
```

Required body sections:

1. **## Overview** — three-skill chain producing one internal + two external communication artefacts from a single sprint data input
2. **## Chain**
   ```
   sprint-review → write-release-notes → write-stakeholder-update
   ```
3. **## How It Runs** — step by step:
   - Step 1: Run `sprint-review` to produce the internal stakeholder report; save sprint-review-[slug].md
   - Step 2: Feed completed work list into `write-release-notes`, filtering to customer-visible items; save release-notes-[date].md
   - Step 3: Feed sprint review highlights + release notes into `write-stakeholder-update`; save stakeholder-update-[date].md
   - Step 4: Present all three artefacts with a summary of what each is for and who to send it to
4. **## Pause Points** — minimal; this chain is low-risk and the three outputs are largely independent. Pause only if sprint data is ambiguous (e.g., no clear sprint goal found)
5. **## Outputs** — three files: `sprint-review-[slug].md`, `release-notes-[date].md`, `stakeholder-update-[date].md`
6. **## When to Use vs. Individual Skills** — use the agent at sprint end for the full comms package. Use `sprint-review` alone for internal-only reviews. Use `write-release-notes` alone for patch releases that don't warrant a full review

- [ ] **Step 2: Validate**

```bash
./scripts/validate-skill.sh agents/sprint-to-stakeholders/SKILL.md
```

Expected: `✓ agents/sprint-to-stakeholders/SKILL.md — valid`

- [ ] **Step 3: Commit**

```bash
git add agents/sprint-to-stakeholders/SKILL.md
git commit -m "feat: add sprint-to-stakeholders agent (closes #5)"
```

---

## Phase 4 — Documentation & Housekeeping

### Task 13: Update README, CLAUDE.md, skill-framework.md, and package.json

**Files:**
- Modify: `README.md`
- Modify: `CLAUDE.md`
- Modify: `docs/skill-framework.md`
- Modify: `package.json`

- [ ] **Step 1: Update README.md**

Add a new **Agents** section after the existing **Skills Included** section, listing all four agents with their chain notation and a one-line description. Add the eight new skills to the **Skills Included** section, grouped under a **Discovery**, **Communication**, and **Handoff** subheading. Update the directory structure tree to include `agents/`.

- [ ] **Step 2: Update CLAUDE.md**

Add all eight new skills and four new agents to the **Available Skills** list. Use the same format as existing entries: `- **skill-name** (\`/gambit:skill-name\`) — one-line description`.

- [ ] **Step 3: Update docs/skill-framework.md**

Add a new **Agent Pattern** section explaining:
- What agents are (chained workflow orchestrators vs. standalone skills)
- Where they live (`agents/` directory)
- The pause-point convention (agent pauses for user confirmation between each step)
- How to reference component skills by name
- The four current agents and their chains

Update the **Integration Patterns** section to include the four new agent chains.

- [ ] **Step 4: Bump package.json version**

Change `"version": "1.0.0"` to `"version": "2.0.0"`.

- [ ] **Step 5: Validate all new skills and agents**

```bash
for f in skills/synthesize-user-research/SKILL.md \
          skills/build-user-persona/SKILL.md \
          skills/competitive-analysis/SKILL.md \
          skills/write-technical-brief/SKILL.md \
          skills/write-okrs/SKILL.md \
          skills/write-roadmap/SKILL.md \
          skills/write-release-notes/SKILL.md \
          skills/write-stakeholder-update/SKILL.md \
          agents/discovery-to-fr/SKILL.md \
          agents/fr-to-ready/SKILL.md \
          agents/strategy-to-roadmap/SKILL.md \
          agents/sprint-to-stakeholders/SKILL.md; do
  ./scripts/validate-skill.sh "$f"
done
```

Expected: 12 lines of `✓ ... — valid`

- [ ] **Step 6: Commit**

```bash
git add README.md CLAUDE.md docs/skill-framework.md package.json
git commit -m "docs: update docs and bump version to 2.0.0 for v2 release"
```
