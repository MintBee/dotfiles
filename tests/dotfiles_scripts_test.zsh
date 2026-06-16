#!/usr/bin/env zsh
set -euo pipefail

ROOT=${0:A:h:h}

fail() {
  print -u2 "FAIL: $*"
  exit 1
}

assert_file_contains() {
  local file=$1
  local expected=$2
  [[ -f "$file" ]] || fail "expected file: $file"
  grep -Fq "$expected" "$file" || fail "expected '$expected' in $file"
}

assert_missing() {
  local path=$1
  [[ ! -e "$path" && ! -L "$path" ]] || fail "expected missing path: $path"
}

with_fixture() {
  local test_name=$1
  local tmp
  tmp=$(mktemp -d)
  export TEST_HOME="$tmp/home"
  export TEST_REPO="$tmp/repo"
  mkdir -p "$TEST_HOME/.config/nvim/.git" "$TEST_HOME/.claude/skills/tdd" "$TEST_HOME/.agents/skills/grill-me"
  print 'vim.opt.number = true' > "$TEST_HOME/.config/nvim/init.lua"
  print '[core]' > "$TEST_HOME/.config/nvim/.git/config"
  print 'set -g mouse on' > "$TEST_HOME/.tmux.conf"
  print 'alias vim="nvim"' > "$TEST_HOME/.zshrc"
  print '# tdd skill' > "$TEST_HOME/.claude/skills/tdd/SKILL.md"
  print '# grill skill' > "$TEST_HOME/.agents/skills/grill-me/SKILL.md"
  mkdir -p "$TEST_REPO"

  "$test_name"

  rm -rf "$tmp"
}

test_sync_copies_targets() {
  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/sync"

  assert_file_contains "$TEST_REPO/nvim/.config/nvim/init.lua" 'vim.opt.number = true'
  assert_missing "$TEST_REPO/nvim/.config/nvim/.git"
  assert_file_contains "$TEST_REPO/tmux/.tmux.conf" 'set -g mouse on'
  assert_file_contains "$TEST_REPO/zsh/.zshrc" 'alias vim="nvim"'
  assert_file_contains "$TEST_REPO/claude/.claude/skills/tdd/SKILL.md" '# tdd skill'
  assert_file_contains "$TEST_REPO/agents/.agents/skills/grill-me/SKILL.md" '# grill skill'
}

test_install_stows_matching_targets() {
  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/sync"
  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/install"

  [[ -L "$TEST_HOME/.config/nvim" ]] || fail "expected nvim symlink"
  [[ -L "$TEST_HOME/.tmux.conf" ]] || fail "expected tmux symlink"
  [[ -L "$TEST_HOME/.zshrc" ]] || fail "expected zsh symlink"
  [[ ! -L "$TEST_HOME/.config" ]] || fail "config parent should not be symlink"
  [[ ! -L "$TEST_HOME/.claude" ]] || fail "claude parent should not be symlink"
  [[ ! -L "$TEST_HOME/.agents" ]] || fail "agents parent should not be symlink"
  [[ -L "$TEST_HOME/.claude/skills" ]] || fail "expected claude skills symlink"
  [[ -L "$TEST_HOME/.agents/skills" ]] || fail "expected agents skills symlink"
  assert_file_contains "$TEST_HOME/.config/nvim/init.lua" 'vim.opt.number = true'
}

test_install_refuses_conflicting_target() {
  mkdir -p "$TEST_REPO/zsh"
  print 'alias vim="nvim"' > "$TEST_REPO/zsh/.zshrc"
  print 'alias vim="vim"' > "$TEST_HOME/.zshrc"

  if DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/install" zsh >/dev/null 2>&1; then
    fail "expected install conflict"
  fi

  [[ ! -L "$TEST_HOME/.zshrc" ]] || fail "conflicting zshrc should not become symlink"
  assert_file_contains "$TEST_HOME/.zshrc" 'alias vim="vim"'
}

test_sync_after_install_copies_symlink_targets_as_content() {
  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/sync"
  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/install"
  print 'alias cx="codex"' >> "$TEST_HOME/.zshrc"

  DOTFILES="$TEST_REPO" HOME="$TEST_HOME" "$ROOT/sync" zsh

  [[ ! -L "$TEST_REPO/zsh/.zshrc" ]] || fail "repo zshrc should be a regular file"
  assert_file_contains "$TEST_REPO/zsh/.zshrc" 'alias cx="codex"'
}

with_fixture test_sync_copies_targets
with_fixture test_install_stows_matching_targets
with_fixture test_install_refuses_conflicting_target
with_fixture test_sync_after_install_copies_symlink_targets_as_content

print "ok"
