# Gambit Roadmap Design

**Date:** 2026-05-05  
**Status:** Approved

## Context

Gambit currently covers four skills: `verify-acceptance-criteria`, `write-feature-request`, `write-product-strategy`, and `sprint-review`. This design expands Gambit with new skills and chained agents, turning it into a full PM workflow engine.

## Design Direction

**Agent-first.** Four chained workflow agents are the headline feature. New standalone skills are derived from what those agents need — ensuring all skills are designed to compose well from day one.

## Agents

### `discovery-to-fr`
**Chain:** `synthesize-user-research` → `build-user-persona` → `write-feature-request`  
**Purpose:** Full research-to-spec pipeline. User inputs raw interview notes, survey data, or feedback; the agent outputs a complete FR with persona context attached.

### `fr-to-ready`
**Chain:** `write-feature-request` → `verify-acceptance-criteria` → `write-technical-brief`  
**Purpose:** Closes the gap between PM spec and engineering handoff. Ensures every FR that leaves PM hands is verified and accompanied by a technical brief covering constraints, edge cases, and open questions.

### `strategy-to-roadmap`
**Chain:** `write-product-strategy` → `write-okrs` → `write-roadmap`  
**Purpose:** Full strategy-to-execution pipeline. Derives measurable OKRs and a horizon-based roadmap directly from a strategy document.

### `sprint-to-stakeholders`
**Chain:** `sprint-review` → `write-release-notes` → `write-stakeholder-update`  
**Purpose:** One sprint's data produces three outputs simultaneously: internal sprint review, customer-facing release notes, and a leadership status update.

## New Skills

Derived from agent needs, ordered by priority (B: Discovery → A: Communication → C: Backlog).

### Discovery (Priority B)

| Skill | Description |
|---|---|
| `synthesize-user-research` | Take raw interview notes, survey results, or feedback and extract themes, insights, and jobs-to-be-done |
| `build-user-persona` | Create structured user personas from qualitative/quantitative research inputs |
| `competitive-analysis` | Structure a competitive landscape analysis; feeds optionally into `discovery-to-fr` |

### Communication (Priority A)

| Skill | Description |
|---|---|
| `write-okrs` | Generate well-structured OKRs aligned to a product strategy |
| `write-roadmap` | Create a horizon-based roadmap document from strategy and priorities |
| `write-release-notes` | Convert sprint tickets/PRs into customer-facing release notes |
| `write-stakeholder-update` | Write a weekly or monthly PM status update for leadership |

### Handoff (Priority C-adjacent)

| Skill | Description |
|---|---|
| `write-technical-brief` | Bridge document between PM spec and engineering: constraints, edge cases, open questions, and scope boundaries |

## Issue Summary

12 GitHub issues total:
- 4 agent issues
- 8 new skill issues
