#!/usr/bin/env bash
# install-user.sh — per-user setup, no sudo required
# Usage: bash install-user.sh
set -euo pipefail

REPO_URL="https://github.com/makushov/dotfiles-vps.git"
DOTFILES_DIR="$HOME/.dotfiles-vps"

# ── Colors ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[info]${NC}  $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $*"; }

command_exists() { command -v "$1" &>/dev/null; }

# ── 1. fzf ────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.fzf" ]; then
  info "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all --no-update-rc
else
  info "fzf already installed, skipping"
fi

export PATH="$HOME/.fzf/bin:$PATH"

# ── 2. zoxide ─────────────────────────────────────────────────────────
if ! command_exists zoxide; then
  info "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  info "zoxide already installed, skipping"
fi

# ── 3. lazydocker ─────────────────────────────────────────────────────
if ! command_exists lazydocker; then
  info "Installing lazydocker..."
  curl -sSfL \
    https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh |
    DIR="$HOME/.local/bin" bash
else
  info "lazydocker already installed, skipping"
fi

# ── 4. oh-my-zsh ──────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  info "oh-my-zsh already installed, skipping"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ── 5. TPM ────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  info "TPM already installed, skipping"
fi

# ── 6. Clone / update dotfiles ────────────────────────────────────────
if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning dotfiles-vps..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  info "dotfiles-vps already cloned, pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

# ── 7. Apply via Stow ─────────────────────────────────────────────────
info "Applying dotfiles with stow..."
cd "$DOTFILES_DIR"

STOW_PACKAGES=(zsh tmux starship nvim yazi git)

for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    stow --restow --target="$HOME" "$pkg" 2>/dev/null || {
      warn "Conflict in $pkg — backing up and retrying..."
      stow --adopt --target="$HOME" "$pkg"
      git checkout -- "$pkg"
      stow --restow --target="$HOME" "$pkg"
    }
    info "Stowed: $pkg"
  fi
done

# ── 8. Set zsh as default shell ───────────────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH"
else
  info "zsh is already the default shell"
fi

# ── Done ──────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✓ User setup done!${NC} Reload shell: exec zsh"
echo ""
echo "Next steps:"
echo "  1. Start tmux → prefix+I to install plugins"
echo "  2. Open nvim — lazy.nvim installs plugins on first launch"
echo "  3. git config --global user.name / user.email"
