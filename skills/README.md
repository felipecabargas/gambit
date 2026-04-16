# Skills Index

This directory contains all available Claude skills for product workflows.

## Available Skills

### verify-acceptance-criteria
**Purpose**: Evaluate and improve acceptance criteria quality

**When to use**:
- Before development starts (catch issues early)
- When auditing criteria for clarity and testability
- To convert vague requirements into precise statements
- During backlog refinement sessions

**Key features**:
- Evaluates against 5 quality dimensions
- Identifies critical, major, and minor issues
- Provides rewritten versions of weak criteria
- Generates structured JSON reports
- Supports multiple input formats

**Location**: `verify-acceptance-criteria/SKILL.md`

---

### write-feature-request
**Purpose**: Guided authoring of structured Feature Requests with auto-generated Acceptance Criteria

**When to use**:
- When turning a customer problem or product idea into a full FR
- To ensure every requirement has at least one testable AC before engineering picks it up
- During discovery and scoping to surface open questions and risks early
- To produce a handoff-ready doc with a built-in QA checklist

**Key features**:
- Interactive multi-phase conversation (problem → solution → outcomes → requirements)
- Auto-generates ACs for every requirement and blocks on missing information
- Classifies requirements as Functional or Non-Functional (with sub-type)
- Surfaces open questions and risks automatically
- Returns a complete, structured Markdown FR ready for sharing

**Location**: `write-feature-request/SKILL.md`

---

## Planned Skills

Additional skills are in development. This section will be updated as new skills are added to the repository.

---

## Installation

Each skill is self-contained and ready to use. To install:

1. Copy the skill directory to `~/.claude/skills/`
2. Restart Claude Code
3. Skills will be automatically available

## Skill Framework

All skills in this repository follow a consistent framework:
- Clear triggers and use cases
- Structured input/output formats
- Quality evaluation criteria
- Example inputs and outputs
- Pro tips for maximum value

See `../docs/skill-framework.md` for more details.
