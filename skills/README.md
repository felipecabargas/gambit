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

## Planned Skills

Additional skills are in development. This section will be updated as new skills are added to the repository.

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
