# Product Skills Repository

A collection of Claude skills designed to streamline product management workflows, from acceptance criteria verification to feature specification and strategic analysis.

## Overview

This repository contains reusable Claude skills that enhance productivity across product management, requirements definition, and quality assurance teams. Each skill is standalone but designed to work together in a comprehensive product workflow.

## Skills Included

### verify-acceptance-criteria
Evaluate acceptance criteria quality against five key dimensions: clarity, testability, outcome-focus, measurability, and independence. Identifies gaps, scores severity levels, and generates improved versions of weak criteria.

See `/skills/verify-acceptance-criteria/SKILL.md` for detailed documentation.

## Quick Start

1. Install skills to your Claude environment: `~/.claude/skills/`
2. Reference the `getting-started.md` guide in `/docs`
3. Review example evaluations in `/examples`

## Directory Structure

```
.
├── README.md                          # This file
├── LICENSE                            # MIT License
├── .gitignore                         # Git ignore rules
├── skills/
│   ├── verify-acceptance-criteria/
│   │   └── SKILL.md                   # Skill documentation
│   └── README.md                      # Skills index
├── docs/
│   ├── getting-started.md            # Installation & usage guide
│   ├── skill-framework.md            # Framework & philosophy
│   └── contributing.md               # How to contribute
├── examples/
│   ├── acceptance-criteria-samples.md # Sample evaluations
│   └── [more examples coming]
└── package.json                       # NPM metadata
```

## Installation

Copy skill files to your Claude Code skills directory:

```bash
# Copy individual skills
cp -r skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r skills/* ~/.claude/skills/
```

## Usage

Skills are automatically available in Claude once installed. Trigger them by describing what you need:

- "Review these acceptance criteria and tell me if they're good"
- "Verify that these ACs are testable"
- "Improve our user story criteria"

## Contributing

Contributions are welcome! See `docs/contributing.md` for guidelines on creating new skills or improving existing ones.

## License

MIT License - see LICENSE file for details.

## Support

For issues, questions, or feedback about these skills, please open an issue or discussion in this repository.
