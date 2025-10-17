# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration - disabled to use starship prompt instead
ZSH_THEME=""

# Plugin configuration - your optimized selection
plugins=(
  git
  fzf
  zsh-autosuggestions
  fzf-tab
  zsh-syntax-highlighting
  colored-man-pages
  command-not-found
  z
)

# Oh My Zsh initialization
source $ZSH/oh-my-zsh.sh

# Personal customizations
# Add your own exports, aliases, and functions here.
# This section will override any conflicting settings from Omarchy

# aliases
alias dotfiles='cd ~/.dotfiles/ && l'
alias docs='cd ~/Documents/ && l'
alias y='yazi'
dev() {
  case "$1" in
    go) cd ~/Developer/go/ && l ;;
    www) cd ~/Developer/www/ && l ;;
    prj) cd ~/Developer/Projects/ && l ;;
    *) cd ~/Developer/ && l ;;
  esac
}

# 1Password CLI shortcuts
alias ops='eval $(op signin)'  # Quick signin

# Fuzzy find and view item details
opf() {
  local item=$(op item list --format=json | jq -r '.[] | .title' | fzf --prompt="1Password > ")
  [[ -n "$item" ]] && op item get "$item"
}

# Fuzzy find and copy password to clipboard
opc() {
  local item=$(op item list --format=json | jq -r '.[] | .title' | fzf --prompt="Copy password > ")
  if [[ -n "$item" ]]; then
    local password=$(op item get "$item" --fields password --reveal)
    if [[ -n "$SSH_CONNECTION" ]]; then
      # Over SSH - print password (can be selected/copied manually)
      echo "Password: $password"
    else
      # Local session - copy to clipboard
      echo -n "$password" | wl-copy
      echo "✓ Password copied to clipboard"
    fi
  fi
}

# Fuzzy find and copy username to clipboard
opn() {
  local item=$(op item list --format=json | jq -r '.[] | .title' | fzf --prompt="Copy username > ")
  if [[ -n "$item" ]]; then
    local username=$(op item get "$item" --fields username --reveal)
    if [[ -n "$SSH_CONNECTION" ]]; then
      # Over SSH - print username (can be selected/copied manually)
      echo "Username: $username"
    else
      # Local session - copy to clipboard
      echo -n "$username" | wl-copy
      echo "✓ Username copied to clipboard"
    fi
  fi
}

# History configuration
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# Prompt configuration - hide the partial line indicator
setopt PROMPT_SP
export PROMPT_EOL_MARK=""

# . "$HOME/.local/share/../bin/env"  # Commented out - file doesn't exist
export PATH="$HOME/.cache/.bun/bin:$PATH"
eval "$(mise activate zsh)"

# Initialize starship prompt
eval "$(starship init zsh)"
