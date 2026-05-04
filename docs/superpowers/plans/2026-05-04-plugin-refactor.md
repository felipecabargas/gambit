# Plugin Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the product-skills repo into a proper Claude Code plugin installable via `claude plugin install github:felipecabargas/product-skills`, while keeping all skill files usable by non-Claude users.

**Architecture:** Each `SKILL.md` file is updated with three additive frontmatter fields (`version`, `argument-hint`, `allowed-tools`) to make it both model-invoked and a slash command. A new `CLAUDE.md` provides plugin context injection. `package.json` is trimmed to plugin-compatible format. No skill body content changes.

**Tech Stack:** YAML frontmatter, Markdown, Claude Code plugin system

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `package.json` | Modify | Plugin-format metadata — name, version, repo URL only |
| `CLAUDE.md` | Create | Plugin context injection — skill index for Claude |
| `skills/sprint-review/SKILL.md` | Modify | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/verify-acceptance-criteria/SKILL.md` | Modify | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/write-feature-request/SKILL.md` | Modify | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/write-product-strategy/SKILL.md` | Modify | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `README.md` | Modify | Add plugin install section to Installation and Quick Start |
| `docs/getting-started.md` | Modify | Add plugin install path before manual copy instructions |

---

### Task 1: Update `package.json` to plugin format

**Files:**
- Modify: `package.json`

The current `package.json` has a hand-rolled `skills` array and placeholder repo URL. Plugin format only needs `name`, `version`, `description`, `license`, and `repository`.

- [ ] **Step 1: Replace `package.json` content**

Write this exact content to `package.json`:

```json
{
  "name": "product-skills",
  "version": "1.0.0",
  "description": "A collection of Claude skills for product management workflows",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/felipecabargas/product-skills.git"
  }
}
```

- [ ] **Step 2: Verify JSON is valid**

```bash
python3 -c "import json; json.load(open('package.json')); print('JSON valid')"
```

Expected output: `JSON valid`

- [ ] **Step 3: Commit**

```bash
git add package.json
git commit -m "chore: update package.json to plugin-compatible format"
```

---

### Task 2: Create `CLAUDE.md`

**Files:**
- Create: `CLAUDE.md`

This file is the plugin's context injection — loaded by Claude when the plugin is active. It must be lean: just enough for Claude to know the plugin is active and what skills are available.

- [ ] **Step 1: Create `CLAUDE.md`**

Write this exact content to `CLAUDE.md` at the repo root:

```markdown
# Product Skills Plugin

Provides four product management skills, available both as model-invoked skills and slash commands.

## Available Skills

- **verify-acceptance-criteria** (`/verify-acceptance-criteria`) — evaluate AC quality against five dimensions
- **write-feature-request** (`/write-feature-request`) — guided FR authoring with auto-generated ACs
- **write-product-strategy** (`/write-product-strategy`) — generate product strategy documents
- **sprint-review** (`/sprint-review`) — turn sprint data into stakeholder-ready reports
```

- [ ] **Step 2: Verify file was created**

```bash
ls -la CLAUDE.md
```

Expected: file exists with non-zero size.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "feat: add CLAUDE.md plugin context injection"
```

---

### Task 3: Update `sprint-review` SKILL.md frontmatter

**Files:**
- Modify: `skills/sprint-review/SKILL.md`

Current frontmatter ends at `---` after the `description` block. Add three fields before the closing `---`.

- [ ] **Step 1: Edit the frontmatter**

The current closing of the frontmatter block looks like:

```yaml
---
name: sprint-review
description: >
  Generate a professional sprint review report for stakeholders — PMs, leadership, and cross-functional teams. Use this skill whenever a user wants to write up a sprint, summarize what the team shipped, produce a sprint retrospective document, recap what was completed in an iteration, or create a sprint summary for leadership. Triggers include: "write my sprint review", "generate a sprint recap", "create a sprint report", "summarize what we shipped this sprint", "help me write up our sprint for stakeholders", or any mention of sprint outcomes, velocity reports, or iteration summaries — even if they don't use the word "skill" or "report". Also trigger when a user pastes a list of tickets/tasks and asks for a write-up or summary.
---
```

Replace the closing `---` line with the three new fields followed by `---`:

```yaml
---
name: sprint-review
description: >
  Generate a professional sprint review report for stakeholders — PMs, leadership, and cross-functional teams. Use this skill whenever a user wants to write up a sprint, summarize what the team shipped, produce a sprint retrospective document, recap what was completed in an iteration, or create a sprint summary for leadership. Triggers include: "write my sprint review", "generate a sprint recap", "create a sprint report", "summarize what we shipped this sprint", "help me write up our sprint for stakeholders", or any mention of sprint outcomes, velocity reports, or iteration summaries — even if they don't use the word "skill" or "report". Also trigger when a user pastes a list of tickets/tasks and asks for a write-up or summary.
version: 1.0.0
argument-hint: "[sprint name or number]"
allowed-tools: [Read, Write, Bash]
---
```

- [ ] **Step 2: Validate the frontmatter YAML**

```bash
python3 -c "
content = open('skills/sprint-review/SKILL.md').read()
frontmatter = content.split('---')[1]
import yaml; yaml.safe_load(frontmatter)
print('YAML valid')
"
```

Expected output: `YAML valid`

- [ ] **Step 3: Commit**

```bash
git add skills/sprint-review/SKILL.md
git commit -m "feat: add plugin frontmatter to sprint-review skill"
```

---

### Task 4: Update `verify-acceptance-criteria` SKILL.md frontmatter

**Files:**
- Modify: `skills/verify-acceptance-criteria/SKILL.md`

Current frontmatter uses `description: |` (block scalar). Add the three fields before the closing `---`.

- [ ] **Step 1: Edit the frontmatter**

Current frontmatter:

```yaml
---
name: verify-acceptance-criteria
description: |
  Verify acceptance criteria quality and identify gaps.
  
  Use this skill whenever you need to evaluate acceptance criteria (ACs) to ensure they meet quality standards. Trigger on: "review these ACs", "check if these acceptance criteria are good", "validate my user story criteria", "improve our acceptance criteria", "audit these requirements", "do these ACs pass review", or similar requests. Also use proactively when someone shares acceptance criteria that look hastily written or vague. The skill analyzes criteria against five key dimensions (clarity, testability, outcome-focus, measurability, independence), scores issues by severity (critical/major/minor), and generates a structured report. It can also rewrite poor criteria into better ones or convert them to user story format.
---
```

Replace with:

```yaml
---
name: verify-acceptance-criteria
description: |
  Verify acceptance criteria quality and identify gaps.
  
  Use this skill whenever you need to evaluate acceptance criteria (ACs) to ensure they meet quality standards. Trigger on: "review these ACs", "check if these acceptance criteria are good", "validate my user story criteria", "improve our acceptance criteria", "audit these requirements", "do these ACs pass review", or similar requests. Also use proactively when someone shares acceptance criteria that look hastily written or vague. The skill analyzes criteria against five key dimensions (clarity, testability, outcome-focus, measurability, independence), scores issues by severity (critical/major/minor), and generates a structured report. It can also rewrite poor criteria into better ones or convert them to user story format.
version: 1.0.0
argument-hint: "[paste ACs or describe feature]"
allowed-tools: [Read, Write, Bash]
---
```

- [ ] **Step 2: Validate the frontmatter YAML**

```bash
python3 -c "
content = open('skills/verify-acceptance-criteria/SKILL.md').read()
frontmatter = content.split('---')[1]
import yaml; yaml.safe_load(frontmatter)
print('YAML valid')
"
```

Expected output: `YAML valid`

- [ ] **Step 3: Commit**

```bash
git add skills/verify-acceptance-criteria/SKILL.md
git commit -m "feat: add plugin frontmatter to verify-acceptance-criteria skill"
```

---

### Task 5: Update `write-feature-request` SKILL.md frontmatter

**Files:**
- Modify: `skills/write-feature-request/SKILL.md`

Current frontmatter uses `description: |` and ends with a blank line before `---`.

- [ ] **Step 1: Edit the frontmatter**

Current frontmatter:

```yaml
---
name: write-feature-request
description: |
  Guided Feature Request (FR) authoring. Assists the user in writing a high-quality FR by collecting structured inputs (problem, solution, outcomes, requirements), then auto-generates Acceptance Criteria for every requirement. If any AC cannot be written due to missing information, the skill identifies the gaps and prompts the user. Returns a polished FR in Markdown with nested ACs, open questions, and risks.

  Use this skill whenever a user needs to author or improve a feature request. Trigger on: "write a feature request", "help me write an FR", "create a feature spec", "draft a feature proposal", "I want to define a new feature", "turn this idea into a feature request", or similar requests.
---
```

Replace with:

```yaml
---
name: write-feature-request
description: |
  Guided Feature Request (FR) authoring. Assists the user in writing a high-quality FR by collecting structured inputs (problem, solution, outcomes, requirements), then auto-generates Acceptance Criteria for every requirement. If any AC cannot be written due to missing information, the skill identifies the gaps and prompts the user. Returns a polished FR in Markdown with nested ACs, open questions, and risks.

  Use this skill whenever a user needs to author or improve a feature request. Trigger on: "write a feature request", "help me write an FR", "create a feature spec", "draft a feature proposal", "I want to define a new feature", "turn this idea into a feature request", or similar requests.
version: 1.0.0
argument-hint: "[feature idea or problem]"
allowed-tools: [Read, Write, Bash]
---
```

- [ ] **Step 2: Validate the frontmatter YAML**

```bash
python3 -c "
content = open('skills/write-feature-request/SKILL.md').read()
frontmatter = content.split('---')[1]
import yaml; yaml.safe_load(frontmatter)
print('YAML valid')
"
```

Expected output: `YAML valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-feature-request/SKILL.md
git commit -m "feat: add plugin frontmatter to write-feature-request skill"
```

---

### Task 6: Update `write-product-strategy` SKILL.md frontmatter

**Files:**
- Modify: `skills/write-product-strategy/SKILL.md`

Current frontmatter has `description` as a quoted string and an extra `compatibility` field. Add the three new fields before the closing `---`.

- [ ] **Step 1: Edit the frontmatter**

Current frontmatter:

```yaml
---
name: write-product-strategy
description: "Generate comprehensive product strategy documents aligned with business goals. Use this when defining or updating your product's strategic direction, aligning teams on where to play and how to win, or creating a STRATEGY.md that bridges vision and execution. Triggers include: clarifying product strategy, articulating competitive positioning, defining strategic pillars, creating alignment documents, or answering 'what are we betting on as a company?' This skill scans existing project docs (roadmaps, market research, competitive analyses) to inform strategy, then either creates a new STRATEGY.md or updates an existing one."
compatibility: "Requires filesystem access to project directory. Works best with markdown and project context documents."
---
```

Replace with:

```yaml
---
name: write-product-strategy
description: "Generate comprehensive product strategy documents aligned with business goals. Use this when defining or updating your product's strategic direction, aligning teams on where to play and how to win, or creating a STRATEGY.md that bridges vision and execution. Triggers include: clarifying product strategy, articulating competitive positioning, defining strategic pillars, creating alignment documents, or answering 'what are we betting on as a company?' This skill scans existing project docs (roadmaps, market research, competitive analyses) to inform strategy, then either creates a new STRATEGY.md or updates an existing one."
compatibility: "Requires filesystem access to project directory. Works best with markdown and project context documents."
version: 1.0.0
argument-hint: "[product name or context]"
allowed-tools: [Read, Write, Bash]
---
```

- [ ] **Step 2: Validate the frontmatter YAML**

```bash
python3 -c "
content = open('skills/write-product-strategy/SKILL.md').read()
frontmatter = content.split('---')[1]
import yaml; yaml.safe_load(frontmatter)
print('YAML valid')
"
```

Expected output: `YAML valid`

- [ ] **Step 3: Commit**

```bash
git add skills/write-product-strategy/SKILL.md
git commit -m "feat: add plugin frontmatter to write-product-strategy skill"
```

---

### Task 7: Update `README.md` installation sections

**Files:**
- Modify: `README.md`

Two sections need updating: **Quick Start** (lines 24–28) and **Installation** (lines 53–65).

- [ ] **Step 1: Replace the Quick Start section**

Current:

```markdown
## Quick Start

1. Install skills to your Claude environment: `~/.claude/skills/`
2. Reference the `getting-started.md` guide in `/docs`
3. Review example evaluations in `/examples`
```

Replace with:

```markdown
## Quick Start

```bash
# Claude plugin install (recommended)
claude plugin install github:felipecabargas/product-skills
```

Or see [Manual Installation](#installation) below for non-Claude environments.
```

- [ ] **Step 2: Replace the Installation section**

Current:

```markdown
## Installation

Copy skill files to your Claude Code skills directory:

```bash
# Copy individual skills
cp -r skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r skills/* ~/.claude/skills/
```
```

Replace with:

```markdown
## Installation

### Claude Plugin (recommended)

```bash
claude plugin install github:felipecabargas/product-skills
```

Skills are immediately available as both model-invoked skills and slash commands (`/sprint-review`, `/verify-acceptance-criteria`, etc.).

### Manual Install (non-Claude environments)

```bash
# Copy individual skills
cp -r skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r skills/* ~/.claude/skills/
```
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add plugin install instructions to README"
```

---

### Task 8: Update `docs/getting-started.md` installation section

**Files:**
- Modify: `docs/getting-started.md`

The Installation section (lines 1–51) describes only manual copy. Add plugin install as the recommended first option.

- [ ] **Step 1: Replace the Installation section header and steps**

Current (lines 5–51):

```markdown
## Installation

### Step 1: Locate Your Claude Skills Directory

The default location for Claude skills is `~/.claude/skills/`. If this directory doesn't exist, create it:

```bash
mkdir -p ~/.claude/skills
```

### Step 2: Copy Skills to Your Environment

Clone or download this repository, then copy the skills:

```bash
# Copy individual skill
cp -r product-skills/skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r product-skills/skills/* ~/.claude/skills/
```

### Step 3: Verify Installation

After copying, verify the installation:

```bash
ls -la ~/.claude/skills/
```

You should see:
```
verify-acceptance-criteria/
├── SKILL.md
write-feature-request/
├── SKILL.md
write-product-strategy/
├── SKILL.md
sprint-review/
├── SKILL.md
```

### Step 4: Restart Claude

Restart Claude Code to load the newly installed skills. They will be automatically available in your next session.
```

Replace with:

```markdown
## Installation

### Option A: Claude Plugin (recommended)

```bash
claude plugin install github:felipecabargas/product-skills
```

That's it. Skills are immediately available as model-invoked skills and slash commands. No restart required.

### Option B: Manual Install (non-Claude environments)

Use this if you are not using Claude Code or prefer manual control.

**Step 1: Locate your Claude skills directory**

The default location is `~/.claude/skills/`. Create it if it doesn't exist:

```bash
mkdir -p ~/.claude/skills
```

**Step 2: Copy skills**

```bash
# Copy individual skill
cp -r product-skills/skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r product-skills/skills/* ~/.claude/skills/
```

**Step 3: Verify installation**

```bash
ls -la ~/.claude/skills/
```

You should see:
```
verify-acceptance-criteria/
├── SKILL.md
write-feature-request/
├── SKILL.md
write-product-strategy/
├── SKILL.md
sprint-review/
├── SKILL.md
```

**Step 4: Restart Claude**

Restart Claude Code to load the newly installed skills.
```

- [ ] **Step 2: Commit**

```bash
git add docs/getting-started.md
git commit -m "docs: add plugin install path to getting-started guide"
```

---

## Self-Review

**Spec coverage:**
- ✅ `package.json` updated to plugin format (Task 1)
- ✅ `CLAUDE.md` created (Task 2)
- ✅ All 4 skill frontmatters updated with `version`, `argument-hint`, `allowed-tools` (Tasks 3–6)
- ✅ `README.md` installation sections updated (Task 7)
- ✅ `docs/getting-started.md` installation updated (Task 8)
- ✅ Out-of-scope files (`skill-framework.md`, `contributing.md`, `examples/`) not touched

**Placeholder scan:** No TBDs or incomplete steps — every step contains the exact content to write.

**Consistency:** `argument-hint` values in Tasks 3–6 match the table in the spec. `allowed-tools: [Read, Write, Bash]` is uniform across all four skills. Install command `github:felipecabargas/product-skills` is consistent across Tasks 1, 7, and 8.
