# Gambit Context Augmentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Augment 9 Gambit SKILL.md files with silent context-gathering steps and lightweight Superpowers nudges at workflow transition points.

**Architecture:** Each skill gets a new step (Step 0 or Phase 0) that silently runs Bash/Read lookups before asking questions or producing output. Three skills additionally get a one-line Superpowers suggestion at a natural handoff moment. No new files are created; all changes are edits to existing SKILL.md bodies.

**Tech Stack:** Bash, markdown. Validation via `scripts/validate-skill.sh`.

---

### Task 1: write-technical-brief — context scan + end nudge

**Files:**
- Modify: `skills/write-technical-brief/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-technical-brief/SKILL.md
```
Expected: `✓ skills/write-technical-brief/SKILL.md — valid`

- [ ] **Step 2: Add Step 0 before "### Step 1 — Read the FR"**

Find the line `### Step 1 — Read the FR and Identify All Requirements and ACs` and insert the following block directly before it:

```markdown
### Step 0 — Scan Project for Architecture Context (silent)

Before reading the FR, silently scan the project for context that will enrich the constraints and integration points sections:

```bash
# Architecture docs
find . -maxdepth 3 \( -name "ARCHITECTURE.md" -o -name "architecture.md" -o -name "TECH-STACK.md" \) 2>/dev/null | head -5 | xargs cat 2>/dev/null
find . -maxdepth 3 -type d \( -name "adr" -o -name "architecture" \) 2>/dev/null | head -3
# Tech stack
cat README.md 2>/dev/null | head -80
cat package.json 2>/dev/null || cat Cargo.toml 2>/dev/null || cat go.mod 2>/dev/null
```

Use any found artefacts to:
- Populate **technical constraints** with confirmed platform and framework details
- Populate **integration points** with known existing systems
- Mark constraints derived from scanned files as **Confirmed** (not Assumed)

If nothing is found, continue from Step 1 as normal. Do not mention the scan to the user.

```

- [ ] **Step 3: Add end nudge after the Output Format section**

Find the `## Key Rule` section and insert the following block directly before it:

```markdown
## After Producing the Brief

Once the brief is saved, surface this to the user:

> "To route this to engineering for review, `/superpowers:requesting-code-review` walks through the handoff."

```

- [ ] **Step 4: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-technical-brief/SKILL.md
```
Expected: `✓ skills/write-technical-brief/SKILL.md — valid`

- [ ] **Step 5: Commit**

```bash
git add skills/write-technical-brief/SKILL.md
git commit -m "feat(write-technical-brief): add architecture context scan and review nudge"
```

---

### Task 2: sprint-review — git history scan

**Files:**
- Modify: `skills/sprint-review/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/sprint-review/SKILL.md
```
Expected: `✓ skills/sprint-review/SKILL.md — valid` (pre-existing warnings about missing sections are acceptable)

- [ ] **Step 2: Augment "## Step 1: Extract what you have" with git scanning**

Find the line `## Step 1: Extract what you have` and append the following block at the end of that section (before `## Step 2`):

```markdown
**Git history scan (automatic, if no ticket list provided):** If the user hasn't pasted tickets or mentioned a JIRA/GitHub source, silently run:

```bash
# Try sprint window from user input, fall back to last 2 weeks
git log --merges --oneline --since="2 weeks ago" 2>/dev/null | head -40
# Also try: since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null) && [ -n "$LAST_TAG" ] && git log --merges --oneline ${LAST_TAG}..HEAD 2>/dev/null | head -40
```

Use merge commit messages as the ticket list and proceed. Flag the source at the end of your message: *"Sprint data pulled from git history — let me know if anything is missing or should be excluded."*

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/sprint-review/SKILL.md
```
Expected: `✓ skills/sprint-review/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/sprint-review/SKILL.md
git commit -m "feat(sprint-review): add git history scan when no ticket list is provided"
```

---

### Task 3: write-release-notes — git history scan

**Files:**
- Modify: `skills/write-release-notes/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-release-notes/SKILL.md
```
Expected: `✓ skills/write-release-notes/SKILL.md — valid`

- [ ] **Step 2: Add Step 0 before "### Step 1 — Filter to Customer-Visible Items Only"**

Find the line `### Step 1 — Filter to Customer-Visible Items Only` and insert the following block directly before it:

```markdown
### Step 0 — Scan Git History for Merged Work (silent)

Before filtering tickets, check whether git history can provide the source data:

```bash
# Find last release tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
echo "Last release: $LAST_TAG"
# Merged PRs since last tag
[ -n "$LAST_TAG" ] && git log --merges --oneline ${LAST_TAG}..HEAD 2>/dev/null | head -40
# Fallback: last 4 weeks if no tags
git log --merges --oneline --since="4 weeks ago" 2>/dev/null | head -40
```

If the user hasn't provided a ticket list, use merge commit messages as the raw input and proceed to Step 1. If git history is empty or inaccessible, ask the user to paste the ticket list. Do not mention the scan.

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-release-notes/SKILL.md
```
Expected: `✓ skills/write-release-notes/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/write-release-notes/SKILL.md
git commit -m "feat(write-release-notes): add git history scan for auto-sourcing release items"
```

---

### Task 4: write-product-strategy — augment existing scan + start nudge

**Files:**
- Modify: `skills/write-product-strategy/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-product-strategy/SKILL.md
```
Expected: `✓ skills/write-product-strategy/SKILL.md — valid`

- [ ] **Step 2: Add Superpowers nudge before Phase 1**

Find the line `### Phase 1: Context Gathering (Automatic)` and insert the following block directly before it:

```markdown
> **Before starting:** If you haven't done a structured brainstorm yet, `/superpowers:brainstorming` can map the problem space before we commit to strategic direction.

```

- [ ] **Step 3: Replace the Phase 1 description body with explicit tool usage**

Find the existing Phase 1 body (the bullet list under "First, I'll scan your project directory...") and replace it with:

```markdown
### Phase 1: Context Gathering (Automatic)

Silently scan the project directory using Read and Bash:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | xargs cat 2>/dev/null
cat ROADMAP.md 2>/dev/null
find . -maxdepth 3 \( -name "COMPETITIVE-ANALYSIS.md" -o -name "competitive-analysis.md" \) 2>/dev/null | head -3 | xargs cat 2>/dev/null
```

Based on what you find:
- **If STRATEGY.md exists**: present its current contents and ask what needs to change. Update only modified sections, preserve the rest.
- **If OKR or roadmap docs exist**: treat them as constraints on the new strategy — do not contradict committed OKRs without explicitly flagging the conflict.
- **If nothing is found**: ask clarifying questions about target audience, core problems, and strategic bets before writing.

Do not mention the scan to the user.

```

- [ ] **Step 4: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-product-strategy/SKILL.md
```
Expected: `✓ skills/write-product-strategy/SKILL.md — valid`

- [ ] **Step 5: Commit**

```bash
git add skills/write-product-strategy/SKILL.md
git commit -m "feat(write-product-strategy): make context scan use real tools, add brainstorming nudge"
```

---

### Task 5: write-roadmap — context scan

**Files:**
- Modify: `skills/write-roadmap/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-roadmap/SKILL.md
```
Expected: `✓ skills/write-roadmap/SKILL.md — valid`

- [ ] **Step 2: Add Step 0 before "### Step 1 — Read Strategy Pillars and OKRs to Derive Themes"**

Find the line `### Step 1 — Read Strategy Pillars and OKRs to Derive Themes` and insert the following block directly before it:

```markdown
### Step 0 — Scan for Strategy and OKR Documents (silent)

Before reading user input, silently scan for source documents:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | tail -1 | xargs cat 2>/dev/null
cat ROADMAP.md 2>/dev/null
```

If STRATEGY.md or OKR files are found, use them as the primary input for Step 1 rather than asking the user to describe the strategy from scratch. If an existing ROADMAP.md is found, present its current horizons and ask what has changed rather than building from scratch. Do not mention the scan.

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-roadmap/SKILL.md
```
Expected: `✓ skills/write-roadmap/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/write-roadmap/SKILL.md
git commit -m "feat(write-roadmap): add context scan for strategy and OKR documents"
```

---

### Task 6: write-okrs — context scan

**Files:**
- Modify: `skills/write-okrs/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-okrs/SKILL.md
```
Expected: `✓ skills/write-okrs/SKILL.md — valid`

- [ ] **Step 2: Add Step 0 before "### Step 1 — Read the Strategy and Identify 2–4 Distinct Pillars or Bets"**

Find the line `### Step 1 — Read the Strategy and Identify 2–4 Distinct Pillars or Bets` and insert the following block directly before it:

```markdown
### Step 0 — Scan for Strategy and Existing OKRs (silent)

Before reading the user's strategy input, silently scan for source documents:

```bash
cat STRATEGY.md 2>/dev/null
find . -maxdepth 2 -name "OKRs-*.md" 2>/dev/null | sort | xargs cat 2>/dev/null
```

If STRATEGY.md is found, use it as the primary source for Step 1 rather than asking the user to describe the strategy. If existing OKR files are found, surface them: *"I found existing OKRs — should I update these or draft a new set for a different period?"* Do not mention the scan.

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-okrs/SKILL.md
```
Expected: `✓ skills/write-okrs/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/write-okrs/SKILL.md
git commit -m "feat(write-okrs): add context scan for strategy and existing OKR documents"
```

---

### Task 7: competitive-analysis — context scan

**Files:**
- Modify: `skills/competitive-analysis/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/competitive-analysis/SKILL.md
```
Expected: `✓ skills/competitive-analysis/SKILL.md — valid`

- [ ] **Step 2: Add Phase 0 before "## Phase 1: Scope"**

Find the line `## Phase 1: Scope` and insert the following block directly before it:

```markdown
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

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/competitive-analysis/SKILL.md
```
Expected: `✓ skills/competitive-analysis/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/competitive-analysis/SKILL.md
git commit -m "feat(competitive-analysis): add context scan for existing strategy and prior analysis"
```

---

### Task 8: write-stakeholder-update — context scan

**Files:**
- Modify: `skills/write-stakeholder-update/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-stakeholder-update/SKILL.md
```
Expected: `✓ skills/write-stakeholder-update/SKILL.md — valid`

- [ ] **Step 2: Add Step 0 before "### Step 1 — Determine Status Signal from OKR Progress and Blockers"**

Find the line `### Step 1 — Determine Status Signal from OKR Progress and Blockers` and insert the following block directly before it:

```markdown
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

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-stakeholder-update/SKILL.md
```
Expected: `✓ skills/write-stakeholder-update/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/write-stakeholder-update/SKILL.md
git commit -m "feat(write-stakeholder-update): add context scan for prior updates and OKR documents"
```

---

### Task 9: write-feature-request — context scan + conditional nudge

**Files:**
- Modify: `skills/write-feature-request/SKILL.md`

- [ ] **Step 1: Verify baseline passes**

```bash
bash scripts/validate-skill.sh skills/write-feature-request/SKILL.md
```
Expected: `✓ skills/write-feature-request/SKILL.md — valid`

- [ ] **Step 2: Add conditional nudge + FR scan before "### Phase 1 — Information Gathering"**

Find the line `### Phase 1 — Information Gathering` and insert the following block directly before it:

```markdown
**Before starting:** If the user's input reads as exploratory — vague problem description, no clear outcome defined, or language like *"I'm thinking about..."* or *"wondering if we should..."* — surface this before proceeding:

> "If you're still exploring the problem space, `/superpowers:brainstorming` is a good first step — it sharpens the problem statement before we commit to a spec."

If the user's input is specific and outcome-focused, skip the nudge and proceed directly.

**Existing FR scan (silent):** Before asking questions, scan for related work:

```bash
find . -maxdepth 4 \( -name "FR-*.md" -o -name "feature-request-*.md" \) 2>/dev/null | head -10
```

If related FRs are found, surface them before proceeding: *"I found [N] existing feature requests that may be related — [titles]. Is this a new spec, or should we update one of these?"*

```

- [ ] **Step 3: Verify validation still passes**

```bash
bash scripts/validate-skill.sh skills/write-feature-request/SKILL.md
```
Expected: `✓ skills/write-feature-request/SKILL.md — valid`

- [ ] **Step 4: Commit**

```bash
git add skills/write-feature-request/SKILL.md
git commit -m "feat(write-feature-request): add existing FR scan and conditional brainstorming nudge"
```

---

### Task 10: Final validation across all modified skills

- [ ] **Step 1: Run validate-skill.sh on all skills**

```bash
for f in skills/*/SKILL.md; do bash scripts/validate-skill.sh "$f"; done
```
Expected: all files report `✓ ... — valid`. Pre-existing warnings on `sprint-review` and `write-product-strategy` are acceptable; no new errors or warnings should appear.

- [ ] **Step 2: Confirm git log shows one commit per task**

```bash
git log --oneline -12
```
Expected: 9 feat commits, one per skill, plus the spec commit.

- [ ] **Step 3: Push branch**

```bash
git push -u origin worktree-feat+gambit-context-augmentation
```
