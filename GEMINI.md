# Gambit

Gambit provides twelve product management skills and four chained workflow agents for product management workflows.

Activate any skill or agent using `activate_skill gambit:<name>`.

## Skills

### Core
- **`gambit:verify-acceptance-criteria`** — evaluate AC quality against five dimensions (clarity, testability, outcome-focus, measurability, independence). Trigger on: "review these ACs", "are these acceptance criteria good", "rewrite these ACs".
- **`gambit:write-feature-request`** — guided FR authoring with auto-generated acceptance criteria. Trigger on: "write a feature request", "help me write an FR", "create a feature spec".
- **`gambit:write-product-strategy`** — generate product strategy documents aligned with business goals. Trigger on: "write a product strategy", "help me write a STRATEGY.md".
- **`gambit:sprint-review`** — turn sprint data into a polished stakeholder report. Trigger on: "write my sprint review", "summarize what we shipped", "generate a sprint recap".

### Discovery
- **`gambit:synthesize-user-research`** — synthesize raw research into themes, pain points, and jobs-to-be-done. Trigger on: "synthesize my research", "extract insights from this feedback".
- **`gambit:build-user-persona`** — build evidence-backed user personas from research inputs. Trigger on: "build a persona", "create user personas from this research".
- **`gambit:competitive-analysis`** — structure a competitive landscape analysis with player profiles and whitespace opportunities. Trigger on: "run a competitive analysis", "map out our competitive landscape".

### Communication
- **`gambit:write-okrs`** — generate well-structured OKRs derived from a product strategy. Trigger on: "generate OKRs from our strategy", "write Q3 OKRs".
- **`gambit:write-roadmap`** — create a horizon-based (Now/Next/Later) roadmap from strategy and OKRs. Trigger on: "write a roadmap", "create our ROADMAP.md".
- **`gambit:write-release-notes`** — convert sprint tickets and PRs into customer-facing release notes. Trigger on: "write release notes", "turn these tickets into release notes".
- **`gambit:write-stakeholder-update`** — write a concise, data-led PM status update for leadership. Trigger on: "write a stakeholder update", "write a PM status update for leadership".

### Handoff
- **`gambit:write-technical-brief`** — write an engineering handoff document from a verified Feature Request. Trigger on: "write a technical brief", "create an engineering handoff for this FR".

## Agents

Agents chain multiple skills in sequence, pausing for confirmation between steps.

- **`gambit:discovery-to-fr`** — synthesize-user-research → build-user-persona → write-feature-request. Trigger on: "turn my research into a feature request", "run discovery-to-fr".
- **`gambit:fr-to-ready`** — write-feature-request → verify-acceptance-criteria → write-technical-brief. Trigger on: "make this FR dev-ready", "get this feature ready for engineering".
- **`gambit:strategy-to-roadmap`** — write-product-strategy → write-okrs → write-roadmap. Trigger on: "help me build our strategy and roadmap", "run strategy-to-roadmap".
- **`gambit:sprint-to-stakeholders`** — sprint-review → write-release-notes → write-stakeholder-update. Trigger on: "generate all my sprint comms", "run sprint-to-stakeholders".

@./references/gemini-tools.md
