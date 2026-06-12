# Tmux local config

This folder tracks the portable local tmux configuration used with Oh My Tmux
and Catppuccin.

Installed layout:

```text
~/.tmux                                  # gpakosz/.tmux checkout
~/.tmux.conf -> ~/.tmux/.tmux.conf
~/.tmux.conf.local                      # tracked local config
~/.config/tmux/plugins/catppuccin/tmux  # Catppuccin theme
~/.config/tmux/plugins/tmux-plugins/tmux-cpu
```

Theme settings are in `.tmux.conf.local`:

```tmux
set -g @catppuccin_flavor 'latte'
set -g @catppuccin_window_status_style 'rounded'
run '~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux'
```

Install with:

```bash
./scripts/install-tmux.sh
```
