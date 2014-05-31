#
# Eon's bashrc
#

# Only in interactive mode
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Other options
shopt -s checkwinsize
shopt -s globstar

# Prompt
rs=$(tput sgr0)
bl=$(tput bold)

PS1=""
PS1="${PS1}\[${bl}$(tput setaf 3)\]\u"
PS1="${PS1}\[${rs}\]@"
PS1="${PS1}\[${bl}$(tput setaf 2)\]\h"
PS1="${PS1}\[${rs}\]:"
PS1="${PS1}\[${bl}$(tput setaf 4)\]\w"
PS1="${PS1}\[${bl}$(tput setaf 0)\]\\$ "
PS1="${PS1}\[${rs}\]"

unset rs bl

# Aliases
alias     l='ls --color=auto -F'
alias    la='ls --color=auto -A'
alias    ls='ls --color=auto -F'
alias   dir='ls --color=auto -hlF'
alias  grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Completion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Set LS_COLORS
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
