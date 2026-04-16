# Acceptance Criteria Evaluation Examples

This document provides real-world examples of acceptance criteria evaluations using the verify-acceptance-criteria skill.

## Example 1: E-commerce Product Page

### Input Criteria

```
- Users can view product images
- The product page loads quickly
- Users can add items to their cart
- Product reviews are displayed
- Users can filter by color and size
```

### Skill Evaluation Report

```json
{
  "summary": {
    "total_criteria": 5,
    "passed": 1,
    "failed": 4,
    "critical_issues": 3,
    "major_issues": 5,
    "minor_issues": 2,
    "overall_score": 52
  },
  "evaluations": [
    {
      "id": 1,
      "criterion": "Users can view product images",
      "status": "passed",
      "issues": [],
      "score": 100
    },
    {
      "id": 2,
      "criterion": "The product page loads quickly",
      "status": "failed",
      "issues": [
        {
          "dimension": "Measurability",
          "severity": "critical",
          "description": "'Quickly' is subjective and not quantified. Different users and networks have different expectations."
        },
        {
          "dimension": "Testability",
          "severity": "major",
          "description": "Without a specific time metric, QA cannot objectively pass or fail this criterion."
        }
      ],
      "score": 60,
      "rewritten_option": "The product page (including all product images, reviews, and related items) loads within 2 seconds on a standard 4G connection"
    },
    {
      "id": 3,
      "criterion": "Users can add items to their cart",
      "status": "passed",
      "issues": [
        {
          "dimension": "Measurability",
          "severity": "minor",
          "description": "Consider specifying success feedback (confirmation message, cart count update, etc.)"
        }
      ],
      "score": 80
    },
    {
      "id": 4,
      "criterion": "Product reviews are displayed",
      "status": "failed",
      "issues": [
        {
          "dimension": "Clarity",
          "severity": "critical",
          "description": "What does 'displayed' mean? How many reviews? In what order? With what information?"
        },
        {
          "dimension": "Measurability",
          "severity": "major",
          "description": "No specification of review count, format, or sorting criteria."
        },
        {
          "dimension": "Testability",
          "severity": "major",
          "description": "Without knowing the success criteria, QA won't know when to pass this."
        }
      ],
      "score": 40,
      "rewritten_option": "The product page displays the 5 most recent reviews (sorted by date, newest first), showing reviewer name, date, star rating, and review text"
    },
    {
      "id": 5,
      "criterion": "Users can filter by color and size",
      "status": "failed",
      "issues": [
        {
          "dimension": "Independence",
          "severity": "major",
          "description": "This criterion depends on understanding which product variants exist (color and size options)"
        },
        {
          "dimension": "Clarity",
          "severity": "minor",
          "description": "Does filtering happen on-page or does it reload? Should it update product recommendations?"
        }
      ],
      "score": 70,
      "rewritten_option": "Users can filter the product variants by color and size using dropdown menus, and the page updates immediately to show only available variants matching the selected filters"
    }
  ],
  "recommendations": [
    "Add specific performance metrics (load time in seconds, measured on standard 4G)",
    "Clarify what 'displayed' means for reviews (count, order, content)",
    "Specify the interaction model for filters (dropdowns, checkboxes, instant update, page reload?)",
    "Consider adding a criterion about mobile responsiveness",
    "Define success metrics for cart interactions (confirmation message, animation, redirect?)"
  ]
}
```

### Analysis

**Overall Score: 52 - Needs Improvement**

These criteria started with good intent but lacked specificity. Three critical issues prevented them from being testable:

1. **"Quickly" is not quantified** - Different people measure speed differently
2. **"Displayed" is ambiguous** - What counts as displaying reviews?
3. **"Filter" lacks detail** - Which filtering mechanism? How does the page respond?

The evaluations above provide rewritten versions that address these issues. The improved versions would score 85+, indicating they're ready for development.

---

## Example 2: Mobile App Authentication

### Input Criteria

```
Given a new user visits the app
When they tap the "Sign Up" button
Then they should be able to create an account

Given a registered user
When they enter their credentials
Then they should be logged in

The password should be secure
The app should remember the user
```

### Skill Evaluation Report

```json
{
  "summary": {
    "total_criteria": 5,
    "passed": 1,
    "failed": 4,
    "critical_issues": 2,
    "major_issues": 4,
    "minor_issues": 3,
    "overall_score": 58
  },
  "evaluations": [
    {
      "id": 1,
      "criterion": "Given a new user visits the app, when they tap the Sign Up button, then they should be able to create an account",
      "status": "passed",
      "issues": [
        {
          "dimension": "Clarity",
          "severity": "minor",
          "description": "Could be more specific about what 'create an account' means (email, username, password requirements?)"
        }
      ],
      "score": 85
    },
    {
      "id": 2,
      "criterion": "Given a registered user, when they enter their credentials, then they should be logged in",
      "status": "passed",
      "issues": [
        {
          "dimension": "Testability",
          "severity": "minor",
          "description": "Consider specifying what 'logged in' means (token received? Redirect to home screen? Account data loaded?)"
        }
      ],
      "score": 85
    },
    {
      "id": 3,
      "criterion": "The password should be secure",
      "status": "failed",
      "issues": [
        {
          "dimension": "Measurability",
          "severity": "critical",
          "description": "'Secure' is highly subjective. Define specific requirements: minimum length? Complexity? Encryption standard?"
        },
        {
          "dimension": "Testability",
          "severity": "major",
          "description": "QA needs clear criteria to verify security (e.g., 'Passwords must be 12+ characters with mixed case')"
        },
        {
          "dimension": "Clarity",
          "severity": "critical",
          "description": "Does this mean validation rules? Transport security (HTTPS)? Storage encryption? All of the above?"
        }
      ],
      "score": 30,
      "rewritten_option": "Passwords must be at least 12 characters, contain uppercase and lowercase letters, at least one number, and one special character. Passwords are encrypted using bcrypt before storage and transmitted via HTTPS only"
    },
    {
      "id": 4,
      "criterion": "The app should remember the user",
      "status": "failed",
      "issues": [
        {
          "dimension": "Clarity",
          "severity": "critical",
          "description": "'Remember' is ambiguous. Does this mean 'don't require login on next app launch'? 'Auto-fill username'? 'Store biometric data'?"
        },
        {
          "dimension": "Measurability",
          "severity": "major",
          "description": "How long should the session persist? Until logout? 30 days? Never? Without a duration, this is unmeasurable."
        },
        {
          "dimension": "Independence",
          "severity": "major",
          "description": "This criterion depends on understanding security implications and session management strategy"
        }
      ],
      "score": 35,
      "rewritten_option": "After successful login, the user session persists for 30 days without requiring re-authentication. If the user logs out or doesn't use the app for 30+ days, they must log in again on next app launch"
    }
  ],
  "recommendations": [
    "Break the 'secure password' criterion into separate criteria for validation rules, transport security, and storage encryption",
    "Define session duration and behavior for 'remember user' functionality",
    "Add criteria for error handling (invalid password, account locked, network errors)",
    "Consider adding criteria for biometric authentication if that's part of the feature",
    "Clarify what account data needs to be available immediately after login"
  ]
}
```

### Analysis

**Overall Score: 58 - Needs Rework Before Development**

This example shows a common pattern: Gherkin format criteria work well for user flows, but business rules (security, persistence) need more specificity.

**Key Issues:**
1. **"Secure" needs definition** - Security requirements vary by context and compliance
2. **"Remember" is too vague** - Session duration and behavior are critical implementation details
3. **Mixing layers** - Authentication logic, storage, and user experience are bundled

**What Worked:**
- The Given-When-Then scenarios were clear and testable
- Acceptance criteria followed good BDD patterns initially

**What Was Needed:**
- Specific password requirements (not just "secure")
- Clear session management rules (not just "remember")
- Separation of concerns (UX vs. security vs. data persistence)

---

## Example 3: Admin Dashboard Report Feature

### Input Criteria

```
- Admins can generate sales reports
- Reports show data for the selected time period
- Reports can be exported as PDF
- Reports load in reasonable time
- Users can filter the report by product category
```

### Skill Evaluation Report

```json
{
  "summary": {
    "total_criteria": 5,
    "passed": 2,
    "failed": 3,
    "critical_issues": 1,
    "major_issues": 3,
    "minor_issues": 2,
    "overall_score": 70
  },
  "evaluations": [
    {
      "id": 1,
      "criterion": "Admins can generate sales reports",
      "status": "passed",
      "issues": [],
      "score": 100
    },
    {
      "id": 2,
      "criterion": "Reports show data for the selected time period",
      "status": "passed",
      "issues": [],
      "score": 100
    },
    {
      "id": 3,
      "criterion": "Reports can be exported as PDF",
      "status": "passed",
      "issues": [
        {
          "dimension": "Measurability",
          "severity": "minor",
          "description": "Consider specifying PDF formatting (logo? Headers? Page breaks for large reports?)"
        }
      ],
      "score": 85
    },
    {
      "id": 4,
      "criterion": "Reports load in reasonable time",
      "status": "failed",
      "issues": [
        {
          "dimension": "Measurability",
          "severity": "critical",
          "description": "'Reasonable time' is subjective. For admin tools, is 5 seconds acceptable? 30 seconds? This must be quantified."
        },
        {
          "dimension": "Testability",
          "severity": "major",
          "description": "Without a specific metric, QA cannot measure success. Different users will have different opinions."
        }
      ],
      "score": 40,
      "rewritten_option": "Reports for date ranges up to 90 days load within 5 seconds; reports for larger date ranges (90+ days) load within 30 seconds, with a loading indicator shown to the user"
    },
    {
      "id": 5,
      "criterion": "Users can filter the report by product category",
      "status": "failed",
      "issues": [
        {
          "dimension": "Clarity",
          "severity": "major",
          "description": "'Filter' is vague about interaction model. Is it checkboxes? Dropdowns? Type-ahead search?"
        },
        {
          "dimension": "Independence",
          "severity": "minor",
          "description": "This criterion assumes product categories are defined elsewhere; context would help"
        }
      ],
      "score": 75,
      "rewritten_option": "Users can select one or more product categories from a multi-select dropdown to filter the report data. Selecting/deselecting categories updates the report within 2 seconds without a page reload"
    }
  ],
  "recommendations": [
    "Specify load time metrics based on report scope (30 days vs. 90 days vs. 1 year)",
    "Clarify the interaction model for filtering (what UI component?)",
    "Consider adding criteria for concurrent user handling (e.g., 'Report generation completes for 10 concurrent users within X seconds')",
    "Define what happens if a report takes longer than the threshold (timeout? Partial results? Notification?)",
    "Add a criterion for data accuracy (e.g., 'Reported sales match transactional database within a 5-minute delay')"
  ]
}
```

### Analysis

**Overall Score: 70 - Getting Close, Minor Fixes Needed**

These criteria were reasonably specific but had one critical gap: performance metrics without context.

**What Worked Well:**
- Clear user permissions (admins only)
- Specific output format (PDF)
- Actionable filtering capability

**What Needed Improvement:**
- "Reasonable time" needed quantification with context (large vs. small reports)
- Filter mechanism needed specificity (dropdowns vs. checkboxes)
- Edge cases weren't addressed (what if report takes too long?)

**Post-Improvement Score: 85+**

After implementing the recommendations, these criteria would be ready for development, with clear metrics and specific interaction patterns.

---

## Key Learnings Across Examples

### Pattern 1: Vague Time References

**Before**: "loads quickly", "responds in reasonable time"
**After**: "loads within 2 seconds on 4G", "responds within 500ms"

**Why It Matters**: Different users measure speed differently. Developers and QA need an objective metric.

### Pattern 2: Ambiguous Adjectives

**Before**: "should be secure", "display properly", "work well"
**After**: Specific requirements or measurable outcomes

**Why It Matters**: These words mean different things to different people. Definitions prevent rework.

### Pattern 3: Missing Context

**Before**: "filter the data"
**After**: "filter the data using checkboxes; selection updates the table within 1 second"

**Why It Matters**: Context prevents implementation surprises and reduces QA clarification questions.

### Pattern 4: Business Rules vs. UX

**Before**: Mixing "users remember login" with "password must be secure"
**After**: Separate criteria for session management, password validation, and encryption

**Why It Matters**: Different teams own different aspects. Separation makes assignments clear.

## Using These Examples

These examples demonstrate:
1. **How the skill evaluates real criteria** - See what it looks for
2. **Common issues** - Recognize patterns in your own criteria
3. **Rewriting patterns** - Examples of improvements
4. **Scoring ranges** - What passes, what needs work
5. **Recommendations** - How to think about completeness

When reviewing your own criteria, ask:
- Are there vague time references? ("quickly", "soon", "responsive")
- Are there unmeasurable adjectives? ("good", "secure", "proper")
- Is the interaction model clear? (dropdown vs. button vs. modal)
- Could someone else implement this without asking clarifying questions?

If you answer "no" to any, use the patterns above to improve.
