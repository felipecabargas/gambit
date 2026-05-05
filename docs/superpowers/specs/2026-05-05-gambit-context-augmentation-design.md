# Gambit Context Augmentation Design

**Date:** 2026-05-05
**Status:** Approved

## Context

Gambit skills currently rely entirely on user-supplied input. They ask questions, receive pasted data, and generate output — but never proactively gather context from the environment they're running in. Yet every Gambit skill already has `Bash` and `Read` in its `allowed-tools`, meaning the capability is there. This design adds two tracks of augmentation:

1. **Context gathering** — skills silently scan the project environment before asking questions or producing output
2. **Superpowers nudges** — skills surface optional hints at workflow transition moments, pointing to Superpowers process skills where they genuinely add value

Both tracks are non-breaking. Context gathering degrades gracefully to current behavior when nothing is found. Nudges are skippable one-liners with no detection logic and no auto-invocation.

## Design Principles

- **Silent enrichment**: context scanning happens without the user noticing. No "scanning codebase..." preamble. Results are used; the scan itself is invisible.
- **Graceful degradation**: if a scan finds nothing, the skill continues exactly as today. No new required inputs, no new failure modes.
- **No Superpowers dependency**: nudges are plain text suggestions. They work whether or not Superpowers is installed. No runtime detection of installed plugins.
- **No auto-invocation**: no Superpowers skill is ever triggered automatically. Nudges inform; the user decides.

## Track 1: Context Gathering

### Pattern

Each augmented skill gets a silent scan step that runs before any questions are asked or output is generated:

1. Run targeted `Bash`/`Read` lookups for relevant artefacts
2. If found, incorporate results silently into the skill's reasoning and output
3. If nothing found, continue as before — no mention of the scan

### Per-Skill Breakdown

#### High tier — context materially changes output quality

**`write-technical-brief`**
- Scan: README.md, architecture docs (ARCHITECTURE.md, docs/architecture/, ADRs/), package.json / Cargo.toml / go.mod, any existing feature code referenced in the FR
- Impact: Fills constraints and integration sections with real data instead of leaving them for the user to supply. The skill currently says "if architecture context is provided, use it" — this makes it self-serve.

**`sprint-review`**
- Scan: `git log --merges --oneline` since sprint start date (parsed from user input) or since last git tag
- Impact: User can say "last two weeks" and the skill finds merged PRs directly from git history. Supplements or replaces the user-pasted ticket list.

**`write-release-notes`**
- Scan: Last release tag via `git describe --tags --abbrev=0`, then `git log` for merge commits since that tag
- Impact: Can draft release notes without the user assembling a ticket list. Falls back to user input if no tags exist.

#### Medium tier — context prevents duplication and builds on prior work

**`write-product-strategy`**
- Scan: STRATEGY.md, OKRs-*.md, ROADMAP.md
- Impact: Updates an existing strategy document rather than recreating one from scratch. Prior decisions are preserved and referenced.

**`write-roadmap`**
- Scan: STRATEGY.md, OKRs-*.md (all matching files)
- Impact: Inherits strategic priorities and existing OKR commitments; avoids contradicting already-committed work.

**`write-okrs`**
- Scan: STRATEGY.md, existing OKRs-*.md files
- Impact: Derives OKRs from the actual strategy on disk rather than from the user's description of it.

**`competitive-analysis`**
- Scan: STRATEGY.md, COMPETITIVE-ANALYSIS.md
- Impact: Builds on prior analysis; does not re-document competitors already covered in an existing file.

**`write-stakeholder-update`**
- Scan: stakeholder-update-*.md (previous updates), STRATEGY.md, OKRs-*.md
- Impact: Maintains narrative continuity across updates; can reference prior commitments and flag changes.

**`write-feature-request`**
- Scan: feature-requests/ directory for existing FR files
- Impact: Surfaces related FRs before writing a new one; avoids duplicating work already specced.

#### Skipped — no meaningful benefit

| Skill | Reason |
|---|---|
| `verify-acceptance-criteria` | AC quality is purely language-based; codebase context doesn't improve the evaluation |
| `synthesize-user-research` | Inputs are user-supplied research artefacts; there's nothing relevant to scan |
| `build-user-persona` | Same as above |

## Track 2: Superpowers Nudges

### Pattern

A single skippable callout at a specific moment in the skill. The nudge:
- Is 1–2 lines of plain text
- Names the exact slash command
- Uses optional framing ("If you haven't already...")
- Never blocks the workflow
- Contains no conditional logic based on whether Superpowers is installed

### Per-Skill Breakdown

**`write-feature-request` — start, conditional**

Trigger: only if the user's input reads as exploratory — vague problem statement, no clear user or outcome defined, language like "I'm thinking about..." If the input is already well-formed, skip the nudge entirely.

> *"If you're still exploring the problem space, `/superpowers:brainstorming` is a good first step — it sharpens the problem statement before we commit to a spec."*

**`write-product-strategy` — start, always**

Strategy direction benefits from structured exploration before it's locked. The nudge is always appropriate regardless of input quality.

> *"If you haven't done a structured brainstorm yet, `/superpowers:brainstorming` can map the problem space before we commit to strategic direction."*

**`write-technical-brief` — end, after output is produced**

The brief is most useful once engineering has reviewed it. Surfaces the natural next step.

> *"To route this to engineering for review, `/superpowers:requesting-code-review` walks through the handoff."*

## Scope Boundaries

**In scope:**
- Modifying 9 existing skill SKILL.md files (context gathering: 8 skills; nudges: 3 skills, with overlap)
- No new files, no new skills, no new agents

**Out of scope:**
- Changes to agents (they orchestrate skills; augmented skills carry the benefit through automatically)
- Changes to `allowed-tools` (already correct across all skills)
- Detection logic for installed plugins
- Auto-invocation of any external skill
- Changes to `verify-acceptance-criteria`, `synthesize-user-research`, `build-user-persona`

## Skills Modified

| Skill | Context gathering | Superpowers nudge |
|---|---|---|
| `write-technical-brief` | ✓ (high) | ✓ (end) |
| `sprint-review` | ✓ (high) | — |
| `write-release-notes` | ✓ (high) | — |
| `write-product-strategy` | ✓ (medium) | ✓ (start) |
| `write-roadmap` | ✓ (medium) | — |
| `write-okrs` | ✓ (medium) | — |
| `competitive-analysis` | ✓ (medium) | — |
| `write-stakeholder-update` | ✓ (medium) | — |
| `write-feature-request` | ✓ (medium) | ✓ (start, conditional) |
