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

# FR to Ready Agent

## Overview

This agent is a three-skill chain that closes the gap between a raw feature idea and a dev-ready state. It runs `write-feature-request`, `verify-acceptance-criteria`, and `write-technical-brief` in sequence, producing a complete handoff package that engineering can act on without needing to chase down missing context.

The three components and what each produces:

- **write-feature-request** — guides you through a structured conversation to produce a complete FR with problem statement, user stories, and acceptance criteria
- **verify-acceptance-criteria** — evaluates every AC against five quality dimensions and rewrites failing criteria before they reach engineering
- **write-technical-brief** — translates the verified FR into an engineering-facing document covering architecture considerations, implementation approach, and open questions

## Chain

```
write-feature-request → verify-acceptance-criteria → write-technical-brief
```

## How It Runs

### Step 1 — Write the Feature Request

Run `write-feature-request` in full guided conversation mode. The skill asks clarifying questions, surfaces edge cases, and produces a complete FR with a problem statement, user stories, and a set of acceptance criteria.

Save output in the standard `write-feature-request` format.

Pause here: present the completed FR to the user for review. Ask: "Here is the Feature Request. Does this capture what you intend to build? Confirm to continue with AC verification, or provide corrections first."

Do not proceed to Step 2 until the user confirms.

### Step 2 — Verify and Rewrite Acceptance Criteria

Pass all ACs from the FR into `verify-acceptance-criteria`. The skill evaluates each AC against five quality dimensions: testability, clarity, completeness, scope, and independence.

For any AC that fails verification, automatically produce a rewritten version. Present a diff to the user showing original and rewritten ACs side by side.

Ask: "Here are the AC rewrites. Do you approve these changes? You can accept all, reject individual rewrites, or provide your own edits."

Do not proceed to Step 3 until the user approves the rewrites.

### Step 3 — Write the Technical Brief

Run `write-technical-brief` using the verified FR (with approved AC rewrites applied) as input. The skill produces an engineering-facing document covering architecture considerations, data model implications, API surface, implementation approach, dependencies, and open questions for the team.

### Step 4 — Present the Complete Bundle

Present all three artefacts to the user:

1. The Feature Request in standard format
2. The AC verification report (showing which ACs changed and why)
3. `technical-brief-[feature-slug].md` — the engineering handoff document

Summarise the state of the package: the FR defines the what and why, the verified ACs define the done criteria, and the technical brief gives engineering the context to start.

## Pause Points

The agent pauses twice:

- **After Step 1** — user reviews the FR before AC verification runs. This prevents the verification and brief from being built on top of a misaligned FR.
- **After Step 2** — user approves AC rewrites before the technical brief is written. The brief is derived from the verified FR, so any disagreement on the ACs must be resolved first.

These are the only two pause points. The chain is otherwise automated.

## Outputs

Three saved files:

- Feature Request in the standard `write-feature-request` output format (filename determined by that skill)
- AC verification report in the standard `verify-acceptance-criteria` output format
- `technical-brief-[feature-slug].md` — the engineering handoff document

## When to Use vs. Individual Skills

**Use this agent** when you are starting from scratch with a feature idea, or when you have an existing FR and want the complete dev-ready package produced in one session. The agent is the fastest path from idea to engineering handoff.

**Use `verify-acceptance-criteria` alone** to audit an existing FR without regenerating it or producing a technical brief. If you have an FR that was written previously and you just want to quality-check the ACs, run that skill directly rather than re-running the full chain.

**Use `write-technical-brief` alone** if you already have a verified FR and only need the engineering handoff document.
