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

# Strategy to Roadmap Agent

## Overview

This agent is a three-skill chain that produces the complete planning artefact set — strategy, OKRs, and roadmap — built and aligned in a single session. It runs `write-product-strategy`, `write-okrs`, and `write-roadmap` in sequence, with each document grounded in the one before it.

The three components and what each produces:

- **write-product-strategy** — guides you through a structured session to produce a product strategy document covering vision, strategic pillars, target customers, and success criteria; saved as `STRATEGY.md`
- **write-okrs** — reads the strategy pillars and success criteria and derives a set of Objectives and Key Results for the planning period; challenges vague KRs and distinguishes outputs from outcomes; saved as `OKRs-[period].md`
- **write-roadmap** — takes the strategy and OKRs as input and produces a horizon-based roadmap that shows how near-term work maps to strategic bets; saved as `ROADMAP.md`

## Chain

```
write-product-strategy → write-okrs → write-roadmap
```

## How It Runs

### Step 1 — Write the Product Strategy

Run `write-product-strategy` in full guided session mode. The skill asks questions about vision, target customers, strategic bets, competitive context, and success criteria, then produces a complete strategy document.

Save output as `STRATEGY.md`.

Pause here: present the completed strategy to the user for review. Ask: "Here is the product strategy. Does this accurately reflect your intent and priorities? Confirm to continue with OKR writing, or provide corrections first."

Do not proceed to Step 2 until the user confirms.

### Step 2 — Write OKRs

Feed the strategy pillars and success criteria from `STRATEGY.md` into `write-okrs`. The skill derives 2–4 Objectives, one per strategic pillar, and 2–4 Key Results per Objective. It challenges vague KRs and rewrites any output-focused KRs as outcome-focused ones.

Save output as `OKRs-[period].md`, where `[period]` is the planning period derived from the strategy document.

Pause here: present the OKRs to the user for review. Ask: "Here are the OKRs derived from the strategy. Do these feel right? Confirm to continue with roadmap generation, or adjust the OKRs first."

Do not proceed to Step 3 until the user confirms.

### Step 3 — Write the Roadmap

Feed the strategy (`STRATEGY.md`) and the OKRs (`OKRs-[period].md`) into `write-roadmap`. The skill produces a horizon-based roadmap (`ROADMAP.md`) that maps near-term initiatives to the OKRs they serve and the strategy pillars they advance.

Save output as `ROADMAP.md`.

### Step 4 — Present the Complete Set

Present all three documents to the user with a summary of how they connect:

1. `STRATEGY.md` — defines the direction: where you are going and why
2. `OKRs-[period].md` — defines success for the planning period: what measurable outcomes will confirm the strategy is working
3. `ROADMAP.md` — defines the execution plan: what you will build and in what order to achieve those outcomes

Explain the dependency chain: the roadmap is only as good as the OKRs, and the OKRs are only as good as the strategy. Changes to the strategy should trigger a review of the OKRs, and changes to the OKRs should trigger a review of the roadmap.

## Pause Points

The agent pauses twice:

- **After Step 1** — user reviews and confirms the strategy before OKRs are written. OKRs derive directly from strategy pillars; a misaligned strategy produces misaligned OKRs.
- **After Step 2** — user reviews and confirms the OKRs before the roadmap is written. The roadmap is structured around OKR delivery; incorrect OKRs will produce a roadmap that optimises for the wrong outcomes.

These are the only two pause points. The chain is otherwise automated.

## Outputs

Three saved files:

- `STRATEGY.md` — the full product strategy document
- `OKRs-[period].md` — the OKR set for the planning period (e.g. `OKRs-Q2-2026.md`)
- `ROADMAP.md` — the horizon-based roadmap aligned to the strategy and OKRs

## When to Use vs. Individual Skills

**Use this agent** when starting a full planning cycle from scratch — at the beginning of a quarter, a new product initiative, or a planning offsite. The agent is most valuable when you need all three documents and want them to be consistent with each other without manually managing the handoffs.

**Use individual skills** when you need to update one layer without regenerating the others. If the strategy is set and you only need to update the OKRs for a new quarter, run `write-okrs` directly. If the OKRs are locked and you only need a new roadmap cut, run `write-roadmap` directly. Re-running the full agent chain when only one document needs updating adds unnecessary work.
