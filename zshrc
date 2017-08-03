# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh--custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sunrise-am"
# ZSH_TMUX_AUTOSTART=true

# Example aliases
alias zshconfig="st ~/.zshrc"
alias ohmyzsh="st ~/.oh-my-zsh"
alias wib="curl http://wttr.in/Barcelona"

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
plugins=(
    bundler
    encode64
    git
    gitfast
    history-substring-search
    rails
    rhc
    sublime
    tmux
    osx
)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export EDITOR=/Applications/Emacs.app/Contents/MacOS/Emacs

# Add homwbrew sbin to path
export PATH="/usr/local/sbin:$PATH"

# secrets
source $HOME/.secret

# load autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# nvm
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# rbenv init
eval "$(rbenv init -)"

# Android Studio
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
