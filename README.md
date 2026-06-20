# dotfiles-vps

Terminal dotfiles for Ubuntu VPS. Catppuccin Mocha fixed dark theme throughout.

## Stack

| Tool | Notes |
|------|-------|
| zsh + oh-my-zsh | autosuggestions, syntax-highlighting, web-search |
| Starship | Catppuccin Mocha prompt |
| tmux | Catppuccin plugin, CPU/RAM in statusbar, TPM |
| Neovim | No LSP/Mason — treesitter, telescope, neo-tree, lualine, noice, lazygit, gitsigns, yazi, trouble, and more |
| git | delta pager, aliases |
| htop | pre-configured |

## Install

```bash
bash <(curl -sSfL https://raw.githubusercontent.com/makushov/dotfiles-vps/main/install.sh)
```

Or manually:

```bash
git clone https://github.com/makushov/dotfiles-vps.git ~/.dotfiles-vps
cd ~/.dotfiles-vps
bash install.sh
```

## After install

1. Start tmux → `prefix + I` to install plugins
2. Open `nvim` — lazy.nvim installs everything on first launch
3. `git config --global user.name "Your Name"`
4. `git config --global user.email "you@example.com"`

## Tools installed

`zsh` `tmux` `neovim` `starship` `fzf` `bat` `eza` `zoxide` `yazi` `htop` `lazygit` `lazydocker` `ripgrep` `fd` `jq` `delta` `7zip`
