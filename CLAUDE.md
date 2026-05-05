# Gambit

Provides thirteen product management skills and four chained workflow agents, available both as model-invoked skills and slash commands.

## Available Skills

### Core
- **verify-acceptance-criteria** (`/gambit:verify-acceptance-criteria`) — evaluate AC quality against five dimensions
- **write-feature-request** (`/gambit:write-feature-request`) — guided FR authoring with auto-generated ACs
- **write-product-strategy** (`/gambit:write-product-strategy`) — generate product strategy documents
- **sprint-review** (`/gambit:sprint-review`) — turn sprint data into stakeholder-ready reports
- **prioritize** (`/gambit:prioritize`) — score and rank features or initiatives using RICE, ICE, or MoSCoW

### Discovery
- **synthesize-user-research** (`/gambit:synthesize-user-research`) — synthesize raw research into structured themes, pain points, and jobs-to-be-done
- **build-user-persona** (`/gambit:build-user-persona`) — build evidence-backed user personas from research inputs
- **competitive-analysis** (`/gambit:competitive-analysis`) — structure a competitive landscape analysis with player profiles and whitespace opportunities

### Communication
- **write-okrs** (`/gambit:write-okrs`) — generate well-structured OKRs derived from a product strategy
- **write-roadmap** (`/gambit:write-roadmap`) — create a horizon-based product roadmap from strategy and OKRs
- **write-release-notes** (`/gambit:write-release-notes`) — convert sprint tickets and PRs into customer-facing release notes
- **write-stakeholder-update** (`/gambit:write-stakeholder-update`) — write a concise, data-led PM status update for leadership

### Handoff
- **write-technical-brief** (`/gambit:write-technical-brief`) — write an engineering handoff document from a verified Feature Request

## Available Agents

- **discovery-to-fr** (`/gambit:discovery-to-fr`) — end-to-end research-to-spec workflow: synthesize-user-research → build-user-persona → write-feature-request
- **fr-to-ready** (`/gambit:fr-to-ready`) — feature-request-to-dev-ready workflow: write-feature-request → verify-acceptance-criteria → write-technical-brief
- **strategy-to-roadmap** (`/gambit:strategy-to-roadmap`) — full strategy-to-execution workflow: write-product-strategy → write-okrs → write-roadmap
- **sprint-to-stakeholders** (`/gambit:sprint-to-stakeholders`) — full sprint-to-communications workflow: sprint-review → write-release-notes → write-stakeholder-update
