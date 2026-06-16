# Dotfiles Design

## Goal

Create a small Git-backed dotfiles project for only these local targets:

- Neovim: `$HOME/.config/nvim`
- tmux: `$HOME/.tmux.conf`
- zsh: `$HOME/.zshrc`
- Claude skills: `$HOME/.claude/skills`
- Agents skills: `$HOME/.agents/skills`

## Repository Shape

The repository uses GNU Stow package folders so each package mirrors the path it owns under `$HOME`.

```text
dotfiles/
  install
  sync
  nvim/.config/nvim/
  tmux/.tmux.conf
  zsh/.zshrc
  claude/.claude/skills/
  agents/.agents/skills/
```

## Script Behavior

`sync` copies the current machine's tracked targets into the repository. It overwrites only the matching package paths in the repo, excludes nested `.git` metadata and common editor cruft, and does not commit changes.

`install` applies the package folders into `$HOME` with GNU Stow. Before stowing, it removes an existing live target only when it matches the repository copy, ignoring nested `.git` metadata and `.DS_Store`. If a live target differs, it fails and leaves the live file or directory alone.

Both scripts accept optional target names, such as `./sync nvim zsh` or `./install tmux`. Without arguments, they operate on all five supported targets.

## Verification

Shell tests exercise the scripts against temporary `HOME` and `DOTFILES` directories. They verify sync copying, nested `.git` exclusion, safe install symlinking, conflict refusal, and sync after install.
