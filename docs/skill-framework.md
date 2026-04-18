# Product Skills Framework

This document explains the philosophy, design principles, and patterns that underlie all skills in this repository.

## Philosophy

Product skills are designed to augment human judgment, not replace it. Each skill:

1. **Supports Decision-Making** - Provides structured analysis to inform decisions
2. **Respects Context** - Acknowledges that different organizations have different standards
3. **Surfaces Tradeoffs** - Highlights tensions and requires human judgment to resolve
4. **Improves Over Time** - Gets better with feedback and iteration
5. **Integrates with Workflows** - Fits into existing processes rather than forcing change

## Core Principles

### 1. Clarity Over Completeness

Skills prioritize clear, actionable output over exhaustive analysis. When there's a choice between:
- A comprehensive report that takes 10 minutes to digest
- A focused report highlighting the top 3 issues

The skill prioritizes the focused report.

### 2. Structured Output

All skills produce output in structured formats (JSON, markdown tables, etc.) that can be:
- Easily scanned by humans
- Integrated into tools and workflows
- Compared and tracked over time
- Shared across teams

### 3. Multiple Input Formats

Skills accept input in multiple formats because teams work differently:
- Plain text lists
- Structured formats (Gherkin, JSON)
- Files (CSV, Excel)
- Mixed formats in a single request

### 4. Severity-Based Prioritization

Issues are categorized by impact:
- **Critical** - Must be resolved before proceeding
- **Major** - Should be resolved but won't block work
- **Minor** - Nice to improve, but not essential

This allows teams to make pragmatic decisions about what to fix now vs. later.

### 5. Actionable Recommendations

Every skill provides:
- Identification of issues
- Explanation of why they matter
- Concrete examples of improvements
- Paths forward for remediation

## Skill Design Pattern

Each skill in this repository follows a consistent design pattern:

### Section 1: When to Use
Clear guidance on when the skill adds value, with specific scenarios.

### Section 2: Input Format
Multiple ways to provide input, with examples for each format.

### Section 3: Evaluation Framework
If evaluating something, the criteria used and how severity is determined.

### Section 4: Output Format
Structure of the output with examples and explanation.

### Section 5: How It Works
Step-by-step explanation of the skill's process.

### Section 6: Pro Tips
Advanced usage patterns and best practices.

### Section 7: Examples
Real examples showing before/after or weak/strong cases.

### Section 8: How to Trigger
Natural language phrases that invoke the skill.

## Evaluation Frameworks

Product skills use evaluation frameworks to assess quality. Each framework:

1. **Identifies Multiple Dimensions** - Good quality has many aspects
2. **Applies Severity Levels** - Not all issues are equally important
3. **Provides Scoring** - Quantitative feedback for tracking improvement
4. **Suggests Improvements** - Moves beyond "this is wrong" to "here's better"

### Example: verify-acceptance-criteria Framework

**Dimensions:**
- Clarity & Conciseness
- Testability
- Outcome-Focus
- Measurability
- Independence

**Severity Levels:**
- Critical (45% of score)
- Major (35% of score)
- Minor (20% of score)

**Scoring:**
- Pass threshold: 80+
- Actionable feedback: Specific issues and rewrites

### Example: write-feature-request Framework

**AC Quality Gate:**
- Blocker — requirement too vague to generate any AC; skill pauses and asks targeted follow-ups
- Warning — AC can be written with assumptions; assumptions surfaced in Open Questions
- Pass — AC is specific, testable, outcome-focused, and measurable

**Requirement Types:**
- Functional, Performance, Security, Accessibility, Reliability, Scalability, Usability, Compliance

**Minimum gate:** Every requirement must have at least one Pass AC before the FR is assembled.

### Example: write-product-strategy Framework

**Required inputs:**
- Target audience
- Core problem(s) grounded in research
- At least 3 strategic pillars (each tied to evidence)
- Primary success metric

**Assumption tracking:**
- Each assumption classified as Validated or Speculative
- Risk if wrong stated explicitly

**Output scope:** ~2,000–3,500 words covering executive summary, market context, strategic reasoning, pillars, governance, roadmap horizons, KPIs, and assumptions.

## Integration Patterns

Skills are designed to integrate with common workflows:

### 1. End-to-End Product Workflow
```
write-product-strategy → write-feature-request → verify-acceptance-criteria
```
Start with strategic direction, translate into a spec, validate criteria before engineering handoff.

### 2. Document Review Workflow
```
Write criteria → verify-acceptance-criteria → Discuss findings → Revise → Re-evaluate
```

### 3. Team Handoff Workflow
```
write-feature-request → verify-acceptance-criteria → Attach report to ticket → Engineer reviews
```

### 4. Quality Audit Workflow
```
Collect existing criteria → verify-acceptance-criteria → Analyze patterns → Implement improvements
```

### 5. Strategy Refresh Workflow
```
Existing STRATEGY.md + new research → write-product-strategy → Updated STRATEGY.md
```

### 6. Tool Integration Workflow
```
Export criteria as JSON → verify-acceptance-criteria → Import report → Integrate with project management tool
```

## Extensibility

Skills in this framework are designed to be extended:

### Adding New Dimensions
To add a dimension to an existing evaluation framework:

1. Define the new dimension clearly
2. Provide examples of good vs. poor performance
3. Explain how it impacts the overall score
4. Update documentation and examples

### Creating New Skills
To create a new skill following this framework:

1. Define when the skill should be used
2. Choose an evaluation framework (or create a new one)
3. Document input/output formats
4. Provide clear examples
5. Build in iterative improvement capability

### Customizing for Your Organization
Teams can customize skills by:
- Adjusting severity thresholds
- Adding organization-specific dimensions
- Modifying example criteria
- Integrating with internal tools

## Quality Standards

All skills maintain these quality standards:

### Documentation
- Clear, concise, and accessible
- Multiple examples with explanations
- Real-world context and use cases
- Troubleshooting guidance

### Reliability
- Consistent results across similar inputs
- Clear explanation of limitations
- Graceful handling of edge cases
- Transparent about when human judgment is needed

### Usability
- Natural language triggers
- Multiple input formats
- Structured, scannable output
- Integration with common tools

### Maintainability
- Clear structure and documentation
- Version tracking for improvements
- Community feedback mechanisms
- Regular updates and refinement

## Feedback and Improvement

Skills improve through feedback. To contribute:

1. **Report Issues** - If a skill misses something or gives unexpected results
2. **Suggest Examples** - Real-world cases that should be handled better
3. **Request Features** - New dimensions, output formats, or integration points
4. **Share Improvements** - Rewrites of documentation or framework enhancements

See `contributing.md` for detailed guidelines.

## Philosophy in Practice

### verify-acceptance-criteria

**Clarity Over Completeness**
- Reports top issues, not exhaustive analysis
- Severity focus guides prioritization

**Structured Output**
- JSON reports importable into tools
- Clear dimension/issue mapping

**Multiple Input Formats**
- Plain text, Gherkin, CSV/Excel, mixed

**Severity-Based**
- Critical = testing blockage
- Major = ambiguity for implementation
- Minor = polishing opportunities

**Actionable Recommendations**
- Every issue includes a rewritten example

### write-feature-request

**Clarity Over Completeness**
- Guided questions extract only what's needed — no bloated templates
- AC quality gate enforces specificity before assembling the FR

**Structured Output**
- Markdown FR with nested AC tables, open questions, and risks
- AC table usable directly as a QA checklist

**Iterative Improvement**
- Blockers surface missing information precisely
- Any single requirement's ACs can be reworked in isolation

**Actionable Recommendations**
- Open questions flag assumptions requiring stakeholder alignment
- Risk table includes likelihood, impact, and mitigations

### write-product-strategy

**Transparency Over Assertion**
- Every strategic pillar linked to specific research evidence
- Assumptions labeled validated vs. speculative

**Structured Output**
- STRATEGY.md saved to project directory
- 7-section format covering context → pillars → roadmap → metrics → assumptions

**Supports Decision-Making**
- Research evidence explicitly connected to strategic choices
- "How We Got Here" section makes reasoning auditable

**Integrates with Workflows**
- Scans existing project docs before asking questions
- Updates only changed sections when refreshing existing strategy

## Future Directions

As this skill collection grows, we envision:

1. **Integrated Workflows** - Skills that work together end-to-end
2. **Custom Frameworks** - Organization-specific evaluation dimensions
3. **Tool Ecosystem** - Integration with product management tools
4. **Community Skills** - User-contributed specialized skills
5. **Adaptive Learning** - Skills that improve based on team feedback

## Questions?

For questions about the framework, see `contributing.md` or open an issue in the repository.
