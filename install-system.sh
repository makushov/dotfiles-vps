#!/usr/bin/env bash
# install-system.sh — system-wide setup, run ONCE as sudo user
# Usage: bash install-system.sh
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

# ── Colors ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[info]${NC}  $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $*"; }

command_exists() { command -v "$1" &>/dev/null; }

# ── 1. System packages ────────────────────────────────────────────────
info "Installing system packages..."
$SUDO apt-get update -qq
$SUDO apt-get install -y \
  git curl wget unzip stow \
  zsh tmux htop \
  bat ripgrep fd-find \
  jq delta rename p7zip-full \
  build-essential

# bat symlink
if command_exists batcat && ! command_exists bat; then
  $SUDO ln -sf "$(command -v batcat)" /usr/local/bin/bat
  info "Created bat → batcat symlink"
fi

# fd symlink
if command_exists fdfind && ! command_exists fd; then
  $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  info "Created fd → fdfind symlink"
fi

# ── 2. eza ────────────────────────────────────────────────────────────
if ! command_exists eza; then
  info "Installing eza..."
  $SUDO apt-get install -y gpg
  wget -qO - https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | $SUDO gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | $SUDO tee /etc/apt/sources.list.d/gierens.list > /dev/null
  $SUDO chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  $SUDO apt-get update -qq
  $SUDO apt-get install -y eza
else
  info "eza already installed, skipping"
fi

# ── 3. Neovim ─────────────────────────────────────────────────────────
if ! command_exists nvim; then
  info "Installing Neovim (latest stable)..."
  wget -qO /tmp/nvim.tar.gz \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  $SUDO tar -xzf /tmp/nvim.tar.gz -C /opt
  $SUDO ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm /tmp/nvim.tar.gz
else
  info "Neovim already installed, skipping"
fi

# ── 4. yazi ───────────────────────────────────────────────────────────
if ! command_exists yazi; then
  info "Installing yazi..."
  wget -qO /tmp/yazi.zip \
    "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
  unzip -q /tmp/yazi.zip -d /tmp/yazi-bin
  $SUDO install -m 755 /tmp/yazi-bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/yazi
  rm -rf /tmp/yazi.zip /tmp/yazi-bin
else
  info "yazi already installed, skipping"
fi

# ── 5. lazygit ────────────────────────────────────────────────────────
if ! command_exists lazygit; then
  info "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
  wget -qO /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
  $SUDO install -m 755 /tmp/lazygit /usr/local/bin/lazygit
  rm -f /tmp/lazygit.tar.gz /tmp/lazygit
else
  info "lazygit already installed, skipping"
fi

# ── 6. Starship ───────────────────────────────────────────────────────
if ! command_exists starship; then
  info "Installing Starship..."
  curl -sSfL https://starship.rs/install.sh | sh -s -- --yes
else
  info "Starship already installed, skipping"
fi

# ── Done ──────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}✓ System setup done!${NC}"
echo "Now run install-user.sh as each user who needs the dotfiles."
