# Contributing to Gambit

We welcome contributions! This guide explains how to report issues, suggest improvements, and create new skills.

## Code of Conduct

All contributors are expected to:
- Treat each other with respect
- Provide constructive feedback
- Focus on ideas, not individuals
- Help make product management better for everyone

## How to Contribute

### 1. Report Issues

If a skill doesn't work as expected or has a limitation:

1. **Check Existing Issues** - Search to avoid duplicates
2. **Provide Context** - What were you trying to do?
3. **Share Input** - Paste (sanitized) examples if helpful
4. **Note Output** - What did you get vs. what did you expect?
5. **Suggest Ideas** - How might it be improved?

Example:
```
Title: Acceptance criteria skill doesn't recognize Gherkin format

Context: I was reviewing a feature with Given-When-Then format criteria

Input:
Given the user is logged in
When they click the profile button
Then they see their profile page

Expected: The skill would recognize this as a Gherkin scenario

Actual: The skill treated it as plain text and missed some context

Suggestion: Add specific handling for Gherkin format to improve analysis
```

### 2. Suggest Improvements

Have an idea to make a skill better? Open a suggestion with:

1. **Skill Name** - Which skill does this improve?
2. **Current Behavior** - How does it work today?
3. **Proposed Behavior** - What would be better?
4. **Why It Matters** - Who benefits and how?
5. **Potential Tradeoffs** - What might be harder if we do this?

Example:
```
Title: Add ability to evaluate criteria across multiple languages

Current: Skills only evaluate English criteria

Proposed: Accept criteria in multiple languages and evaluate quality

Why: Global teams often write criteria in their native language before translation

Tradeoffs: Requires language-specific guidance on clarity and testability
```

### 3. Contribute a New Skill

Want to create a new skill? The process has several stages:

#### Stage 1: Proposal

Open an issue titled "New Skill: [Name]" with:

1. **Purpose** - What problem does this skill solve?
2. **Use Cases** - 3-5 specific scenarios where it's valuable
3. **Input** - What does the user provide?
4. **Output** - What does the skill produce?
5. **Related Skills** - How does it fit with existing skills?

Example:
```
Title: New Skill: feature-complexity-scorer

Purpose: Estimate implementation complexity for features

Use Cases:
1. Before sprint planning to estimate story points
2. When evaluating the scope of new requests
3. To identify features that need decomposition
4. For capacity planning across multiple teams

Input: Feature description, acceptance criteria, technical context

Output: Complexity score (1-10) with breakdown by dimension:
- UI complexity
- Data model changes
- Integration requirements
- Testing scope

Related Skills: Works with spec-writer, roadmap-update
```

#### Stage 2: Framework Definition

Once approved, define the skill's evaluation framework:

1. **Dimensions** - What aspects do you evaluate? (3-5 typically)
2. **Severity Levels** - How important is each issue type?
3. **Scoring** - How do you calculate an overall score?
4. **Examples** - Show good vs. poor cases for each dimension

#### Stage 3: Documentation

Document the skill following the framework in `/docs/skill-framework.md`:

1. **When to Use** - Specific triggers and scenarios
2. **Input Format** - Multiple examples in different formats
3. **Evaluation Framework** - Full details on dimensions
4. **Output Format** - Examples with explanation
5. **How It Works** - Step-by-step process
6. **Pro Tips** - Advanced usage patterns
7. **Examples** - Real before/after cases
8. **Triggers** - Natural language phrases

#### Stage 4: Implementation

Create the skill in the repository:

```
skills/[skill-name]/
├── SKILL.md           # Full documentation
└── examples/          # Optional: example outputs
    ├── input1.txt
    └── output1.json
```

#### Stage 5: Review and Iteration

1. Submit your skill for review
2. Incorporate feedback from maintainers
3. Share with a pilot group of users
4. Refine based on real-world usage
5. Release as part of the repository

### 4. Improve Existing Skills

To enhance an existing skill:

1. **Identify the Gap** - What's missing or could be better?
2. **Propose a Solution** - How would you change it?
3. **Test the Change** - Does it work with real examples?
4. **Update Documentation** - Keep docs in sync with changes
5. **Gather Feedback** - How do others respond?

### 5. Share Examples

Real-world examples help everyone. To contribute an example:

1. Create a markdown file with your example
2. Include input and output
3. Explain why this case was valuable
4. Add to `/examples/`

Example:
```markdown
## E-commerce Checkout Flow

### Input Criteria
- The checkout page loads within 3 seconds
- Users can see their order total
- Payment processing is secure
- Confirmation email is sent

### Skill Evaluation
[Include the skill's output report]

### Key Learnings
- "Secure" was flagged as non-measurable (critical issue)
- "Sent" lacks timing specification (major issue)
- Load time is measurable but needed platform context (minor issue)

### Improvements Made
After feedback, criteria were rewritten to:
- Specify security standards (PCI compliance)
- Add timing requirement for email (within 5 minutes)
- Clarify "3 seconds" applied to standard 4G connection
```

## Development Guidelines

### For Skill Documentation

1. **Clarity First** - Assume readers are not experts in the domain
2. **Show Examples** - Every concept should have at least one example
3. **Be Specific** - "Fast" is bad, "2 seconds" is good
4. **Use Markdown** - Consistent formatting across skills
5. **Link Context** - Reference related concepts and skills

### For Skill Creation

1. **Follow the Framework** - Use the pattern in `/docs/skill-framework.md`
2. **Test Thoroughly** - Try with real criteria from your domain
3. **Document Edge Cases** - What inputs might break it?
4. **Provide Rationale** - Why score this way, not another?
5. **Make It Actionable** - Every issue should have a suggestion

### For Examples

1. **Use Real Cases** - Real examples are more valuable than hypothetical
2. **Sanitize as Needed** - Remove confidential information
3. **Explain the Lesson** - Why is this example valuable?
4. **Show the Evolution** - Before and after if applicable
5. **Diverse Domains** - Ecommerce, SaaS, Mobile, Enterprise, etc.

## Pull Request Process

1. **Fork the Repository** - Create your own copy
2. **Create a Branch** - Use descriptive names (e.g., `add-complexity-scorer`)
3. **Make Your Changes** - Follow guidelines above
4. **Test Thoroughly** - Verify with multiple examples
5. **Update README** - If adding a new skill
6. **Write Clear Commit Messages** - What changed and why?
7. **Submit a Pull Request** - Reference any related issues

## Review Process

Pull requests will be reviewed for:

1. **Quality** - Does it follow the framework?
2. **Clarity** - Can others understand and use it?
3. **Completeness** - All sections documented?
4. **Examples** - Real examples that help?
5. **Consistency** - Aligned with existing skills?

Reviewers may request changes. We'll work with you iteratively to get it right.

## Questions or Need Help?

1. **Check Documentation** - Most answers are in the docs
2. **Search Issues** - Similar questions might be answered
3. **Open a Discussion** - For questions (not bug reports)
4. **Email Maintainers** - For private conversations

## Recognition

Contributors are recognized in:
1. The CONTRIBUTORS file
2. Commit history
3. Skill documentation (if contributing a skill)
4. Release notes for major contributions

Thank you for helping make product management better!
