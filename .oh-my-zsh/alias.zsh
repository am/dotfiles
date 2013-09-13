# project


# util
alias rs='. ~/.zshrc'

# services
alias cb='cerberus -p 4000 -d wuaki_devel -L -F'
alias cbt='cerberus -p 5000 -d wuaki_test -L -F'

# display folder tree
alias tree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

