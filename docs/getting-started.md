# Getting Started with Product Skills

This guide walks you through installing and using the product skills in your Claude environment.

## Installation

### Option A: Claude Plugin (recommended)

```bash
claude plugin install github:felipecabargas/product-skills
```

That's it. Skills are immediately available as model-invoked skills and slash commands. No restart required.

### Option B: Manual Install (non-Claude environments)

Use this if you are not using Claude Code or prefer manual control.

**Step 1: Locate your Claude skills directory**

The default location is `~/.claude/skills/`. Create it if it doesn't exist:

```bash
mkdir -p ~/.claude/skills
```

**Step 2: Copy skills**

```bash
# Copy individual skill
cp -r product-skills/skills/verify-acceptance-criteria/ ~/.claude/skills/

# Or copy all skills at once
cp -r product-skills/skills/* ~/.claude/skills/
```

**Step 3: Verify installation**

```bash
ls -la ~/.claude/skills/
```

You should see:
```
verify-acceptance-criteria/
├── SKILL.md
write-feature-request/
├── SKILL.md
write-product-strategy/
├── SKILL.md
sprint-review/
├── SKILL.md
```

**Step 4: Restart Claude**

Restart Claude Code to load the newly installed skills.

---

## Using the Skills

### Acceptance Criteria Verifier

Evaluates acceptance criteria quality and identifies gaps before development starts.

**Basic Usage:**

```
Review these acceptance criteria and tell me if they're good:
- The user can search for products
- Results display within 2 seconds
- Filters work correctly
```

**Advanced Usage:**

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
- Structured JSON evaluation report
- Issues identified by severity (critical / major / minor)
- Rewritten versions of weak criteria
- Overall quality score (80+ = ready for development)

**Understanding the Evaluation:**

Each criterion is scored across five dimensions:

| Dimension | Question |
|---|---|
| **Clarity & Conciseness** | Is the language unambiguous? |
| **Testability** | Can this be objectively verified? |
| **Outcome-Focused** | Does it describe results, not steps? |
| **Measurability** | Are expectations quantified? |
| **Independence** | Does it stand alone? |

Score thresholds:
- **80+** = Good quality, ready for development
- **60–79** = Needs improvement before handoff
- **Below 60** = Requires significant rework

**Trigger phrases:**
- "Review these acceptance criteria and tell me if they're good"
- "Check if these ACs will cause problems during testing"
- "Are these acceptance criteria testable?"
- "Rewrite these acceptance criteria to be clearer"

---

### Feature Request Author

Guides you through writing a complete, high-quality Feature Request (FR) — including auto-generated Acceptance Criteria for every requirement.

The skill runs as a **multi-step conversation** across three phases:

1. **Information Gathering** — Collects problem, solution, outcomes, and requirements through focused questions. You can be rough and conversational; the skill structures your answers.
2. **AC Generation & Quality Gate** — Writes at least one testable AC per requirement. If a requirement is too vague to generate an AC, the skill explains what's missing and asks targeted follow-up questions.
3. **FR Assembly** — Returns a complete FR in Markdown with requirements, AC tables, open questions, and risks.

**What You Get Back:**

A structured Markdown document containing:
- Problem statement
- Solution description with scope boundaries
- Customer outcomes
- Functional and non-functional requirements — each with an AC table
- Open questions (including flagged assumptions)
- Risk table with likelihood, impact, and mitigations

**Trigger phrases:**
- "Write a feature request for [feature idea]"
- "Help me define a new feature for [context]"
- "Turn this customer problem into a proper FR"
- "Draft a feature specification for [feature]"
- "Create a feature request with acceptance criteria for [idea]"

**Pro tips:**
- Be rough with inputs — the skill asks for what it needs
- Use non-functional requirements deliberately: most FRs skip performance, security, and accessibility until it's too late
- The AC table in the output is written to be used directly as a QA checklist

---

### Product Strategy Generator

Generates a comprehensive `STRATEGY.md` document that bridges vision and execution. Connects strategic pillars to research evidence so the reasoning is transparent.

The skill runs in three phases:

1. **Context Gathering** — Scans your project directory for existing strategic docs (roadmaps, market research, STRATEGY.md). Adapts based on what it finds.
2. **Input & Validation** — Uses context you provide directly, or guides you through key questions if input is sparse.
3. **STRATEGY.md Generation** — Structures your input into a 7-section document with explicit research citations for each strategic pillar.

**What You Get Back:**

A `STRATEGY.md` saved to your project with:
- Executive summary and "big bet"
- Market and user context
- How we got here (research findings → strategic reasoning)
- Strategic pillars (each tied to research evidence and success metrics)
- Governance and risk
- Roadmap horizons (themes, not features)
- KPIs with a north star metric
- Key assumptions table (validated vs. speculative)

**Minimum required inputs:**
- Target audience
- Core problem(s) being solved
- At least one strategic pillar or bet
- Rough business context (market, competitive position)

**Trigger phrases:**
- "Help me write a product strategy"
- "Generate a STRATEGY.md for [product]"
- "Clarify our strategic direction for [area]"
- "Update our existing product strategy"
- "What are we betting on as a company?"

**Pro tips:**
- Prefer 3 strategic pillars — more than 3 usually means you haven't made choices yet
- The strategy should be ~2,000–3,500 words: rigorous but readable
- Roadmap features belong in a separate `Roadmap.md`; this doc sets the direction they execute against

---

### Sprint Review Generator

Turns a list of completed tickets or sprint data into a polished stakeholder report — ready to share with leadership in minutes.

The skill operates with a **bias toward action**: it infers what it can (sprint goal, team name, groupings) and only asks when something truly critical is missing.

**What You Get Back:**

A `sprint-review-[sprint-name].md` saved to your workspace with:
- Executive summary (3 sentences max — built for the 90-second reader)
- Sprint goal and outcome (hit / partially hit / missed)
- Highlights & wins with concrete numbers, not vague adjectives
- Completed work grouped by theme
- Risks, blockers, and carry-over tickets
- Sprint metrics table (completion rate, ticket count, story points if tracked)
- Looking ahead (skipped if there's nothing concrete to say)

**Data sources accepted:**
- Plain list of ticket titles or IDs
- JIRA sprint name/ID (via Atlassian MCP if connected)
- GitHub repo + date range (merged PRs / closed issues)
- A paragraph description of what shipped

**Trigger phrases:**
- "Write my sprint review for Sprint 42"
- "Summarize what we shipped this sprint"
- "Generate a sprint recap for [team] stakeholders"
- "Create a sprint report from these tickets"
- "Help me write up our iteration for leadership"

**Pro tips:**
- Paste ticket titles even if they're rough — the skill groups and rewrites them
- If you have before/after metrics anywhere in your tickets, include them; the skill will lead with numbers
- Story points are optional — the report works fine without them
- For JIRA-connected sessions, just provide the sprint name and the skill fetches completed issues automatically

---

## Common Workflows

### From Strategy to Shipped Feature

Use all four skills in sequence:

1. **write-product-strategy** → Define where to play and how to win
2. **write-feature-request** → Translate a strategic bet into a spec with requirements
3. **verify-acceptance-criteria** → Validate the ACs before handing off to engineering
4. **sprint-review** → Recap what shipped and communicate outcomes to stakeholders

### Pre-Development Review

Before starting development on a feature:

1. Gather your acceptance criteria
2. Ask `verify-acceptance-criteria` to review them
3. Use the report to discuss with stakeholders
4. Implement suggested improvements
5. Re-review if needed

### Backlog Refinement

During refinement sessions:

1. As criteria are written, ask the skill to evaluate them
2. Discuss issues identified as "critical" or "major"
3. Use suggested rewrites as starting points
4. Aim for 80+ scores before closing the item

### Team Handoff

When handing off to engineering:

1. Use `write-feature-request` to produce the FR with built-in ACs
2. Run `verify-acceptance-criteria` on the AC tables as a final check
3. Attach the evaluation report to the ticket
4. Reference rewritten criteria if engineering has questions

### Strategy Refresh

When updating your direction:

1. Share the current STRATEGY.md with `write-product-strategy`
2. Tell it what's changed (market, users, competitive position, new research)
3. The skill updates only what needs to change and preserves the rest

---

## Tips for Best Results

### Be Specific About Context
Mention domain, platform, or audience when relevant:

```
These are acceptance criteria for an ecommerce mobile app.
Please review with mobile UX considerations in mind.
```

### Group Related Criteria
Organize criteria by component or user flow for cleaner reports:

```
Checkout flow:
- [criteria 1–3]

Payment processing:
- [criteria 4–5]
```

### Iterate, Don't Perfect
You don't need perfect inputs on the first pass:

1. First pass: Identify all issues
2. Second pass: Focus on critical issues only
3. Third pass: Polish the final versions

---

## Troubleshooting

### Skill Not Found

If a skill doesn't appear in Claude:
1. Verify the folder is in `~/.claude/skills/[skill-name]/`
2. Check that `SKILL.md` exists inside it
3. Restart Claude Code
4. Try a fresh conversation

### Unexpected Output

1. Check that your input is clearly formatted
2. Try a different format (bullet points instead of Gherkin, etc.)
3. Be more explicit in your request
4. Share an example of the output you want

### Performance Issues

1. Review fewer criteria at once (10–15 maximum for the AC verifier)
2. Break large feature reviews into multiple requests
3. Clear your chat history and start fresh

---

## Next Steps

- Review `skill-framework.md` to understand how these skills are designed
- Check `../examples/acceptance-criteria-samples.md` for real-world examples
- Read full skill documentation in each `../skills/[skill-name]/SKILL.md`
- Explore how to contribute new skills in `contributing.md`
