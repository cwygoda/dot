# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/cwygoda/.docker/bin"
# End of Docker Desktop section.

if status is-interactive
    # Tool integrations
    fzf --fish | source
    zoxide init fish | source
    starship init fish | source
    mise activate fish | source
    direnv hook fish | source

    # Aliases
    alias ls eza
    alias mc "mc -u"
    alias yolo "claude --dangerously-skip-permissions"

    # AWS profile selector
    function aws-profile
        set -l profile (grep -E '^\[profile ' ~/.aws/config 2>/dev/null \
            | sed 's/\[profile \(.*\)\]/\1/' \
            | fzf --prompt="AWS Profile: " --height=40% --reverse)
        if test -n "$profile"
            set -gx AWS_PROFILE $profile
            echo "Switched to AWS profile: $profile"
        end
    end

    # Alt+A -> aws-profile
    bind \ea 'aws-profile; commandline -f repaint'

    # Local overrides
    test -f $HOME/.config/fish/config.local.fish && source $HOME/.config/fish/config.local.fish
end

# pnpm
set -gx PNPM_HOME "/Users/cwygoda/Library/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
