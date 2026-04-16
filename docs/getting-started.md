# Getting Started with Product Skills

This guide walks you through installing and using the product skills in your Claude environment.

## Installation

### Step 1: Locate Your Claude Skills Directory

The default location for Claude skills is `~/.claude/skills/`. If this directory doesn't exist, create it:

```bash
mkdir -p ~/.claude/skills
```

### Step 2: Copy Skills to Your Environment

Clone or download this repository, then copy the skills:

```bash
# Copy individual skill
cp -r product-skills/skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills
cp -r product-skills/skills/* ~/.claude/skills/
```

### Step 3: Verify Installation

After copying, verify the installation:

```bash
ls -la ~/.claude/skills/
```

You should see:
```
verify-acceptance-criteria/
├── SKILL.md
```

### Step 4: Restart Claude

Restart Claude Code to load the newly installed skills. They will be automatically available in your next session.

## Using the Skills

### Acceptance Criteria Verifier

The primary skill in this collection evaluates acceptance criteria quality.

**Basic Usage:**

Simply describe what you need:

```
Review these acceptance criteria and tell me if they're good:
- The user can search for products
- Results display within 2 seconds
- Filters work correctly
```

**Advanced Usage:**

Ask for specific improvements:

```
Audit these acceptance criteria against quality standards and rewrite 
any that fail to meet the standards:
[paste your criteria]
```

**Input Formats Supported:**
- Plain text lists
- Gherkin (Given-When-Then) format
- Markdown bullet points
- CSV/Excel files
- JSON objects

**What You Get Back:**
- Evaluation report with scores
- Issues identified by severity
- Rewritten versions of weak criteria
- Actionable recommendations
- Structured JSON output

### Understanding the Report

The skill evaluates each criterion against five dimensions:

1. **Clarity & Conciseness** - Is the language unambiguous?
2. **Testability** - Can this be objectively verified?
3. **Outcome-Focused** - Does it describe results, not steps?
4. **Measurability** - Are expectations quantified?
5. **Independence** - Does it stand alone?

Each issue is marked as:
- **Critical** (~45% impact) - Prevents testing or creates major ambiguity
- **Major** (~35% impact) - Makes interpretation/testing harder
- **Minor** (~20% impact) - Could be improved but doesn't block work

**Overall Score:**
- 80+ = Good quality, ready for development
- 60-79 = Needs improvement before handoff
- Below 60 = Requires significant rework

## Common Workflows

### Pre-Development Review

Before starting development on a feature:

1. Gather your acceptance criteria
2. Ask the skill to review them
3. Use the report to discuss with stakeholders
4. Implement suggested improvements
5. Re-review with the skill if needed

### Quality Audit

When existing features have caused confusion:

1. Document the problematic criteria from your backlog
2. Ask the skill to audit them
3. Use the rewritten versions for future reference
4. Update your backlog with improved criteria

### Backlog Refinement

During refinement sessions:

1. As criteria are written, ask the skill to evaluate them
2. Discuss issues identified as "critical" or "major"
3. Use suggested rewrites as starting points
4. Aim for 80+ scores before closing the item

### Team Handoff

When handing off to engineering:

1. Evaluate all criteria with the skill
2. Include the skill's report in the ticket/story
3. Use the structured output for integration with tools
4. Reference the rewritten criteria if clarification is needed

## Tips for Best Results

### 1. Be Specific About Context
If your criteria are for a specific domain or platform, mention it:

```
These are acceptance criteria for an ecommerce mobile app.
Please review with mobile UX considerations in mind:
[criteria]
```

### 2. Group Related Criteria
If reviewing a large feature, organize criteria by component or user flow:

```
Acceptance criteria for the checkout flow:
- [criteria 1]
- [criteria 2]
- [criteria 3]

Acceptance criteria for payment processing:
- [criteria 4]
- [criteria 5]
```

### 3. Ask for Specific Formats
If you need output in a particular format:

```
Review these criteria and give me the output as:
- A JSON file I can import
- Rewritten as Gherkin scenarios
- As a user story with acceptance criteria
[criteria]
```

### 4. Iterate, Don't Perfect
You don't need perfect criteria on the first pass. Use the skill multiple times:

1. First pass: Identify all issues
2. Second pass: Focus on critical issues only
3. Third pass: Polish the final versions

## Troubleshooting

### Skill Not Found

If the skill doesn't appear in Claude:
1. Verify the file is in `~/.claude/skills/verify-acceptance-criteria/`
2. Check that `SKILL.md` exists in that directory
3. Restart Claude Code
4. Try a fresh conversation

### Strange Output

If the output doesn't match what you expected:
1. Check that your input criteria are clearly formatted
2. Try using a different format (bullet points instead of Gherkin, etc.)
3. Be more specific in your request
4. Share an example of what you'd like to see

### Performance Issues

If the skill is slow:
1. Try reviewing fewer criteria at once (10-15 maximum)
2. Break large feature reviews into multiple requests
3. Clear your chat history and start fresh

## Next Steps

- Review `skill-framework.md` to understand how these skills are designed
- Check `../examples/acceptance-criteria-samples.md` for real-world examples
- Read the full skill documentation in `../skills/verify-acceptance-criteria/SKILL.md`
- Explore how to contribute new skills in `contributing.md`
