# Using Gambit in Claude Cowork

Claude Cowork is Anthropic's desktop application designed for non-technical users who want the full power of Claude — including plugins and skills — without needing a terminal, IDE, or command-line environment. If you're a PM who doesn't live in a code editor, Cowork is your starting point.

## Why Cowork for PMs

Claude Code (the CLI) is built for engineers. Cowork is built for everyone else. It provides:

- A chat interface you can open like any other desktop app
- Full plugin support, including Gambit
- Slash commands and natural-language skill invocation
- No Git, no terminal, no setup beyond a one-time install

The plugin install commands that would normally require a terminal **work directly in the Cowork chat interface**. You type them as messages, and Cowork handles the rest.

---

## Installing Gambit in Cowork

Open Cowork, start a new conversation, and paste the following two lines — one at a time — into the chat:

```
/plugin marketplace add felipecabargas/gambit
```

Wait for confirmation, then:

```
/plugin install gambit@felipecabargas-gambit
```

Finally, run:

```
/reload-plugins
```

That's it. Gambit's thirteen skills and four workflow agents are now available in every conversation. No restart required.

### Alternative: manual download

If the plugin commands don't work in your version of Cowork, you can install skills by copying files manually:

1. Go to the [Gambit releases page](https://github.com/felipecabargas/gambit/releases/latest)
2. Under **Assets**, download **`gambit-skills-vX.Y.Z.zip`** (not "Source code")
3. Unzip it — you'll get a `skills/` folder
4. Copy the folders inside `skills/` into `~/.claude/skills/` on your machine
5. Restart Cowork

---

## Invoking Skills

Once Gambit is installed, you have two ways to trigger any skill.

### Natural language (recommended for PMs)

Just describe what you need. Cowork passes your message to Claude, which recognises the intent and loads the right skill automatically.

Examples:

- "Write my sprint review for Sprint 24 — here are the tickets we closed: ..."
- "Summarise this user research into themes and pain points"
- "Help me write a feature request for the new notification centre"
- "Generate a stakeholder update — we're on track but the mobile push is slipping"

You don't need to know the skill name. Describe the outcome you want.

### Slash commands (explicit invocation)

If you want to invoke a specific skill directly, prefix it with `/gambit:`:

| What you want to do | Command |
|---|---|
| Sprint report for stakeholders | `/gambit:sprint-review` |
| Feature Request with ACs | `/gambit:write-feature-request` |
| Verify acceptance criteria | `/gambit:verify-acceptance-criteria` |
| Synthesise user research | `/gambit:synthesize-user-research` |
| Build a user persona | `/gambit:build-user-persona` |
| Write a product strategy | `/gambit:write-product-strategy` |
| Generate OKRs | `/gambit:write-okrs` |
| Build a roadmap | `/gambit:write-roadmap` |
| Write release notes | `/gambit:write-release-notes` |
| Stakeholder status update | `/gambit:write-stakeholder-update` |
| Engineering handoff doc | `/gambit:write-technical-brief` |
| Competitive analysis | `/gambit:competitive-analysis` |
| Prioritise a backlog | `/gambit:prioritize` |

Slash commands and natural language produce the same results — use whichever feels more comfortable.

---

## End-to-End Example: Sprint to Stakeholders

The **sprint-to-stakeholders** workflow is the fastest way to see what Gambit can do. It chains three skills — sprint-review, write-release-notes, and write-stakeholder-update — to turn a list of closed tickets into three ready-to-send documents.

### Step 1: Gather your sprint data

Before you open Cowork, collect:
- The sprint name and dates (e.g. "Sprint 24, April 28–May 9")
- A list of completed tickets (copy-paste from Jira, Linear, or wherever you track work)
- Any headline metrics: completion rate, story points, key wins or misses

Rough notes are fine. The skill will structure them.

### Step 2: Kick off the workflow

In Cowork, type:

```
/gambit:sprint-to-stakeholders
```

Or just say: *"Run the sprint-to-stakeholders workflow for Sprint 24."*

### Step 3: Paste your sprint data when prompted

The workflow will ask for your sprint data if you haven't already included it. Paste your ticket list and any context. Example input:

```
Sprint 24 — April 28 to May 9
Team: Growth

Completed:
- [GROW-441] Redesigned onboarding email sequence
- [GROW-447] A/B test: new pricing page variant (launched to 20% of traffic)
- [GROW-451] Fixed broken unsubscribe link (bug, P1)
- [GROW-455] Dashboard load time reduced from 4.2s to 1.8s
- [GROW-460] Added CSV export to the reports module

Carry-over:
- [GROW-448] Referral programme — backend done, front-end 80% complete

Metrics: 5 of 6 tickets closed. No story points tracked.
```

### Step 4: Review and confirm between steps

The workflow pauses after each skill and shows you the output before continuing. You can approve it as-is, ask for changes, or add context before moving to the next step.

After three confirmations you will have:

1. **Sprint review report** — a structured Markdown document with executive summary, completed work grouped by theme, metrics, and risks. Ready to share with your eng lead or post in Confluence.
2. **Release notes** — customer-facing copy that filters internal work, rewrites ticket titles as user benefits, and groups by New / Improved / Fixed. Ready for your changelog or product newsletter.
3. **Stakeholder update** — a one-page leadership update with a clear status signal (on track / at risk / blocked), OKR progress, and any decisions needed. Ready to paste into Slack or an email.

The whole workflow takes about ten minutes, most of which is waiting for Claude to write.

---

## Tips for Cowork Users

**Start conversationally.** You don't need to format your input perfectly. Say what you know; the skill will ask for what's missing.

**Paste context early.** If you have research notes, a strategy doc, or a ticket list, include it in your first message. Claude reads it and uses it throughout the conversation.

**One workflow per conversation.** Cowork conversations carry full context, so Claude remembers what you said three messages ago. Start a fresh conversation for each workflow to keep outputs clean and focused.

**Save outputs before closing.** Cowork doesn't auto-save generated documents to your filesystem. Copy the output Markdown into Notion, Confluence, Google Docs, or wherever your team works.
