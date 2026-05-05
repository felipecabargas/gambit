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

# Sprint to Stakeholders Agent

## Overview

This agent is a three-skill chain that turns raw sprint data into a complete communications package. It runs `sprint-review`, `write-release-notes`, and `write-stakeholder-update` in sequence, producing one internal artefact and two external-facing artefacts from a single sprint data input.

The three components and what each produces:

- **sprint-review** — processes sprint ticket data, team velocity, and a sprint goal to produce a structured internal review document covering what shipped, what slipped, and key takeaways
- **write-release-notes** — filters the completed work list for customer-visible items and formats them as user-facing release notes, ready to publish
- **write-stakeholder-update** — synthesises the sprint review highlights and release notes into a concise stakeholder update suitable for leadership, investors, or cross-functional partners

## Chain

```
sprint-review → write-release-notes → write-stakeholder-update
```

## How It Runs

### Step 1 — Run Sprint Review

Run `sprint-review` using the provided sprint data (sprint name or number, ticket list, team notes, or any combination). The skill produces a structured internal review covering the sprint goal, completed items, slipped items, blockers, and retrospective highlights.

Save output as `sprint-review-[slug].md`, where `[slug]` is derived from the sprint name or number (e.g. `sprint-review-sprint-42.md`).

Pause here only if the sprint data is ambiguous — for example, if no sprint goal is present or it is unclear which tickets were completed vs. in-progress. If the data is sufficient, proceed automatically.

### Step 2 — Write Release Notes

Feed the completed work list from Step 1 into `write-release-notes`. Filter for customer-visible items only — exclude internal refactors, infrastructure changes, dependency bumps, and anything flagged as internal. Format the remaining items as user-facing release notes with a short summary of what changed and why it matters to users.

Save output as `release-notes-[date].md`, where `[date]` is today's date in YYYY-MM-DD format (e.g. `release-notes-2026-05-05.md`).

### Step 3 — Write Stakeholder Update

Feed the sprint review highlights from Step 1 and the release notes from Step 2 into `write-stakeholder-update`. The skill produces a concise stakeholder-facing narrative covering sprint outcomes, customer impact, and any notable risks or decisions that require awareness at the leadership or partner level.

Save output as `stakeholder-update-[date].md`, where `[date]` matches the date used in Step 2 (e.g. `stakeholder-update-2026-05-05.md`).

### Step 4 — Present the Complete Package

Present all three artefacts to the user with a brief summary of what each is for and who should receive it:

1. `sprint-review-[slug].md` — internal document for the team and engineering leadership; not intended for external distribution
2. `release-notes-[date].md` — external document for customers, users, and product-facing channels such as a changelog or release page
3. `stakeholder-update-[date].md` — external-leaning document for senior leadership, investors, or cross-functional partners who need the narrative without the detail

## Pause Points

The chain pauses minimally. The three outputs are largely independent — each skill draws from different portions of the sprint data, and errors in one artefact do not propagate to the others.

The only pause point is at the start: if the sprint data is ambiguous (no sprint goal present, unclear completion status on tickets, or conflicting input signals), pause to ask a single clarifying question before running Step 1. Once the sprint goal is confirmed, run all three steps without further interruption.

Do not pause between steps. The chain is low-risk and the outputs are designed to be reviewed together at the end, not incrementally approved.

## Outputs

Three saved files:

- `sprint-review-[slug].md` — internal sprint review for the team and engineering leadership
- `release-notes-[date].md` — customer-facing release notes filtered to user-visible changes
- `stakeholder-update-[date].md` — leadership and partner-facing sprint narrative

## When to Use vs. Individual Skills

**Use this agent** at the end of every sprint when you need the full communications package. It is the fastest path from sprint data to a complete set of internal and external artefacts, and ensures the three documents are consistent with each other.

**Use `sprint-review` alone** when you only need the internal review — for example, during a mid-sprint check-in, or when producing an internal-only retrospective that will not be accompanied by external communications.

**Use `write-release-notes` alone** when publishing release notes for a patch or hotfix that does not warrant a full sprint review — for example, an out-of-band bug fix shipped between sprints.
