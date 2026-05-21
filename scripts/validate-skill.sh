#!/usr/bin/env bash
set -e

SKILL_FILE=$1
if [ -z "$SKILL_FILE" ]; then
  echo "Usage: $0 <path-to-SKILL.md>"
  exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
  echo "ERROR: File not found: $SKILL_FILE"
  exit 1
fi

WARNINGS=0

# Frontmatter must open and close with ---
DELIMITERS=$(grep -c "^---$" "$SKILL_FILE" 2>/dev/null || echo 0)
if [ "$DELIMITERS" -lt 2 ]; then
  echo "ERROR: Missing frontmatter delimiters (---) in $SKILL_FILE"
  exit 1
fi

# Required frontmatter fields
for field in name description compatibility version argument-hint allowed-tools; do
  if ! grep -q "^$field:" "$SKILL_FILE"; then
    echo "ERROR: Missing required frontmatter field '$field' in $SKILL_FILE"
    exit 1
  fi
done

# Trigger section — how users discover and invoke the skill
if ! grep -qE "^## How to Trigger|^## Frequently Asked Questions" "$SKILL_FILE"; then
  echo "WARNING: No trigger section found ('## How to Trigger' or '## Frequently Asked Questions') in $SKILL_FILE"
  WARNINGS=$((WARNINGS + 1))
fi

# Output section — what the skill produces
if ! grep -qE "^## Output|^## What You'll Get" "$SKILL_FILE"; then
  echo "WARNING: No output section found ('## Output...' or '## What You\\'ll Get') in $SKILL_FILE"
  WARNINGS=$((WARNINGS + 1))
fi

# Process section — how the skill runs
if ! grep -qE "^## Step [0-9]|^## How (the Skill Works|It Works|It Works)|^## When to Use" "$SKILL_FILE"; then
  echo "WARNING: No clear process or entry-point section found in $SKILL_FILE"
  WARNINGS=$((WARNINGS + 1))
fi

if [ "$WARNINGS" -gt 0 ]; then
  echo "✓ $SKILL_FILE — valid with $WARNINGS warning(s)"
else
  echo "✓ $SKILL_FILE — valid"
fi
