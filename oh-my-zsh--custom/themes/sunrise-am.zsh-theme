#-------------------------------------------------------------------------------
# Addapted from:
# https://github.com/eendroroy/nothing/blob/master/nothing.zsh
#-------------------------------------------------------------------------------

NT_PROMPT_SYMBOL=∆

function precmd(){
  autoload -U add-zsh-hook
  setopt prompt_subst

  PROMPT='%(?.%F{green}${NT_PROMPT_SYMBOL}%f.%F{red}${NT_PROMPT_SYMBOL}%f) '

  if [[ "$NT_HIDE_EXIT_CODE" == '1' ]]; then
  	RPROMPT=''
  else
  	RPROMPT='%(?..%F{red}%B%S  $?  %s%b%f)'
  fi

}
