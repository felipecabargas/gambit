---
name: write-release-notes
description: |
  Convert sprint tickets and PRs into customer-facing release notes. Filters internal/infra work,
  rewrites ticket titles as user benefits, groups by category (New / Improved / Fixed), and adapts
  tone to the target channel.

  Trigger on: "write release notes", "turn these tickets into release notes", "what should we put
  in the changelog", "draft our release announcement", "write our changelog for [version]", or
  after a sprint-review session.
compatibility: "Requires filesystem access to project directory. Works best with sprint review docs or ticket lists."
version: 1.0.0
argument-hint: "[paste tickets/PRs or sprint name]"
allowed-tools: [Read, Write, Bash]
---

# Release Notes Writer

## When to Use

Use this skill when you need to turn internal sprint or release output into clear, customer-facing communication. It adds the most value when:

- **After every sprint or release** — converting raw ticket output into polished release notes is time-consuming and error-prone when done manually. This skill does the filtering, rewriting, and grouping in one pass.
- **When publishing a changelog** — a public changelog requires a consistent voice, accurate grouping (New vs. Improved vs. Fixed), and zero internal jargon. This skill enforces all three.
- **When preparing a product announcement** — release announcements need a highlights section that leads with customer impact, not a flat list of tickets. This skill surfaces the most impactful items and writes the opening narrative automatically.

## Input Format

The skill accepts several input forms. The richer the input, the better the filtering and rewriting.

**Sprint review output from `sprint-review`:**
```
Path: ./sprint-review-2026-05-05.md
```

**Pasted ticket list (with or without descriptions):**
```
- PROJ-1042: Refactor auth middleware to use JWT
- PROJ-1043: Add bulk CSV export to reporting page
- PROJ-1044: Fix crash on mobile when attachment > 5MB
- PROJ-1045: Upgrade React to 18.3
- PROJ-1046: Users can now set a custom notification schedule
```

**PR list from a release branch:**
```
PR #312: feat: add CSV export to reports
PR #314: fix: mobile crash on large attachment upload
PR #315: chore: upgrade React 18.3
PR #316: refactor: auth middleware JWT migration
```

**Optionally, channel context** to set the tone:
```
Channel: in-app tooltip / email announcement / public changelog / marketing landing page
```

If no channel is specified, the skill defaults to public changelog tone and notes the assumption.

## Filtering Rules

The first and most important step is filtering. Only customer-visible work belongs in release notes. Everything else is noise that dilutes the signal and wastes readers' attention.

**The filter test:** "Would a customer notice if this item was not shipped?" If the answer is no, it is excluded.

### What Passes the Filter

- New features or capabilities users can directly access
- Meaningful improvements to existing workflows that change user experience (faster, easier, more reliable from the user's perspective)
- Bug fixes that affected users in a noticeable way (crashes, data loss, incorrect output, broken flows)
- Performance improvements users can feel (page load, export speed, search latency)

**Examples that pass:**
- "Bulk CSV export added to the reporting page" — users gain a new capability
- "Mobile app no longer crashes when uploading attachments over 5MB" — users experience a fixed breakage
- "Search results now load in under 300ms (was 1.2s)" — users notice the speed improvement

### What Gets Filtered Out

- Infrastructure changes (database migrations, server upgrades, CDN configuration)
- Refactors and code cleanups that do not change user-visible behaviour
- Dependency bumps and library upgrades that do not affect user experience
- Internal tooling improvements (CI/CD pipelines, test infrastructure, developer tooling)
- Test additions or coverage improvements
- Security patches that are not customer-disclosed vulnerabilities
- Documentation updates to internal wikis or developer docs

**Examples that are filtered out:**
- "Refactor auth middleware to use JWT" — no user-visible change
- "Upgrade React to 18.3" — dependency bump with no UX impact
- "Add unit tests for the CSV export module" — test coverage, not a customer feature
- "Migrate database to RDS Aurora" — infrastructure, invisible to users
- "Update CI pipeline to use GitHub Actions" — internal tooling

If the filtered list is empty (e.g. a purely technical sprint), the skill outputs a note: *"This sprint contained no customer-visible changes. Consider skipping the external changelog for this release, or bundling with the next sprint."*

## How It Works

The skill follows four steps to produce release notes that are clear, accurate, and appropriately toned.

### Step 0 — Scan Git History for Merged Work (silent)

Before filtering tickets, check whether git history can provide the source data:

```bash
# Find last release tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
echo "Last release: $LAST_TAG"
# Merged PRs since last tag
[ -n "$LAST_TAG" ] && git log --merges --oneline ${LAST_TAG}..HEAD 2>/dev/null | head -40
# Fallback: last 4 weeks if no tags
[ -z "$LAST_TAG" ] && git log --merges --oneline --since="4 weeks ago" 2>/dev/null | head -40
```

If the user hasn't provided a ticket list, use merge commit messages as the raw input and proceed to Step 1. If git history is empty or inaccessible, ask the user to paste the ticket list. Do not mention the scan.

### Step 1 — Filter to Customer-Visible Items Only

The skill applies the filter rules above to every item in the input. Filtered-out items are listed in a separate section of the working output so the PM can review and override if needed. The final release notes document contains only items that passed the filter.

If an item is ambiguous (e.g. "Improved API response handling" — is this a performance fix users notice or an internal refactor?), the skill flags it and asks: *"Does this change affect what users see or experience, or is it an internal improvement? If users will notice faster or more reliable API responses, I'll include it."*

### Step 2 — Rewrite Each Item as a User Benefit

Raw ticket titles describe what was built. Release notes should describe what the user gains. The skill rewrites every passing item from the developer's frame of reference into the user's.

The rewrite follows a simple rule: lead with what the user can now do, or what problem is now gone.

**Examples of bad titles rewritten as user benefits:**

| Original ticket title | Release notes copy |
|---|---|
| "Refactor auth middleware" | *(filtered out — no user-visible change)* |
| "Add bulk CSV export to reporting page" | "Export your full report as a CSV with one click" |
| "Fix crash on mobile when attachment > 5MB" | "Fixed: app no longer crashes when uploading large attachments on mobile" |
| "Improve search index performance" | "Search results now load up to 4x faster" |
| "Add custom notification schedule settings" | "Set your own notification schedule — choose exactly when and how often you're notified" |

If a quantified improvement is available (e.g. from a PR description or sprint data), the skill includes the number. If not, it uses relative language ("faster", "more reliable") without inventing specific figures.

### Step 3 — Group into New / Improved / Fixed

Every rewritten item is placed into one of three groups:

- **New** — capabilities that did not exist before this release. Users can now do something they could not do previously.
- **Improved** — existing capabilities that work better, faster, or are easier to use. Users notice a positive change to something they already use.
- **Fixed** — bugs or breakages that have been resolved. Users no longer experience something that was broken.

If an item could fit in multiple groups, the skill uses the primary user impact: a performance fix that also adds a new setting is **Improved** (the setting is secondary). A new feature that also fixes a bug is **New**.

### Step 4 — Write the Highlights Section

The skill identifies the 2–3 most impactful items from the filtered, rewritten list and writes a 2–3 sentence Highlights paragraph. This is the opening section of the release notes — the part a time-pressed reader sees first.

Highlights criteria: customer impact (how many users affected, how significantly?), business alignment (does this close deals, reduce churn, improve activation?), and visibility (flagship features stakeholders have been waiting for).

The highlights paragraph is written in the channel tone (see Tone Guidance below).

## Output Format

The skill saves the release notes as `release-notes-[version-or-date].md` in the current project directory. The version or date is derived from the input (sprint end date, version tag, or today's date if neither is available).

```markdown
# Release Notes — [Version or Date]

**Released:** [date]
**Prepared by:** [PM name if provided]

---

## Highlights

[2–3 sentence narrative of the most impactful items this release. Written in the target channel tone. Leads with customer benefit, not feature names.]

---

## New

- **[Feature name]:** [User benefit description.]
- **[Feature name]:** [User benefit description.]

## Improved

- **[Area]:** [What changed and how the user experiences it differently.]
- **[Area]:** [What changed.]

## Fixed

- **[What was broken]:** [What the user experienced before and what is now resolved.]
- **[What was broken]:** [Fix description.]

---

*[Optional: link to full changelog or support documentation]*
```

If a section has no items (e.g. no bugs were fixed this sprint), that section is omitted from the output.

## Tone Guidance

The same facts can be written in very different voices depending on the channel. The skill adapts to the specified channel.

**In-app (tooltip, what's new modal):**
Concise, present tense, action-oriented. The user is in the product and wants to know what changed quickly.
- "You can now export reports as CSV."
- "Search is 4x faster."
- "Fixed: large file uploads on mobile now work reliably."

**Email announcement:**
Slightly warmer, benefit-first, a sentence or two per item. The user is in their inbox and needs a reason to care.
- "We've made it easier to get your data out of [product] — you can now export any report as a CSV with a single click."
- "Uploading large files on mobile used to be unreliable. We've fixed the underlying issue — files up to 25MB now upload without errors."

**Public changelog (website or GitHub):**
Neutral, factual, developer-friendly. No marketing language. Specific where possible.
- "Added CSV export to all report views (Reports > Export > CSV)."
- "Fixed crash on iOS when uploading attachments larger than 5MB (#1044)."

**Marketing / landing page:**
Lead with customer impact. Use the strongest version of the benefit. Appropriate for a launch post or feature spotlight.
- "Your data, your way — export any report instantly with our new one-click CSV export."

## Never Do

- **Invent features** — every item in the release notes must correspond to something that was actually shipped. Do not add items from the roadmap, backlog, or wishlist.
- **Embellish impact** — do not write "revolutionary", "game-changing", or similar unless the impact genuinely warrants it (and it almost never does). Use numbers when available; use honest relative language when not.
- **Include implementation details in customer-facing copy** — phrases like "refactored the auth layer", "migrated to a new database", or "upgraded our infrastructure" belong in internal engineering notes, not release notes. Customers do not care how it was built; they care what changed for them.

## How to Trigger

Ask your assistant to write release notes by saying things like:

- "Write release notes for this sprint"
- "Turn these tickets into customer-facing release notes"
- "What should we put in the changelog for version 2.4?"
- "Draft our release announcement based on this sprint review"
- "Write our changelog entry for the May 5 release"
- "I just finished the sprint review — now write the release notes"

This skill will automatically, run the four-step process, and save the result as `release-notes-[version-or-date].md` in your project directory.
