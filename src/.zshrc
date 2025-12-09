# Enable persistent history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_SAVE_NO_DUPS
setopt INC_APPEND_HISTORY

# Configure the push directory stack (most people don't need this)
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Emacs keybindings
bindkey -e
# Use the up and down keys to navigate the history
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end

# Move to directories without cd
setopt autocd

# Initialize completion
autoload -U compinit; compinit

# Enable menu selection and highlight current selection
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### homebrew
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide to move between folders efficiently
eval "$(zoxide init zsh)"

# Set up the Starship prompt
eval "$(starship init zsh)"

### mise
eval "$(mise activate zsh)"

### aliases
alias ls="eza"
alias mc="mc -u"
alias yolo="claude --dangerously-skip-permissions"

### AWS profile selector using fzf
aws-profile() {
  local profile
  profile=$(grep -E '^\[profile ' ~/.aws/config 2>/dev/null | sed 's/\[profile \(.*\)\]/\1/' | fzf --prompt="AWS Profile: " --height=40% --reverse)
  if [[ -n "$profile" ]]; then
    export AWS_PROFILE="$profile"
    echo "Switched to AWS profile: $profile"
  fi
}

# Widget wrapper for keybinding
_aws-profile-widget() {
  aws-profile
  zle reset-prompt
}
zle -N _aws-profile-widget
bindkey '\ea' _aws-profile-widget

### Golang
export GOPATH=$HOME/.go

### PATH updates ###
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"
