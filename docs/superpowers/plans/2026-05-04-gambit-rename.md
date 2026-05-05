# Gambit Rename Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rename the plugin from `product-skills` to `gambit`, updating all references in metadata and documentation so slash commands are namespaced as `/gambit:*`.

**Architecture:** Pure text replacement across 4 files plus a GitHub repo rename via API. No skill content changes. Tasks are independent and can be executed in any order, but the GitHub rename (Task 5) must happen last since it changes the remote URL.

**Tech Stack:** Markdown, JSON, GitHub API (`gh` CLI)

---

## File Map

| File | Action | Change |
|---|---|---|
| `package.json` | Modify | `name` + `repository.url` |
| `CLAUDE.md` | Modify | Heading, slash command names, install command |
| `README.md` | Modify | Title, install commands, slash command examples |
| `docs/getting-started.md` | Modify | Title, install command |
| GitHub repo | Rename via API | `product-skills` → `gambit` |

---

### Task 1: Update `package.json`

**Files:**
- Modify: `package.json`

- [ ] **Step 1: Write the new content**

Replace the entire file with:

```json
{
  "name": "gambit",
  "version": "1.0.0",
  "description": "A collection of Claude skills for product management workflows",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/felipecabargas/gambit.git"
  }
}
```

- [ ] **Step 2: Verify JSON is valid**

```bash
python3 -c "import json; json.load(open('package.json')); print('JSON valid')"
```

Expected output: `JSON valid`

- [ ] **Step 3: Commit**

```bash
git add package.json
git commit -m "chore: rename plugin to gambit"
```

---

### Task 2: Update `CLAUDE.md`

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Replace the entire file**

Write this exact content to `CLAUDE.md`:

```markdown
# Gambit

Provides four product management skills, available both as model-invoked skills and slash commands.

## Available Skills

- **verify-acceptance-criteria** (`/gambit:verify-acceptance-criteria`) — evaluate AC quality against five dimensions
- **write-feature-request** (`/gambit:write-feature-request`) — guided FR authoring with auto-generated ACs
- **write-product-strategy** (`/gambit:write-product-strategy`) — generate product strategy documents
- **sprint-review** (`/gambit:sprint-review`) — turn sprint data into stakeholder-ready reports
```

- [ ] **Step 2: Verify file content**

```bash
grep -c "gambit" CLAUDE.md
```

Expected output: `5` (heading + 4 skill lines each containing "gambit")

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for gambit rename"
```

---

### Task 3: Update `README.md`

**Files:**
- Modify: `README.md`

Four distinct replacements. Make them in order.

- [ ] **Step 1: Update the title (line 1)**

Find:
```markdown
# Product Skills Repository
```

Replace with:
```markdown
# Gambit
```

- [ ] **Step 2: Update the Quick Start install command (line 27)**

Find:
```
claude plugin install github:felipecabargas/product-skills
```

Replace with:
```
claude plugin install github:felipecabargas/gambit
```

- [ ] **Step 3: Update the Installation section install command and slash command examples (lines 59 and 62)**

Find:
```markdown
```bash
claude plugin install github:felipecabargas/product-skills
```

Skills are immediately available as both model-invoked skills and slash commands (`/sprint-review`, `/verify-acceptance-criteria`, etc.).
```

Replace with:
```markdown
```bash
claude plugin install github:felipecabargas/gambit
```

Skills are immediately available as both model-invoked skills and slash commands (`/gambit:sprint-review`, `/gambit:verify-acceptance-criteria`, etc.).
```

- [ ] **Step 4: Verify all product-skills references are gone**

```bash
grep -n "product-skills" README.md
```

Expected output: (empty — no matches)

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: update README.md for gambit rename"
```

---

### Task 4: Update `docs/getting-started.md`

**Files:**
- Modify: `docs/getting-started.md`

- [ ] **Step 1: Update the page title (line 1)**

Find:
```markdown
# Getting Started with Product Skills
```

Replace with:
```markdown
# Getting Started with Gambit
```

- [ ] **Step 2: Update the install command (line 10)**

Find:
```
claude plugin install github:felipecabargas/product-skills
```

Replace with:
```
claude plugin install github:felipecabargas/gambit
```

- [ ] **Step 3: Verify all product-skills references are gone**

```bash
grep -n "product-skills" docs/getting-started.md
```

Expected output: (empty — no matches)

- [ ] **Step 4: Commit**

```bash
git add docs/getting-started.md
git commit -m "docs: update getting-started.md for gambit rename"
```

---

### Task 5: Rename GitHub repository

**Note:** Do this last. GitHub will redirect old URLs to the new name, so the existing PR and any bookmarks remain valid. After renaming, update the local git remote URL.

- [ ] **Step 1: Rename the repo via GitHub API**

```bash
gh api repos/felipecabargas/product-skills -X PATCH -f name="gambit" --jq '.html_url'
```

Expected output: `https://github.com/felipecabargas/gambit`

- [ ] **Step 2: Update local remote URL**

```bash
git remote set-url origin git@github.com:felipecabargas/gambit.git
```

- [ ] **Step 3: Verify remote URL updated**

```bash
git remote -v
```

Expected output:
```
origin  git@github.com:felipecabargas/gambit.git (fetch)
origin  git@github.com:felipecabargas/gambit.git (push)
```

- [ ] **Step 4: Push branch to new remote**

```bash
git push -u origin felipe/sprint-review
```

Expected: push succeeds (GitHub redirects, then updates)

---

## Self-Review

**Spec coverage:**
- ✅ `package.json` name + URL updated (Task 1)
- ✅ `CLAUDE.md` heading + slash commands + install command updated (Task 2)
- ✅ `README.md` title + install commands + slash command examples updated (Task 3)
- ✅ `docs/getting-started.md` title + install command updated (Task 4)
- ✅ GitHub repo renamed (Task 5)

**Placeholder scan:** None. Every step has exact content or exact commands.

**Consistency:** `gambit` appears as the plugin name in all 4 files. `/gambit:*` slash command format is consistent in `CLAUDE.md` and `README.md`. Install command `github:felipecabargas/gambit` is consistent across `README.md` (×2) and `getting-started.md` (×1).
