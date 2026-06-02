# Chezmoi migration design

Date: 2026-06-02
Repo: `am/dotfiles` (currently rcm-managed at `~/.dotfiles`)
Machines: work laptop (this one), personal laptop (rcm, untouched until Phase 1 cutover)

## Goal

Move dotfiles management from rcm to [chezmoi](https://www.chezmoi.io/), with first-class separation between work and personal configuration, while preserving an edit-in-place daily workflow.

## Strategy summary

- **Single repo.** The existing `am/dotfiles` repo continues to be the source of truth. Master is rewritten in-place from rcm format to chezmoi source format.
- **Templated default + file-level overlays.** Small machine-specific differences are expressed inline via chezmoi templates (`.tmpl`). Whole files that exist on only one machine type live as plain files in the source tree and are gated by `.chezmoiignore.tmpl`.
- **Profile-driven.** `chezmoi init` prompts the user once for `profile` (`work` or `personal`) and `email`. Values are stored in the machine-local `~/.config/chezmoi/chezmoi.toml` (not tracked). Templates branch on `.profile`.
- **Two-phase execution.** Phase 0 reconciles current rcm-level divergence between the two machines. Phase 1 performs the chezmoi conversion on a branch and cuts over master.

## Phase 0 — Reconcile rcm divergence

State at start: `~/.dotfiles` is already up to date with `origin/master` (personal laptop's commits already pulled). Local tree has 23 staged + 2 unstaged changes that have never been pushed.

### Steps

1. **Sensitive-content audit.** For each staged file, decide whether it is safe to push to the public `am/dotfiles` repo. Files to inspect explicitly:
   - `config/gh/hosts.yml` — may contain a GitHub OAuth token. Default action: gitignore + `git restore --staged`. Keep the local copy in place; let `gh` continue to own it.
   - `config/cmux/cmux.json` — work-internal tool. Confirm absence of API keys, endpoints, customer identifiers before committing.
   - `config/claude-statusline/config.toml` — same audit as above.
   - `ssh/config` — review for internal hostnames that should not be public; if present, stop and decide (private repo? template? exclude?).
   - `config/fish/conf.d/secrets.fish` — confirmed safe; it only sources `~/.config/fish/secrets.local.fish` (untracked).
2. **For anything flagged sensitive:** `git restore --staged <file>`, add to repo `gitignore`, leave the working tree copy untouched.
3. **Group and commit the rest** in 2–3 logical rcm-style commits, for example:
   - "Add cmux and claude-statusline configs"
   - "Update fish config; replace built-in z with sesh"
   - "Update tmux, ghostty, iterm2, gh settings, htop, git/ignore"
4. **Leave `config/fish/fish_variables` unstaged.** It is tool-owned drift; it will be formally `.chezmoiignore`d in Phase 1. Do not commit it.
5. **`git push origin master`.** Phase 0 done. Both machines are reconciled at the rcm level; personal laptop can `git pull` at its leisure.

### Phase 0 exit criteria

- `git status` shows only `fish_variables` (and any sensitive files now in `gitignore`) as modified/untracked.
- `git push` succeeds.
- No tokens, internal hostnames, or customer-identifying strings are visible in the public repo.

## Phase 1 — Chezmoi conversion

Performed in a separate session after Phase 0 is complete and pushed.

### End-state repo layout

```
.chezmoi.toml.tmpl              # init prompts: profile, email
.chezmoiignore.tmpl             # excludes work-only files when profile=personal, etc.
README.md                       # rewritten for chezmoi workflow
Brewfile.tmpl                   # templated; work profile adds extra casks
dot_config/
  fish/
    config.fish                 # plain unless inline machine differences exist
    conf.d/...
  ghostty/config
  iterm2/AppSupport
  gh/config.yml
  gh/hosts.yml                  # work-only; .chezmoiignore excludes for personal
  htop/htoprc
  git/config.tmpl               # email/name from .email and .profile
  git/ignore
  cmux/                         # work-only
  claude-statusline/            # work-only
dot_tmux.conf
dot_vimrc
dot_ssh/config.tmpl             # templated host blocks if needed
script/
  setup                         # rewritten: install chezmoi, run `chezmoi init --apply am/dotfiles`
```

### Profile and identification

`.chezmoi.toml.tmpl`:

```
{{- $profile := promptStringOnce . "profile" "Profile (work or personal)" "personal" -}}
{{- $email   := promptStringOnce . "email"   "Git email" -}}

[data]
  profile = {{ $profile | quote }}
  email   = {{ $email   | quote }}
```

Templates use `{{ if eq .profile "work" }}…{{ end }}`.

### File classification rules

For each file in the current `~/.dotfiles` tree, classify into one of:

- **shared plain** — same content on every machine. Move to chezmoi naming (e.g. `tmux.conf` → `dot_tmux.conf`, `config/X` → `dot_config/X`).
- **shared templated** — same logical file with small per-machine differences. Becomes a `.tmpl` with `{{ if … }}` blocks.
- **work-only** — entire file/dir only meaningful on work. Plain file in source tree, excluded for personal via `.chezmoiignore.tmpl`.
- **personal-only** — symmetric.
- **tool-owned ignore** — written by a tool (`fish_variables`, `gh/hosts.yml` if not work-only, etc.). Listed in `.chezmoiignore` so chezmoi neither tracks nor overwrites.
- **drop** — rcm artifacts (`rcrc`, `gitignore`, `bundle/`, `.gitmodules`, `oh-my-zsh/` submodule), and any files orphaned by tooling switches (`hyper.js` after ghostty, `emacs.d/` and `spacemacs` if no longer used — confirm with user during walk).

### Daily workflow after migration

- **Plain files:** edit `~/.config/foo` directly. To ship: `chezmoi re-add && chezmoi cd && git add -p && git commit && git push`.
- **Templated files:** `chezmoi edit ~/.config/foo` (opens the source `.tmpl`), then `chezmoi apply`.
- **Drift check:** `chezmoi diff`, `chezmoi status` at any time.
- **Tool-owned ignored files:** untouched by chezmoi.

### Migration steps (Phase 1)

1. Create branch `chezmoi-migration` from master.
2. Add `.chezmoi.toml.tmpl` and an empty `.chezmoiignore.tmpl`. Set `profile = "work"` in local chezmoi config for this machine.
3. Add a top-level `.chezmoiignore` entry for rcm artifacts (`rcrc`, `gitignore`, `bundle/`, `.gitmodules`, `oh-my-zsh/`, `script/`) so chezmoi does not try to materialize them in `$HOME` while the migration is in flight.
4. Walk the tree interactively, one file/dir at a time. For each: propose a classification; user confirms or overrides; rename/move accordingly.
5. After every batch (~5–10 files), run `chezmoi diff` against `$HOME`. The diff should show only intentional changes; anything else means a misclassification.
6. Once the tree is fully converted, delete rcm artifacts in one commit, rewrite `script/setup` for chezmoi bootstrap, rewrite `README.md`.
7. Final verification: `chezmoi apply --dry-run -v`. If clean, `chezmoi apply`. Sanity-check fish, tmux, ghostty, gh.
8. Merge `chezmoi-migration` → master. `git push`.

### Phase 1 exit criteria

- `chezmoi diff` is empty on the work machine.
- All previously-working tools (fish, tmux, ghostty, gh, etc.) still work.
- Personal laptop is untouched and still functional on its current rcm setup; it migrates in a separate session via `chezmoi init --apply am/dotfiles`.

## Out of scope

- Personal laptop migration. Tracked separately; will reuse the same repo and the `chezmoi init` prompt.
- Brewfile reorganization beyond templating into work/personal sections.
- Reviving or removing legacy emacs/spacemacs configs unless the user opts in during the Phase 1 walk.

## Risks and mitigations

- **Sensitive content leaking to a public repo during Phase 0.** Mitigated by the explicit pre-commit audit step.
- **Tool drift (`fish_variables`, `gh/hosts.yml`) being committed.** Mitigated by leaving them unstaged in Phase 0 and `.chezmoiignore`ing them in Phase 1.
- **Personal laptop pulls Phase 0 commits and breaks.** Phase 0 commits are still rcm-format, so no risk; personal laptop can pull at any time. The break point is the Phase 1 master merge — that is when the personal laptop is told to migrate.
- **Misclassification during Phase 1 walk.** Mitigated by `chezmoi diff` after each batch and by performing the work on a branch.
