# Design: Rename plugin to "gambit" and namespace slash commands

**Date:** 2026-05-04
**Repo:** github.com/felipecabargas/product-skills → github.com/felipecabargas/gambit

## Goal

Rename the plugin from `product-skills` to `gambit`, giving it a memorable, tool-agnostic identity that conveys strategic authority and leverage. The slash command namespace updates automatically from unnamespaced (`/sprint-review`) to plugin-namespaced (`/gambit:sprint-review`) by changing only the plugin name.

## What Changes

| File | Change |
|---|---|
| `package.json` | `"name": "product-skills"` → `"name": "gambit"` |
| `CLAUDE.md` | Update heading to `# Gambit`, install command URL, slash command names to `/gambit:*` |
| `README.md` | Update title to `# Gambit`, install command URL, slash command examples to `/gambit:*` |
| `docs/getting-started.md` | Update install command URL to `github:felipecabargas/gambit` |
| GitHub repo | Rename `product-skills` → `gambit` (GitHub Settings → rename) |

## What Does NOT Change

- Individual `SKILL.md` files — no changes to frontmatter or body content
- Skill names (`sprint-review`, `verify-acceptance-criteria`, etc.) — the plugin system auto-prefixes these with the plugin name
- `docs/superpowers/specs/` and `docs/superpowers/plans/` — historical, stay as-is
- `docs/skill-framework.md`, `docs/contributing.md`, `examples/` — no changes needed

## Key Detail: Namespacing is Automatic

The slash command namespace comes from the plugin `name` field in `package.json`. Changing `"name": "product-skills"` to `"name": "gambit"` is the only change needed to transform all slash commands:

| Before | After |
|---|---|
| `/sprint-review` | `/gambit:sprint-review` |
| `/verify-acceptance-criteria` | `/gambit:verify-acceptance-criteria` |
| `/write-feature-request` | `/gambit:write-feature-request` |
| `/write-product-strategy` | `/gambit:write-product-strategy` |

## Updated CLAUDE.md Content

```markdown
# Gambit

Provides four product management skills, available both as model-invoked skills and slash commands.

## Available Skills

- **verify-acceptance-criteria** (`/gambit:verify-acceptance-criteria`) — evaluate AC quality against five dimensions
- **write-feature-request** (`/gambit:write-feature-request`) — guided FR authoring with auto-generated ACs
- **write-product-strategy** (`/gambit:write-product-strategy`) — generate product strategy documents
- **sprint-review** (`/gambit:sprint-review`) — turn sprint data into stakeholder-ready reports
```

## Updated Install Command

```bash
claude plugin install github:felipecabargas/gambit
```

## Out of Scope

- Renaming individual skills
- Changing skill content
- Adding new skills
- Resolving the `compatibility` field inconsistency in `write-product-strategy/SKILL.md` (separate concern)
