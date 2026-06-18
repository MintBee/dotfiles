# Dotfiles

Small Stow-based dotfiles repo for:

- Neovim: `~/.config/nvim`
- tmux: `~/.tmux.conf`
- zsh: `~/.zshrc`
- Claude skills: `~/.claude/skills`
- Agents skills: `~/.agents/skills`
- ghostty
- cmux

## Sync Local Config Into This Repo

```sh
./sync
```

`sync` copies the tracked targets from this machine into the repo. It does not commit changes.

Run a subset by naming targets:

```sh
./sync nvim zsh
```

Supported targets are `nvim`, `tmux`, `zsh`, `claude`, and `agents`.

## Install Repo Config Into Home

Install requires GNU Stow:

```sh
brew install stow
```

Then run:

```sh
./install
```

`install` removes an existing live target only when it matches the repo copy, ignoring nested `.git` metadata and `.DS_Store`. If a live target differs, it fails and leaves that target alone.

Run a subset by naming targets:

```sh
./install tmux
```

The scripts also accept `STOW_FOLDERS` for compatibility with common Stow dotfiles workflows:

```sh
STOW_FOLDERS="nvim tmux" ./install
```
