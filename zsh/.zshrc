export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# ── fzf ──────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"                          "$@" ;;
    ssh)          fzf --preview 'dig {}'                                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview"                "$@" ;;
  esac
}

# Catppuccin Mocha — fixed dark theme for VPS
export BAT_THEME="Catppuccin Mocha"

export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi"

# ── PATH ─────────────────────────────────────────────────────────────
export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ── Tools ────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ── Editor ───────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── Aliases: navigation ───────────────────────────────────────────────
alias ls="eza --icons"
alias tree="eza -T --icons"
alias v="nvim"

# ── Aliases: docker ───────────────────────────────────────────────────
alias dps="docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}'"
alias dpsa="docker ps -a --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}'"
alias dlog="docker logs -f"
alias dex="docker exec -it"

# ── Aliases: tmux ────────────────────────────────────────────────────
alias t="tmux"
alias ta="tmux attach"
alias tls="tmux ls"
alias tn="tmux new -s"
alias tk="tmux kill-session -t"

# ── History ──────────────────────────────────────────────────────────
HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ── Yazi (cd on exit) ────────────────────────────────────────────────
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}
