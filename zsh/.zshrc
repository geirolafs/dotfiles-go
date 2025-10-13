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
