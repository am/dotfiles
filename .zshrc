# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sunrise-am"

# Example aliases
alias zshconfig="st ~/.zshrc"
alias ohmyzsh="st ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=1

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(osx gitfast sublime rhc tmux rails bundler git)

source $ZSH/oh-my-zsh.sh

# am Boxen
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh

# autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# http://superuser.com/questions/561067/zsh-prompts-to-correct-executable-when-running-bundle-exec
alias bundle='nocorrect bundle'

export EDITOR=opt/boxen/homebrew/bin/emacs
export HOMEBREW_HOME="$HOMEBREW_ROOT"

# node shims
export PATH='/opt/boxen/nodenv/shims/':$PATH

# flex
export FLEX_HOME='/Volumes/Data/System/SDK/flex_sdk_4.11/'

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

alias gll='sh ~/src/dotfiles/bin/gll.sh'
