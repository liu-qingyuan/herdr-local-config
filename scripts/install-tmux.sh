#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
stamp="$(date +%Y%m%d%H%M%S)"
backup_dir="$HOME/.tmux-local-config-backup-$stamp"
mkdir -p "$backup_dir"

backup_path() {
  local p="$1"
  if [ -e "$p" ] || [ -L "$p" ]; then
    mkdir -p "$backup_dir$(dirname "$p")"
    cp -a "$p" "$backup_dir$p"
  fi
}

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: missing required command: $1" >&2
    exit 1
  }
}

need git
need tmux

backup_path "$HOME/.tmux"
backup_path "$HOME/.tmux.conf"
backup_path "$HOME/.tmux.conf.local"
backup_path "$HOME/.config/tmux/plugins/catppuccin/tmux"
backup_path "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu"

mkdir -p "$HOME/.config/tmux/plugins/catppuccin" "$HOME/.config/tmux/plugins/tmux-plugins"

if [ ! -d "$HOME/.tmux/.git" ]; then
  rm -rf "$HOME/.tmux"
  git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
else
  git -C "$HOME/.tmux" fetch --depth 1 origin master || true
  git -C "$HOME/.tmux" checkout -q master || true
  git -C "$HOME/.tmux" reset -q --hard origin/master || true
fi

if [ ! -d "$HOME/.config/tmux/plugins/catppuccin/tmux/.git" ]; then
  rm -rf "$HOME/.config/tmux/plugins/catppuccin/tmux"
  git clone --depth 1 https://github.com/catppuccin/tmux.git "$HOME/.config/tmux/plugins/catppuccin/tmux"
else
  git -C "$HOME/.config/tmux/plugins/catppuccin/tmux" fetch --depth 1 origin main || true
  git -C "$HOME/.config/tmux/plugins/catppuccin/tmux" checkout -q main || true
  git -C "$HOME/.config/tmux/plugins/catppuccin/tmux" reset -q --hard origin/main || true
fi

if [ ! -d "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu/.git" ]; then
  rm -rf "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu"
  git clone --depth 1 https://github.com/tmux-plugins/tmux-cpu.git "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu"
else
  git -C "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu" fetch --depth 1 origin master || true
  git -C "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu" checkout -q master || true
  git -C "$HOME/.config/tmux/plugins/tmux-plugins/tmux-cpu" reset -q --hard origin/master || true
fi

cp "$repo_root/dotfiles/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
rm -f "$HOME/.tmux.conf"
ln -s "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
chmod 644 "$HOME/.tmux.conf.local"

echo "Installed tmux local config."
echo "Backup: $backup_dir"
echo "Try: tmux -f \"$HOME/.tmux.conf\" new-session"
