---
name: write-feature-request
description: |
  Guided Feature Request (FR) authoring. Assists the user in writing a high-quality FR by collecting structured inputs (problem, solution, outcomes, requirements), then auto-generates Acceptance Criteria for every requirement. If any AC cannot be written due to missing information, the skill identifies the gaps and prompts the user. Returns a polished FR in Markdown with nested ACs, open questions, and risks.

  Use this skill whenever a user needs to author or improve a feature request. Trigger on: "write a feature request", "help me write an FR", "create a feature spec", "draft a feature proposal", "I want to define a new feature", "turn this idea into a feature request", or similar requests.
compatibility: "Requires filesystem access to project directory. Works best with markdown and project context documents."
version: 1.0.0
argument-hint: "[feature idea or problem]"
allowed-tools: [Read, Write, Bash]
---

# Feature Request Author

## When to Use

Use this skill to create high-quality, structured feature requests. It's most valuable when:
- You have an idea or problem but need help shaping it into a full FR
- You want to ensure requirements are complete before handing off to engineering
- You need to produce an FR with testable Acceptance Criteria (ACs) built in
- You want to surface open questions and risks before work begins
- You are preparing a feature for backlog refinement or stakeholder review

---

## How the Skill Works

The skill runs in a **multi-step conversation**. At each step it asks focused questions, evaluates the quality of your answers, and only proceeds when it has enough information to produce excellent output.

### Phase 1 — Information Gathering

The skill collects four foundational inputs:

| Input | Questions Asked |
|---|---|
| **Problem** | What pain or gap exists? Who is affected? What is the evidence this is a real problem? |
| **Solution** | What do we want to build to solve it? What does it look like or do? What does it not do? |
| **Outcomes** | What customer value does this deliver? What changes for users if this is shipped? |
| **Requirements** | What must the feature do (functional) and how well must it do it (non-functional)? Each requirement is captured independently with its type. |

The skill accepts loose, conversational answers and structures them — you don't need to write formally.

### Phase 2 — AC Generation and Quality Gate

For every requirement collected, the skill attempts to generate at least one concrete Acceptance Criterion (AC). A good AC must be:
- **Specific** — unambiguous, with no room for individual interpretation
- **Testable** — a QA engineer can write a test for it without guessing
- **Outcome-focused** — describes the result the user experiences
- **Measurable** — quantified where relevant (times, counts, thresholds)

**If an AC cannot be written**, it means the requirement is underdetermined. The skill will:
1. Identify which requirement is blocking AC generation
2. Explain exactly what information is missing
3. Ask targeted follow-up questions to fill the gap
4. Re-attempt AC generation after the user responds

This loop continues until every requirement has at least one valid AC.

### Phase 3 — FR Assembly

Once all ACs are validated, the skill assembles the complete FR in the output format below and returns it to the user.

---

## Output Format

The skill returns the FR in the following Markdown structure:

```markdown
# [Feature Title]

## Problem

[Clear description of the problem, who it affects, and the evidence for it.]

## Solution

[Description of what will be built and its boundaries (what's in/out of scope).]

## Outcomes (Customer Value)

[What changes for users or the business if this feature ships. Written from the customer's perspective.]

## Requirements

### Functional Requirements

#### REQ-1: [Requirement Name]
> **Type**: Functional

[Description of the requirement]

| # | Acceptance Criterion | Notes |
|---|---|---|
| AC-1 | [Criterion] | [Optional context] |
| AC-2 | [Criterion] | [Optional context] |

#### REQ-2: [Requirement Name]
> **Type**: Functional

[Description]

| # | Acceptance Criterion | Notes |
|---|---|---|
| AC-1 | [Criterion] | |

### Non-Functional Requirements

#### NFR-1: [Requirement Name]
> **Type**: Non-Functional — [Performance | Security | Accessibility | Reliability | Scalability | Usability | Compliance]

[Description]

| # | Acceptance Criterion | Notes |
|---|---|---|
| AC-1 | [Criterion] | |

## Open Questions

| # | Question | Owner | Status |
|---|---|---|---|
| 1 | [Question] | [Role or person] | Open |

## Risks

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| 1 | [Risk description] | High / Medium / Low | High / Medium / Low | [Mitigation idea] |
```

---

## Evaluation Framework

When generating ACs, the skill evaluates each requirement against the following:

### AC Quality Dimensions

| Dimension | Description | Failure Mode |
|---|---|---|
| **Specificity** | Is the behavior defined precisely enough that two people would interpret it the same way? | Vague verbs ("works well", "is fast", "feels intuitive") |
| **Testability** | Can QA write an automated or manual test that unambiguously passes or fails? | No clear trigger, action, or outcome described |
| **Outcome-Focus** | Does the AC describe what the user experiences, not how the system implements it? | Implementation details creep ("the database must use...") |
| **Measurability** | Are thresholds, counts, or time bounds specified where relevant? | Relative/subjective metrics ("significantly faster") |

### Severity of AC Gaps

| Severity | Meaning | Action |
|---|---|---|
| 🚫 **Blocker** | AC cannot be written at all — the requirement is too vague or contradictory | Skill pauses and requests clarification before continuing |
| ⚠️ **Warning** | AC can be written but with assumptions — assumptions are made explicit | Skill writes the AC with a note flagging the assumption |
| ✅ **Pass** | AC is fully deterministic and testable | AC is included in the FR |

### Minimum Quality Gate

The FR is only assembled when **all requirements have at least one `✅ Pass` AC**. Requirements with only `⚠️ Warning` ACs are included, but assumptions are surfaced in the Open Questions section for the team to resolve.

---

## Requirement Types

When collecting requirements, the skill classifies each into a type. This classification is used to:
- Choose the right AC pattern for that requirement
- Group requirements in the output (Functional vs. Non-Functional)
- Surface the right risks

| Type | Description | Example |
|---|---|---|
| **Functional** | What the system must do | "Users can filter results by date range" |
| **Performance** | Speed, throughput, or latency targets | "The page loads in under 1.5s on a 4G connection" |
| **Security** | Access control, data protection, compliance | "Only the account owner can access billing records" |
| **Accessibility** | WCAG or assistive technology compliance | "All interactive elements are keyboard-navigable" |
| **Reliability** | Uptime, fault tolerance, error recovery | "The feature degrades gracefully on API timeout" |
| **Scalability** | Volume, concurrency, or growth targets | "Supports up to 10,000 concurrent users" |
| **Usability** | UX quality or learnability expectations | "A first-time user can complete the flow in under 2 minutes" |
| **Compliance** | Regulatory or legal requirements | "Meets GDPR data deletion requirements" |

---

## Open Questions and Risks

After generating the FR, the skill automatically identifies:

### Open Questions
- Assumptions made during AC generation that require confirmation
- Requirements that depend on decisions not yet made
- Areas where stakeholder alignment is needed

### Risks
- Technical risks (implementation complexity, dependencies)
- Product risks (scope creep, edge cases not covered)
- Business risks (compliance exposure, customer impact if something fails)

---

## Pro Tips

**1. Be rough with your inputs.** The skill is designed to work with messy, incomplete thoughts — it will ask for what it needs.

**2. Push back on vague requirements.** If you find yourself answering "I'm not sure" more than twice about the same requirement, that requirement probably isn't ready and should become an open question.

**3. Use NFRs deliberately.** Most FRs are light on non-functional requirements, which causes surprises in implementation. The skill will prompt you to consider performance, security, and accessibility.

**4. Treat the AC table as a contract.** The AC table in the output is written to be directly usable as a QA checklist. Share it with engineering as-is.

**5. Iterate fast.** You can re-run Phase 2 on any single requirement by asking: "Rework the ACs for requirement [X]" — it will only regenerate that section.

---

## Example Conversation

**Trigger:**
> "Help me write a feature request for letting users export their data"

**Skill — Phase 1 Questions:**
> Let's build your FR. I'll start with the problem.
>
> 1. **Problem**: Who is asking to export data, and what are they trying to do with it that they can't do today? Is there any data (support tickets, churn signals, user feedback) that shows how often this is a pain point?

**User:**
> Power users are asking us for a way to get their data out so they can do analysis in Excel. We get about 10 support requests a month for this and it consistently shows up in NPS verbatims.

**Skill:**
> Got it. Now the solution.
>
> 2. **Solution**: What format should the export be in (CSV, JSON, Excel, all of the above)? What data is included — everything, or specific sections? Is this a one-time download or can they schedule recurring exports? Any data that should explicitly be **excluded**?

*(... conversation continues through outcomes and requirements ...)*

**Skill — Phase 2, AC Blocker Example:**
> ⚠️ I can't write a testable AC for requirement **REQ-3: "Export should be fast"** — "fast" is not measurable.
>
> Can you tell me:
> - What's the maximum acceptable wait time for a user after clicking "Export"?
> - Does this vary by data volume (e.g., users with 10k rows vs. 1M rows)?

**User:**
> Under 5 seconds for most users, maybe up to 30 seconds for large accounts.

**Skill:**
> ✅ Got it. I'll write two ACs:
> - AC-1: For accounts with fewer than 100,000 rows, the export file is available within 5 seconds of the user initiating the export.
> - AC-2: For accounts with 100,000 rows or more, the export is processed asynchronously and the user receives an email with a download link within 30 seconds.

*(... continues until all requirements have ACs, then returns the full FR ...)*

---

## How to Trigger This Skill

Ask Claude to write a feature request by saying things like:
- "Write a feature request for [feature idea]"
- "Help me define a new feature for [context]"
- "Turn this customer problem into a proper FR"
- "Draft a feature specification for [feature]"
- "I need to write up a feature, can you help?"
- "Create a feature request with acceptance criteria for [idea]"

Claude will automatically invoke this skill, guide you through the conversation, and return a fully structured FR in Markdown.
