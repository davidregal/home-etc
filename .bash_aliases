# Debug
echo "Entering .bash_aliases"

# Conveniences
alias ..="cd .." # two dots moves you up one
alias ...="cd .. ; cd .." # three dots moves you up two levels in your path
alias ll="ls -la" # long list, includes dot files
alias la='ls -A'  # list all, includes dot files
alias l='ls -CF'

# Personal aliases
alias stt='set_tab_title'

# Host Environment specific aliases
. ~/.bash_aliases_local

# Debug
echo "Leaving .bash_aliases"
