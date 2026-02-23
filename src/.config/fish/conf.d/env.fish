# Homebrew
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

# Golang
set -gx GOPATH $HOME/.go

# PNPM
set -gx PNPM_HOME $HOME/Library/pnpm

# PATH (idempotent, prepends)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin
fish_add_path $PNPM_HOME
