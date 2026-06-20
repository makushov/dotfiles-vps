#!/usr/bin/env bash
# install.sh — dotfiles-vps setup for Ubuntu
# Usage: bash install.sh
set -euo pipefail

REPO_URL="https://github.com/makushov/dotfiles-vps.git"
DOTFILES_DIR="$HOME/.dotfiles-vps"

# ── Colors ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[info]${NC}  $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $*"; }
error() {
  echo -e "${RED}[error]${NC} $*"
  exit 1
}

need_sudo() {
  if [[ $EUID -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

command_exists() { command -v "$1" &>/dev/null; }

# ── 1. System packages ────────────────────────────────────────────────
info "Installing system packages..."
need_sudo apt-get update -qq

PACKAGES=(
  git curl wget unzip stow
  zsh tmux htop
  fzf bat ripgrep fd-find
  jq delta rename p7zip-full
  build-essential
)

need_sudo apt-get install -y "${PACKAGES[@]}"

# bat is batcat on Ubuntu
if command_exists batcat && ! command_exists bat; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  info "Created bat → batcat symlink"
fi

# fd is fdfind on Ubuntu
if command_exists fdfind && ! command_exists fd; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  info "Created fd → fdfind symlink"
fi

# ── 2. eza ────────────────────────────────────────────────────────────
if ! command_exists eza; then
  info "Installing eza..."
  need_sudo apt-get install -y gpg
  wget -qO - https://raw.githubusercontent.com/eza-community/eza/main/deb.asc |
    need_sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" |
    need_sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  need_sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  need_sudo apt-get update -qq
  need_sudo apt-get install -y eza
else
  info "eza already installed, skipping"
fi

# ── 3. zoxide ─────────────────────────────────────────────────────────
if ! command_exists zoxide; then
  info "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
else
  info "zoxide already installed, skipping"
fi

# ── 4. Starship ───────────────────────────────────────────────────────
if ! command_exists starship; then
  info "Installing Starship..."
  curl -sSfL https://starship.rs/install.sh | sh -s -- --yes
else
  info "Starship already installed, skipping"
fi

# ── 5. Neovim ─────────────────────────────────────────────────────────
if ! command_exists nvim; then
  info "Installing Neovim (latest stable)..."
  NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  wget -qO /tmp/nvim.tar.gz "$NVIM_URL"
  need_sudo tar -xzf /tmp/nvim.tar.gz -C /opt
  need_sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
else
  info "Neovim already installed, skipping"
fi

# ── 6. yazi ───────────────────────────────────────────────────────────
if ! command_exists yazi; then
  info "Installing yazi..."
  YAZI_URL="https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
  wget -qO /tmp/yazi.zip "$YAZI_URL"
  unzip -q /tmp/yazi.zip -d /tmp/yazi-bin
  need_sudo install -m 755 /tmp/yazi-bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/yazi
  rm -rf /tmp/yazi.zip /tmp/yazi-bin
else
  info "yazi already installed, skipping"
fi

# ── 7. lazygit ────────────────────────────────────────────────────────
if ! command_exists lazygit; then
  info "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" |
    grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
  wget -qO /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
  need_sudo install -m 755 /tmp/lazygit /usr/local/bin/lazygit
  rm -f /tmp/lazygit.tar.gz /tmp/lazygit
else
  info "lazygit already installed, skipping"
fi

# ── 8. lazydocker ─────────────────────────────────────────────────────
if ! command_exists lazydocker; then
  info "Installing lazydocker..."
  curl -sSfL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh |
    DIR="$HOME/.local/bin" bash
else
  info "lazydocker already installed, skipping"
fi

# ── 9. oh-my-zsh ──────────────────────────────────────────────────────
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

# ── 10. TPM ───────────────────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  info "TPM already installed, skipping"
fi

# ── 11. Clone dotfiles ────────────────────────────────────────────────
if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning dotfiles-vps..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  info "dotfiles-vps already cloned, pulling latest..."
  git -C "$DOTFILES_DIR" pull --ff-only
fi

# ── 12. Apply via Stow ────────────────────────────────────────────────
info "Applying dotfiles with stow..."
cd "$DOTFILES_DIR"

STOW_PACKAGES=(zsh tmux starship nvim htop git)

for pkg in "${STOW_PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    stow --restow --target="$HOME" "$pkg" 2>/dev/null || {
      warn "Conflict in $pkg — backing up existing files and retrying..."
      stow --adopt --target="$HOME" "$pkg"
      git checkout -- "$pkg"
      stow --restow --target="$HOME" "$pkg"
    }
    info "Stowed: $pkg"
  fi
done

# ── 13. Set zsh as default shell ──────────────────────────────────────
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | need_sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"
else
  info "zsh is already the default shell"
fi

# ── Done ──────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✓ Done!${NC} Reload your shell: exec zsh"
echo ""
echo "Next steps:"
echo "  1. Start tmux → prefix+I to install plugins (TPM)"
echo "  2. Open nvim — lazy.nvim installs plugins on first launch"
echo "  3. Set git identity: git config --global user.name / user.email"
