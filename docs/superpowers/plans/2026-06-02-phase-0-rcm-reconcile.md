# Phase 0: rcm Divergence Reconcile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Commit and push the work machine's outstanding rcm-style changes to `am/dotfiles` master, after auditing for sensitive content, so both machines share a known baseline before the chezmoi migration.

**Architecture:** Repo-hygiene task. No code is written. Each task is an audit, a `git` operation, or a verification. The work happens in `~/.dotfiles` (not `~/code/am/dotfiles`).

**Tech Stack:** git, rcm conventions (file naming for `~/.dotfiles`).

**Spec:** [`docs/superpowers/specs/2026-06-02-chezmoi-migration-design.md`](../specs/2026-06-02-chezmoi-migration-design.md)

---

## Pre-flight assumptions and findings

Already confirmed via earlier inspection:
- Working directory: `/Users/amiranda/.dotfiles`. `git status` shows 23 staged + 2 unstaged paths (see Task 1 for the full list).
- `am/dotfiles` is **public** (`https://github.com/am/dotfiles`). Anything committed here is world-visible.
- `~/.dotfiles/.gitignore` already excludes `config/fish/fish_variables` and `config/fish/secrets.local.fish`.
- `config/fish/conf.d/secrets.fish` is a 3-line loader, no secrets — safe to commit.
- `config/gh/hosts.yml` contains `source.datanerd.us` (NR's GitHub Enterprise hostname) → **must not be pushed**.
- `ssh/config` head looks clean (generic `Host *` blocks); full audit in Task 2.

---

### Task 1: Establish baseline

**Files:**
- Inspect: `~/.dotfiles` (no edits)

- [ ] **Step 1: Confirm working dir and current state**

```bash
cd ~/.dotfiles
pwd
git rev-parse --abbrev-ref HEAD
git status
```

Expected: `pwd` is `/Users/amiranda/.dotfiles`; branch is `master`; status shows the staged + unstaged set listed in Pre-flight. If branch is not `master` or there are commits not in the spec's snapshot, **STOP** and reconcile with the user.

- [ ] **Step 2: Confirm origin is up to date**

```bash
git fetch origin
git status -sb
```

Expected: `## master...origin/master` with no `ahead`/`behind` count (other than the local-only spec commit `ff810f5` which is OK). If `behind`, stop and ask user — there are remote commits that should be pulled before we add more.

---

### Task 2: Audit candidates for sensitive content

**Files:**
- Inspect (no edits in this task): `config/gh/hosts.yml`, `config/cmux/cmux.json`, `config/claude-statusline/config.toml`, `ssh/config`

- [ ] **Step 1: Inspect each candidate**

```bash
cd ~/.dotfiles
echo "=== gh/hosts.yml ==="; cat config/gh/hosts.yml
echo "=== cmux/cmux.json ==="; cat config/cmux/cmux.json
echo "=== claude-statusline/config.toml ==="; cat config/claude-statusline/config.toml
echo "=== ssh/config ==="; cat ssh/config
echo "=== .gitignore (current) ==="; cat .gitignore
```

- [ ] **Step 2: Classify each file**

For each of the four files, decide one of:
- **EXCLUDE** — contains tokens, internal hostnames, customer identifiers, or other content that must not be pushed to a public repo. Will be removed from the index and added to `.gitignore`.
- **COMMIT** — content is safe for a public repo.

Pre-classified based on earlier inspection (override during Step 1 if content has changed):

| File | Default | Reason |
| --- | --- | --- |
| `config/gh/hosts.yml` | EXCLUDE | Contains `source.datanerd.us` (employer-internal hostname). |
| `config/cmux/cmux.json` | NEEDS REVIEW | Work-internal tool. Check for endpoints/API keys. |
| `config/claude-statusline/config.toml` | NEEDS REVIEW | Check for endpoints/API keys/customer identifiers. |
| `ssh/config` | COMMIT | Head shows only generic `Host *` blocks; verify the tail too. |

- [ ] **Step 3: Record decisions**

Write the final EXCLUDE list in your scratch buffer / a TodoWrite item before continuing. Example:
```
EXCLUDE: config/gh/hosts.yml, config/cmux/cmux.json
COMMIT:  config/claude-statusline/config.toml, ssh/config
```

No commit yet.

---

### Task 3: Update `.gitignore` for sensitive and tool-owned files

**Files:**
- Modify: `~/.dotfiles/.gitignore`

- [ ] **Step 1: Show current `.gitignore` (staged + unstaged combined)**

```bash
cd ~/.dotfiles
git diff HEAD -- .gitignore
```

This shows both the staged and unstaged modifications side-by-side with HEAD.

- [ ] **Step 2: Append the EXCLUDE files from Task 2 to `.gitignore`**

For each file on the EXCLUDE list, ensure a matching line exists in `.gitignore`. Example (replace with actual EXCLUDE list):

```bash
cd ~/.dotfiles
# Append only lines that aren't already there
for path in config/gh/hosts.yml; do
    grep -qxF "$path" .gitignore || echo "$path" >> .gitignore
done
cat .gitignore
```

Expected: `.gitignore` now contains every path on your EXCLUDE list in addition to `.DS_Store`, `config/fish/fish_variables`, `config/fish/secrets.local.fish`, `config/fish/completions/copilot.fish`.

- [ ] **Step 3: Verify `.gitignore` does not exclude things you do plan to commit**

```bash
cd ~/.dotfiles
git check-ignore -v config/claude-statusline/config.toml ssh/config tmux.conf 2>&1
```

Expected: empty output (none of these match an ignore pattern). If any line of output appears, an ignore pattern is too broad — fix before continuing.

---

### Task 4: Unstage and untrack the EXCLUDE files

**Files:**
- Modify: git index for files on EXCLUDE list. Working tree copies are preserved on disk.

- [ ] **Step 1: Remove each EXCLUDE file from the index**

For each file on the EXCLUDE list, run (replace `<path>`):

```bash
cd ~/.dotfiles
git restore --staged <path>
```

Example with the default list:
```bash
git restore --staged config/gh/hosts.yml
```

- [ ] **Step 2: Verify**

```bash
cd ~/.dotfiles
git status --short
```

Expected: every EXCLUDE path now appears either as untracked (`??`) or not at all (if it was already tracked previously). It must NOT appear as staged (`A `, `M `).

- [ ] **Step 3: Confirm the file is now ignored**

```bash
cd ~/.dotfiles
git check-ignore -v config/gh/hosts.yml   # repeat per EXCLUDE file
```

Expected: each file matches a line in `.gitignore`.

- [ ] **Step 4: Confirm the working tree copy is intact**

```bash
cd ~/.dotfiles
ls -la config/gh/hosts.yml   # repeat per EXCLUDE file
```

Expected: file still exists. If a file was a previously-tracked file (not "new"), `git restore --staged` is sufficient and it remains tracked at HEAD's version. For brand-new files (`A` status), `git restore --staged` makes them untracked and the ignore pattern then takes effect.

---

### Task 5: Stage `.gitignore` updates

**Files:**
- Stage: `~/.dotfiles/.gitignore`

- [ ] **Step 1: Stage `.gitignore`**

```bash
cd ~/.dotfiles
git add .gitignore
git diff --cached -- .gitignore
```

Expected: diff shows the new EXCLUDE entries appended; no unrelated changes.

---

### Task 6: Final pre-commit safety scan

**Files:**
- Inspect: full staged diff

- [ ] **Step 1: List all staged paths**

```bash
cd ~/.dotfiles
git diff --cached --name-status
```

Expected: lists `.gitignore` plus the previously staged files MINUS the EXCLUDE set.

- [ ] **Step 2: Grep the staged diff for sensitive patterns**

```bash
cd ~/.dotfiles
git diff --cached | grep -iE 'token|secret|password|api[_-]?key|datanerd|newrelic|nr-internal|customer' || echo "CLEAN"
```

Expected: prints `CLEAN`. If any match appears, **STOP** and triage — either the match is a false positive (e.g. literal "secrets.fish" filename in a `secrets.fish` file source comment) or another file needs to be added to EXCLUDE. Do not proceed to commit until output is `CLEAN` or all matches are documented as false positives.

- [ ] **Step 3: Confirm `fish_variables` is still ignored, not staged**

```bash
cd ~/.dotfiles
git status --short config/fish/fish_variables
```

Expected: empty output (file is ignored). If a `M ` or `A ` entry appears, run `git restore --staged config/fish/fish_variables` before continuing.

---

### Task 7: Commit logical group 1 — fish shell config

**Files:**
- Commit (subset of currently-staged):
  - Adds: `config/fish/completions/sesh.fish`, `config/fish/conf.d/fish_frozen_key_bindings.fish`, `config/fish/conf.d/fish_frozen_theme.fish`, `config/fish/conf.d/secrets.fish`, `config/fish/functions/s.fish`
  - Deletes: `config/fish/conf.d/z.fish`, `config/fish/functions/__z.fish`, `config/fish/functions/__z_add.fish`, `config/fish/functions/__z_clean.fish`, `config/fish/functions/__z_complete.fish`
  - Modifies: `config/fish/config.fish`, `config/fish/fish_plugins`

- [ ] **Step 1: Stage exactly this group**

The files above are already staged from the snapshot in Task 1. Verify nothing extra is in this commit by using path-scoped commit in Step 2.

- [ ] **Step 2: Commit with path scope**

```bash
cd ~/.dotfiles
git commit -m "Replace built-in z with sesh; add frozen theme and key bindings" -- \
  config/fish/completions/sesh.fish \
  config/fish/conf.d/fish_frozen_key_bindings.fish \
  config/fish/conf.d/fish_frozen_theme.fish \
  config/fish/conf.d/secrets.fish \
  config/fish/functions/s.fish \
  config/fish/conf.d/z.fish \
  config/fish/functions/__z.fish \
  config/fish/functions/__z_add.fish \
  config/fish/functions/__z_clean.fish \
  config/fish/functions/__z_complete.fish \
  config/fish/config.fish \
  config/fish/fish_plugins
```

- [ ] **Step 3: Verify**

```bash
cd ~/.dotfiles
git log --oneline -1
git show --stat HEAD | head -30
git status --short
```

Expected: HEAD is the new commit, stat shows the 12 paths above, and `git status` no longer lists any of them.

---

### Task 8: Commit logical group 2 — work tooling configs

**Files:**
- Commit:
  - Adds: `config/claude-statusline/config.toml`, `config/cmux/cmux.json` (only if these survived the EXCLUDE audit), `config/gh/config.yml`, `config/htop/htoprc`, `config/git/ignore`

If `config/cmux/cmux.json` and/or `config/claude-statusline/config.toml` ended up on the EXCLUDE list in Task 2, omit them from the path list below.

- [ ] **Step 1: Commit**

Default path list (adjust per EXCLUDE results):

```bash
cd ~/.dotfiles
git commit -m "Add cmux, claude-statusline, gh, htop, and git/ignore configs" -- \
  config/claude-statusline/config.toml \
  config/cmux/cmux.json \
  config/gh/config.yml \
  config/htop/htoprc \
  config/git/ignore
```

If you excluded `cmux.json` and `claude-statusline/config.toml`, the line becomes:

```bash
git commit -m "Add gh, htop, and git/ignore configs" -- \
  config/gh/config.yml \
  config/htop/htoprc \
  config/git/ignore
```

- [ ] **Step 2: Verify**

```bash
cd ~/.dotfiles
git log --oneline -2
git show --stat HEAD
```

Expected: HEAD reflects this commit; only the listed paths are in it.

---

### Task 9: Commit logical group 3 — terminal and ssh tweaks

**Files:**
- Commit:
  - Modifies: `config/ghostty/config`, `config/iterm2/AppSupport`, `tmux.conf`, `ssh/config`

- [ ] **Step 1: Commit**

```bash
cd ~/.dotfiles
git commit -m "Update ghostty, iterm2, tmux, and ssh configs" -- \
  config/ghostty/config \
  config/iterm2/AppSupport \
  tmux.conf \
  ssh/config
```

- [ ] **Step 2: Verify**

```bash
cd ~/.dotfiles
git log --oneline -3
git show --stat HEAD
```

Expected: HEAD reflects this commit with exactly the four paths.

---

### Task 10: Commit logical group 4 — `.gitignore` update

**Files:**
- Commit: `~/.dotfiles/.gitignore`

- [ ] **Step 1: Commit**

```bash
cd ~/.dotfiles
git commit -m "Ignore tool-owned and machine-local files" -- .gitignore
```

- [ ] **Step 2: Verify clean working tree**

```bash
cd ~/.dotfiles
git status
```

Expected: `working tree clean` apart from any **untracked** EXCLUDE files (e.g. `config/gh/hosts.yml`) which should appear under "Untracked" only if they aren't gitignored, and should NOT appear at all if they are. `config/fish/fish_variables` should not appear (gitignored).

If any unstaged or staged change remains other than untracked-and-ignored, **STOP** and triage.

---

### Task 11: Push to origin

**Files:**
- None modified.

- [ ] **Step 1: Show what is about to be pushed**

```bash
cd ~/.dotfiles
git log --oneline origin/master..HEAD
```

Expected: lists the 4 new commits from Tasks 7–10 plus the spec commit `ff810f5` from earlier in this session (5 total).

- [ ] **Step 2: Final sensitive-content sweep across all to-be-pushed commits**

```bash
cd ~/.dotfiles
git log -p origin/master..HEAD | grep -iE 'token|secret|password|api[_-]?key|datanerd|newrelic|nr-internal|customer' || echo "CLEAN"
```

Expected: `CLEAN`. If anything matches, **STOP**, do `git reset` to back up to before the offending commit, and re-do the audit.

- [ ] **Step 3: Push**

```bash
cd ~/.dotfiles
git push origin master
```

Expected: push succeeds.

- [ ] **Step 4: Verify remote**

```bash
cd ~/.dotfiles
git fetch origin
git status -sb
```

Expected: `## master...origin/master` with no `ahead`/`behind`.

---

### Task 12: Phase 0 exit verification

**Files:**
- None modified.

- [ ] **Step 1: Confirm Phase 0 exit criteria from the spec**

```bash
cd ~/.dotfiles
git status --short
```

Expected output is one of:
- empty (best case), OR
- only `config/fish/fish_variables` and any EXCLUDE files appearing as untracked-but-ignored (they will not appear if `.gitignore` is correct).

Run:

```bash
git ls-files --others --exclude-standard
```

Expected: empty (no genuinely untracked files outside ignore).

- [ ] **Step 2: Confirm sensitive files are not in the public repo**

```bash
cd ~/.dotfiles
git ls-tree -r origin/master --name-only | grep -E '^(config/gh/hosts\.yml|config/cmux/cmux\.json|config/claude-statusline/config\.toml)$' || echo "CONFIRMED ABSENT"
```

For each path on the EXCLUDE list, expected output is `CONFIRMED ABSENT`. Adjust the regex to match your actual EXCLUDE list. If any EXCLUDE path appears in `git ls-tree`, **STOP** — it has been pushed to the public repo and needs to be purged with `git rm --cached`, an `.gitignore` update, and a force push (consult user before force-pushing master).

- [ ] **Step 3: Confirm hand-off readiness for Phase 1**

```bash
cd ~/.dotfiles
git log --oneline -10
```

Expected: top of log shows the 4 Phase 0 commits + the spec commit. The repo is now ready for the Phase 1 chezmoi migration in a future session.

---

## Notes for the executor

- This plan does not run `git stash`; the working tree changes are committed in-place via path-scoped `git commit -- <paths>`. Do not reorder tasks 7–10 unless you also reorder the path arguments accordingly.
- If at any point a task's "Expected" output does not match, STOP and surface the discrepancy to the user. Do not improvise additional `git` operations — especially not `git reset`, `git commit --amend`, or `git push --force` — without confirmation.
- The personal laptop is untouched throughout Phase 0. After push it can `git pull` whenever; the personal laptop migration is Phase 1, separate session, separate plan.
