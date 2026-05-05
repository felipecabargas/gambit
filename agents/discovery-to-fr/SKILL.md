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

# Discovery to FR Agent

## Overview

This agent is a chained workflow, not a standalone skill. It orchestrates three component skills in sequence to take raw user research all the way to a finished Feature Request — without requiring you to manage the handoffs between skills manually.

The three components and what each produces:

- **synthesize-user-research** — reads interview notes, survey data, support tickets, or other research inputs and produces a structured synthesis document covering key themes, pain points, and jobs-to-be-done (JTBD)
- **build-user-persona** — takes the synthesis output and constructs one or more named user personas with goals, frustrations, context, and behavioural patterns
- **write-feature-request** — takes the persona(s) and research insights as pre-loaded context and produces a complete, well-structured Feature Request with auto-generated acceptance criteria

## Chain

```
synthesize-user-research → build-user-persona → write-feature-request
```

## How It Runs

### Step 1 — Synthesize Research

Run `synthesize-user-research` on the provided input (interview notes, survey responses, support tickets, or a description of what you have). The skill reads and structures the raw material into a synthesis document.

Save output as `research-synthesis-[slug].md`.

Present the key themes and JTBD to the user for a sanity check before proceeding. Ask: "Here are the main themes and jobs-to-be-done I found. Does this match your understanding of the research? Anything missing or wrong?"

Do not proceed to Step 2 until the user confirms.

### Step 2 — Build User Persona

Run `build-user-persona` using the synthesis document as input. The skill constructs one or more named personas grounded in the research findings.

Save output as `personas/[name].md`.

Present the persona(s) to the user for confirmation. Ask: "Here is the persona I built from the research. Does this feel accurate? Should I adjust anything before using it to write the Feature Request?"

Do not proceed to Step 3 until the user confirms.

### Step 3 — Write Feature Request

Run `write-feature-request` with the persona and research insights pre-loaded as context. The skill uses this grounding to produce a feature request that is tied to real user evidence rather than assumptions.

### Step 4 — Present Completed Bundle

Present the full output set to the user:

1. `research-synthesis-[slug].md` — the structured synthesis of the research input
2. `personas/[name].md` — the user persona(s) derived from the research
3. The Feature Request in standard `write-feature-request` format

Summarise how each document connects: the synthesis surfaced the themes, the persona translated them into a human context, and the FR specified what to build and why.

## Pause Points

The agent pauses for user confirmation after Step 1 and Step 2 before proceeding.

**Why this matters:** each output directly informs the next. If the synthesis misidentifies the primary JTBD, the persona will be built on a wrong foundation, and the FR will specify the wrong thing. Pausing after each step lets you catch errors when they are cheap to fix — not after the full chain has run. The pause is a quality gate, not a friction point.

## Outputs

Three saved files:

- `research-synthesis-[slug].md` — structured research synthesis with themes, pain points, and jobs-to-be-done
- `personas/[name].md` — one or more user personas derived from the synthesis
- Feature Request in the standard `write-feature-request` output format (filename determined by that skill)

## When to Use vs. Individual Skills

**Use this agent** when you are starting cold from raw research data and want to arrive at a finished FR in one session without managing skill handoffs yourself. The agent is most valuable when you have a meaningful body of research (multiple interviews, survey results, or support data) and want the full chain to run with human checkpoints.

**Use individual skills** when you only need one piece of the chain. If you already have a synthesis document and just need a persona, run `build-user-persona` directly. If you have a persona and insights and just need the FR, run `write-feature-request` directly. If you want to synthesize research without committing to a FR, run `synthesize-user-research` alone.
