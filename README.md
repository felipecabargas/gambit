# Gambit

<p align="center">
  <img src="assets/logo.png" alt="Gambit" width="800">
</p>

A collection of skills and chained workflow agents designed to streamline product management workflows, from research synthesis to feature specification, strategic planning, and stakeholder communication.

## Quick Start

```bash
/plugin marketplace add felipecabargas/gambit
/plugin install gambit@felipecabargas-gambit
```

Or see [Installation](#installation) below for manual and non-Claude environments.

## Skills

| Category | Skill | What it does |
|---|---|---|
| Core | `verify-acceptance-criteria` | Score ACs against five quality dimensions, flag gaps, and rewrite weak criteria |
| Core | `write-feature-request` | Guided FR authoring with auto-generated ACs for every requirement |
| Core | `write-product-strategy` | Generate a `STRATEGY.md` with pillars tied to research evidence |
| Core | `sprint-review` | Turn ticket lists or sprint data into a polished stakeholder report |
| Core | `prioritize` | Score and rank features using RICE, ICE, or MoSCoW grounded in your strategy |
| Discovery | `synthesize-user-research` | Pull themes, pain points, and jobs-to-be-done from raw research |
| Discovery | `build-user-persona` | Build evidence-backed personas with research-validated vs. inferred attributes |
| Discovery | `competitive-analysis` | Player profiles, capability matrix, and whitespace opportunities |
| Communication | `write-okrs` | Derive Objectives and Key Results from a product strategy |
| Communication | `write-roadmap` | Horizon-based roadmap (Now/Next/Later) from strategy and OKRs |
| Communication | `write-release-notes` | Customer-facing release notes from sprint tickets and PRs |
| Communication | `write-stakeholder-update` | Data-led leadership status update with OKR progress |
| Handoff | `write-technical-brief` | Engineering handoff document from a verified Feature Request |

## Agents

Agents chain multiple skills in sequence, pausing for confirmation between steps.

| Agent | Chain | When to use |
|---|---|---|
| `discovery-to-fr` | synthesize-user-research → build-user-persona → write-feature-request | Raw research → finished FR |
| `fr-to-ready` | write-feature-request → verify-acceptance-criteria → write-technical-brief | Feature idea → dev-ready handoff |
| `strategy-to-roadmap` | write-product-strategy → write-okrs → write-roadmap | Start of a planning cycle |
| `sprint-to-stakeholders` | sprint-review → write-release-notes → write-stakeholder-update | End of every sprint |

## Installation

### Claude Plugin (recommended)

From within Claude Code, run:

```bash
/plugin marketplace add felipecabargas/gambit
/plugin install gambit@felipecabargas-gambit
```

Skills are immediately available as both model-invoked skills and slash commands (`/gambit:sprint-review`, `/gambit:verify-acceptance-criteria`, etc.).

### Gemini CLI

```bash
gemini extensions install https://github.com/felipecabargas/gambit
```

Update later:

```bash
gemini extensions update gambit
```

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

Skills activate from natural language — just describe what you need. See [docs/getting-started.md](docs/getting-started.md) for trigger examples, common workflows, and tips.

## Directory Structure

```
.
├── README.md
├── LICENSE
├── .claude-plugin/
│   ├── plugin.json                        # Plugin manifest
│   └── marketplace.json                   # Marketplace catalog
├── skills/
│   ├── prioritize/
│   ├── verify-acceptance-criteria/
│   ├── write-feature-request/
│   ├── write-product-strategy/
│   ├── sprint-review/
│   ├── synthesize-user-research/
│   ├── build-user-persona/
│   ├── competitive-analysis/
│   ├── write-okrs/
│   ├── write-roadmap/
│   ├── write-release-notes/
│   ├── write-stakeholder-update/
│   └── write-technical-brief/
├── agents/
│   ├── discovery-to-fr/
│   ├── fr-to-ready/
│   ├── strategy-to-roadmap/
│   └── sprint-to-stakeholders/
├── docs/
│   ├── getting-started.md
│   ├── skill-framework.md
│   └── contributing.md
└── package.json
```

## Contributing

Contributions are welcome! See `docs/contributing.md` for guidelines on creating new skills or improving existing ones.

## License

MIT License - see LICENSE file for details.

## Support

For issues, questions, or feedback, please open an issue or discussion in this repository.
