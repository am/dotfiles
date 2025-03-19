if status is-interactive
    # Commands to run in interactive sessions can go here
    set --global --export LANG en_US.UTF-8
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by Radicle.
export PATH="$PATH:/Users/amiranda/.radicle/bin"
