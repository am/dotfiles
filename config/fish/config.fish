if status is-interactive
	# Commands to run in interactive sessions can go here
	set --global --export LANG en_US.UTF-8
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# go
fish_add_path $HOME/go/bin
fish_add_path $HOME/.local/bin

# gastown
fish_add_path $HOME/.claude/local/node_modules/.bin


# yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# editor
set -Ux EDITOR cursor
set -Ux VISUAL $EDITOR

# cursor agent
fish_add_path $HOME/.local/bin

# homebrew
fish_add_path /opt/homebrew/sbin

# direnv
direnv hook fish | source

# Claude Code keepalive workaround (anthropics/claude-code#60133)
# Bun does not set SO_KEEPALIVE on TCP sockets; long idle stretches during
# tool execution drop the HTTP/2 connection silently.
set -gx CLAUDE_CODE_REMOTE_SEND_KEEPALIVES true
set -gx BUN_CONFIG_HTTP_IDLE_TIMEOUT 300
set -gx BUN_CONFIG_HTTP_RETRY_COUNT 3
set -gx NODE_OPTIONS "--dns-result-order=ipv4first"

# zoxide
zoxide init fish | source

# Set up fzf key bindings
fzf --fish | source
