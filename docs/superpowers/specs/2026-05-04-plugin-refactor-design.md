# Design: Refactor product-skills into a Claude Plugin

**Date:** 2026-05-04  
**Repo:** github.com/felipecabargas/product-skills  
**Branch:** felipe/sprint-review

## Goal

Convert the existing collection of standalone skill files into a proper Claude Code plugin installable via `claude plugin install github:felipecabargas/product-skills`, while keeping skill files fully usable by non-Claude users.

## Constraints

- Skill file content must remain readable as plain Markdown (no Claude-specific syntax in bodies)
- Non-Claude users must still be able to manually copy skills and use them
- No new skill content — this is a structural/metadata change only
- Single source of truth per skill (no duplication between model-invoked and slash-command files)

## Approach: Dual-purpose SKILL.md (Approach B)

Each `SKILL.md` file serves as both a model-invoked skill and a slash command by adding three additive frontmatter fields. No body content changes.

## Changes

### 1. `package.json`

Update to plugin-compatible format. Remove the hand-rolled `skills` array (not a plugin standard).

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

### 2. `CLAUDE.md` (new file)

Plugin context injection. Loaded when the plugin is active. Lean index — no duplication of skill content.

```markdown
# Product Skills Plugin

Provides four product management skills, available both as model-invoked skills and slash commands.

## Available Skills

- **verify-acceptance-criteria** (`/verify-acceptance-criteria`) — evaluate AC quality against five dimensions
- **write-feature-request** (`/write-feature-request`) — guided FR authoring with auto-generated ACs
- **write-product-strategy** (`/write-product-strategy`) — generate product strategy documents
- **sprint-review** (`/sprint-review`) — turn sprint data into stakeholder-ready reports
```

### 3. Skill frontmatter updates

Three fields added to each `SKILL.md`. No body changes.

| Skill | `argument-hint` | `allowed-tools` |
|---|---|---|
| `sprint-review` | `[sprint name or number]` | `[Read, Write, Bash]` |
| `verify-acceptance-criteria` | `[paste ACs or describe feature]` | `[Read, Write, Bash]` |
| `write-feature-request` | `[feature idea or problem]` | `[Read, Write, Bash]` |
| `write-product-strategy` | `[product name or context]` | `[Read, Write, Bash]` |

Example (sprint-review before/after):

**Before:**
```yaml
---
name: sprint-review
description: >
  Generate a professional sprint review report...
---
```

**After:**
```yaml
---
name: sprint-review
description: >
  Generate a professional sprint review report...
version: 1.0.0
argument-hint: "[sprint name or number]"
allowed-tools: [Read, Write, Bash]
---
```

### 4. `README.md` — installation section update

Add plugin install path alongside existing manual copy instructions:

```bash
# Claude plugin install (recommended)
claude plugin install github:felipecabargas/product-skills

# Manual install (non-Claude or other tools)
cp -r skills/* ~/.claude/skills/
```

### 5. `docs/getting-started.md` — update installation instructions

Add plugin install path. Keep manual copy path for non-Claude users.

## File change summary

| File | Change |
|---|---|
| `package.json` | Update to plugin format, remove custom `skills` array |
| `CLAUDE.md` | New file — plugin context injection |
| `skills/sprint-review/SKILL.md` | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/verify-acceptance-criteria/SKILL.md` | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/write-feature-request/SKILL.md` | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `skills/write-product-strategy/SKILL.md` | Add `version`, `argument-hint`, `allowed-tools` to frontmatter |
| `README.md` | Add plugin install section |
| `docs/getting-started.md` | Add plugin install path |

## Out of scope

- New skills or skill content changes
- Hooks, MCP servers, agents
- Marketplace publishing (beyond git-based install)
- `docs/skill-framework.md`, `docs/contributing.md`, `examples/` — no changes needed
