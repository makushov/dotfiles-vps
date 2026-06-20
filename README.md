# dotfiles-vps

Terminal dotfiles for Ubuntu VPS. Catppuccin Mocha fixed dark theme throughout.

## Stack

| Tool | Notes |
|------|-------|
| zsh + oh-my-zsh | autosuggestions, syntax-highlighting, web-search |
| Starship | Catppuccin Mocha prompt |
| tmux | Catppuccin plugin, CPU/RAM in statusbar, TPM |
| Neovim | treesitter, telescope, neo-tree, lualine, noice, lazygit, gitsigns, yazi, trouble, and more |
| git | delta pager, aliases |
| yazi | Catppuccin Mocha theme |
| htop | pre-configured |

## Install

Two scripts — system setup requires sudo, user setup does not.

### Step 1 — system packages (once per VPS, sudo user only)

```bash
bash <(curl -sSfL https://raw.githubusercontent.com/makushov/dotfiles-vps/main/install-system.sh)
```

Installs: `neovim` `starship` `eza` `yazi` `lazygit` `bat` `ripgrep` `fd` `jq` `delta` `7zip` `build-essential` and other apt packages.

### Step 2 — user setup (run as each user)

```bash
bash <(curl -sSfL https://raw.githubusercontent.com/makushov/dotfiles-vps/main/install-user.sh)
```

Installs: `oh-my-zsh` `fzf` `zoxide` `lazydocker` `TPM`, clones repo, applies dotfiles via Stow.

## After install

1. Start tmux → `prefix + I` to install plugins (TPM)
2. Open `nvim` — lazy.nvim installs everything on first launch
3. Set git identity per user:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```
