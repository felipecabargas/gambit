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

# Frontmatter must open and close with ---
DELIMITERS=$(grep -c "^---$" "$SKILL_FILE" || true)
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

# Required body sections (skills)
for section in "## When to Use" "## How" "## Output"; do
  if ! grep -q "$section" "$SKILL_FILE"; then
    echo "WARNING: Expected section '$section' not found in $SKILL_FILE"
  fi
done

echo "✓ $SKILL_FILE — valid"
