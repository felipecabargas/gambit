# Gambit

<p align="center">
  <img src="assets/logo.png" alt="Gambit" width="800">
</p>

A collection of skills and chained workflow agents designed to streamline product management workflows, from research synthesis to feature specification, strategic planning, and stakeholder communication.

## Overview

This repository contains reusable skills that enhance productivity across product management, requirements definition, and quality assurance teams. Each skill is standalone but designed to work together in a comprehensive product workflow.

## Skills Included

### Core

#### verify-acceptance-criteria
Evaluate acceptance criteria quality against five key dimensions: clarity, testability, outcome-focus, measurability, and independence. Identifies gaps, scores severity levels, and generates improved versions of weak criteria.

#### write-feature-request
Guided Feature Request (FR) authoring. Assists in writing high-quality FRs by collecting structured inputs (problem, solution, outcomes, requirements) and auto-generating Acceptance Criteria for every requirement.

#### write-product-strategy
Generate comprehensive product strategy documents aligned with business goals. Helps clarify strategic direction, align teams on "where to play and how to win," and create a document that bridges vision and execution.

#### sprint-review
Turn a list of completed tickets or sprint data into a polished stakeholder report. Connects directly to JIRA or GitHub when available, groups work by theme, surfaces concrete impact metrics, and outputs a clean Markdown document ready to share with leadership.

### Discovery

#### synthesize-user-research
Synthesize raw user research (interview notes, survey results, support tickets, NPS verbatims) into structured insights: themes, pain points, jobs-to-be-done, and research gaps.

#### build-user-persona
Build evidence-backed user personas from research inputs. Creates structured persona documents grounded in evidence, with each attribute clearly labeled as research-validated or inferred.

#### competitive-analysis
Structure a competitive landscape analysis — player profiles, capability comparison matrix, whitespace opportunities, and strategic implications.

### Communication

#### write-okrs
Generate well-structured OKRs from a product strategy. Derives Objectives and Key Results from strategy pillars, challenges vague KRs, and distinguishes outputs from outcomes.

#### write-roadmap
Create a horizon-based product roadmap from strategy and OKRs. Organises work into Now/Next/Later themes derived from strategy pillars, marks items as committed vs. directional.

#### write-release-notes
Convert sprint tickets and PRs into customer-facing release notes. Filters internal/infra work, rewrites ticket titles as user benefits, and groups by category (New / Improved / Fixed).

#### write-stakeholder-update
Write a concise, data-led PM status update for leadership. Leads with a clear status signal (on track / at risk / blocked), surfaces concrete impact with numbers, and shows OKR progress.

### Handoff

#### write-technical-brief
Write an engineering handoff document from a verified Feature Request. Covers scope boundaries, technical constraints, edge cases with recommended handling, and open questions engineering needs to resolve.

## Agents

Agents are chained workflow orchestrators that run multiple skills in sequence, pausing for confirmation between steps.

### discovery-to-fr
`synthesize-user-research → build-user-persona → write-feature-request`
Takes raw user research and produces a complete Feature Request with persona context attached.

### fr-to-ready
`write-feature-request → verify-acceptance-criteria → write-technical-brief`
Takes a raw feature idea through authoring, AC verification, and engineering handoff in one flow.

### strategy-to-roadmap
`write-product-strategy → write-okrs → write-roadmap`
Takes product context through strategy, OKRs, and roadmap to produce three aligned artefacts.

### sprint-to-stakeholders
`sprint-review → write-release-notes → write-stakeholder-update`
Takes sprint data and produces all three stakeholder artefacts in a single guided workflow.

## Quick Start

```bash
# Add the marketplace, then install the plugin
/plugin marketplace add felipecabargas/gambit
/plugin install gambit@felipecabargas-gambit
```

Or see [Installation](#installation) below for non-Claude environments.

## Directory Structure

```
.
├── README.md                              # This file
├── LICENSE                                # MIT License
├── .gitignore                             # Git ignore rules
├── .claude-plugin/
│   ├── plugin.json                        # Plugin manifest
│   └── marketplace.json                   # Marketplace catalog
├── skills/
│   ├── verify-acceptance-criteria/        # Quality assurance for ACs
│   ├── write-feature-request/             # Guided FR authoring
│   ├── write-product-strategy/            # Strategic planning & document generation
│   ├── sprint-review/                     # Sprint recap & stakeholder reports
│   ├── synthesize-user-research/          # Research synthesis
│   ├── build-user-persona/                # Evidence-backed persona creation
│   ├── competitive-analysis/              # Competitive landscape analysis
│   ├── write-okrs/                        # OKR generation from strategy
│   ├── write-roadmap/                     # Horizon-based roadmap creation
│   ├── write-release-notes/               # Customer-facing release notes
│   ├── write-stakeholder-update/          # Leadership status updates
│   └── write-technical-brief/             # Engineering handoff documents
├── agents/
│   ├── discovery-to-fr/                   # Research → persona → FR workflow
│   ├── fr-to-ready/                       # FR → AC verification → tech brief workflow
│   ├── strategy-to-roadmap/               # Strategy → OKRs → roadmap workflow
│   └── sprint-to-stakeholders/            # Sprint → release notes → update workflow
├── docs/
│   ├── getting-started.md                 # Installation & usage guide
│   ├── skill-framework.md                 # Framework & philosophy
│   └── contributing.md                    # How to contribute
├── examples/
│   ├── acceptance-criteria-samples.md     # Sample evaluations
│   └── [more examples coming]
└── package.json                           # NPM metadata
```

## Installation

### Claude Plugin (recommended)

From within Claude Code, run:

```bash
/plugin marketplace add felipecabargas/gambit
/plugin install gambit@felipecabargas-gambit
```

Then run `/reload-plugins` to activate. Skills are immediately available as both model-invoked skills and slash commands (`/gambit:sprint-review`, `/gambit:verify-acceptance-criteria`, etc.).

### Optional: Superpowers

Some skills surface suggestions for `/superpowers:brainstorming` (at the start of strategy and feature request workflows) and `/superpowers:requesting-code-review` (after writing a technical brief). These come from the [Superpowers plugin](https://github.com/obra/superpowers) — install it separately to use them. Gambit works fully without it.

### Manual Install (non-Claude environments)

```bash
# Copy individual skills
cp -r skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r skills/* ~/.claude/skills/
```

## Usage

Skills are automatically available in Claude once installed. Trigger them by describing what you need:

**verify-acceptance-criteria:**
- "Review these acceptance criteria and tell me if they're good"
- "Verify that these ACs are testable"
- "Rewrite these acceptance criteria to be clearer"

**write-feature-request:**
- "Write a feature request for [feature idea]"
- "Turn this customer problem into a proper FR"
- "Draft a feature specification with acceptance criteria for [idea]"

**write-product-strategy:**
- "Help me write a product strategy for [product]"
- "Generate a STRATEGY.md for [context]"
- "Update our existing product strategy"

**sprint-review:**
- "Write my sprint review for Sprint 42"
- "Summarize what we shipped this sprint"
- "Generate a sprint recap for stakeholders"

**synthesize-user-research:**
- "Synthesize these interview notes into themes and pain points"
- "Pull out the jobs-to-be-done from these user research findings"
- "What are the key insights from this NPS feedback?"

**write-okrs:**
- "Generate OKRs from our product strategy"
- "Turn these strategy pillars into Objectives and Key Results"
- "Write Q3 OKRs based on this strategy document"

## Contributing

Contributions are welcome! See `docs/contributing.md` for guidelines on creating new skills or improving existing ones.

## License

MIT License - see LICENSE file for details.

## Support

For issues, questions, or feedback about these skills, please open an issue or discussion in this repository.
