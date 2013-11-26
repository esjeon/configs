
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

######
###### Functions
######

pathadd() {
	if [[ -d "$1" ]] && [[ ":${PATH}:" != *":$1:"* ]]; then
		export PATH="$1:${PATH}"
	fi
}

style() {
	while [[ -n "$1" ]]; do
		case "$1" in 
			reset) echo -ne '\e[0m' ;;
			bold ) echo -ne '\e[1m' ;;
			under) echo -ne '\e[4m' ;;
			blink) echo -ne '\e[5m' ;;
			*:*  ) # foreground, 8:256
				[[ -z "${USE256COLORS}" ]] && echo -ne "\e[3${1%:*}m"
				[[ -n "${USE256COLORS}" ]] && echo -ne "\e[38;5;${1#*:}m"
			;;
			*-*  ) # background, 8:256
				[[ -z "${USE256COLORS}" ]] && echo -ne "\e[4${1%-*}m"
				[[ -n "${USE256COLORS}" ]] && echo -ne "\e[48;5;${1#*-}m"
			;;
		esac
		shift 1
	done
}

rgb256() {
	[[ $1 -ge 1 && $1 -le 6 ]] || return
	[[ $2 -ge 1 && $2 -le 6 ]] || return
	[[ $3 -ge 1 && $3 -le 6 ]] || return
	echo $((16 + ($1-1)*36 + ($2-1)*6 + ($3-1)))
}

color256() {
	local code=0
	if [[ "$1" = "reset" ]]; then
		echo -ne '\e[0m'
		return
	elif [[ $# -eq 1 ]]; then
		[[ $1 -ge 1 && $1 -le 24 ]] || return
		c=$((232 + $1 - 1))
	elif [[ $# -eq 3 ]]; then
		[[ $1 -ge 1 && $1 -le 6 ]] || return
		[[ $2 -ge 1 && $2 -le 6 ]] || return
		[[ $3 -ge 1 && $3 -le 6 ]] || return
		c=$((16 + ($1-1)*36 + ($2-1)*6 + ($3-1)))
	else
		return
	fi

	echo -ne "\e[38;5;${c}m"
}

######
###### General
######

shopt -s checkwinsize
shopt -s globstar

### History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

### Completion
if ! shopt -oq posix; then
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	fi
fi

# node.js completion
if [[ -d ~/.node-completion ]]; then 
	shopt -s progcomp
	for f in $(command ls ~/.node-completion); do
		f="$HOME/.node-completion/$f"
		test -f "$f" && . "$f"
	done
fi

### Key bindings
bind '"\C-F":"fg\n"'      ### Ctrl-F: fg
#bind '"\C-B":"bg\n"'     ### Ctrl-B: bg

######
###### Environment
######

pathadd "${HOME}/.cabal/bin"
pathadd "${HOME}/bin"
pathadd "/usr/sbin"
pathadd "/sbin"

export PAGER=less
export EDITOR=vim

### per-Host settings
case "${HOSTNAME}" in
	linux*.student.cs|gl*)
		pathadd "${HOME}/Packages/node/bin"
	;;
esac

######
###### Aliases
######

alias cp='cp -v'
alias mv='mv -v -i'
alias rm='rm -v'
alias ln='ln -v'

alias l='ls --color=auto -F'
alias ls='ls --color=auto -F'
alias dir='ls --color=auto -hlF'
alias la='ls --color=auto -AF'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'


######
###### Prompt
######

### Test supported color

promptstat() {
	local exitcode=$1
	local njobs=$2

	[[ ${exitcode} -ne 0 ]] && \
		echo -n "x$(style blink 1:201)${exitcode}$(style reset)"
	[[ ${njobs} -ne 0 ]] && \
		echo -n "j$(style bold 2:76)${njobs}$(style reset)"

	if [[ "${HOSTNAME}" = "Regulus" ]]; then
		if [[ -f '/sys/devices/platform/smapi/ac_connected' ]]; then
			local ac=$(cat '/sys/devices/platform/smapi/ac_connected')
			if [[ $ac -ne 1 ]]; then
				local bat=$(cat '/sys/devices/platform/smapi/BAT0/remaining_percent')
				bat=$((bat))
				echo -n "B$(style bold 7:231)${bat}$(style reset)"
			fi
		fi
	fi

	return 0
}

promptinit() {
	local rs=$(style reset)

	# Hostname
	local hostcol=''
	case "${HOSTNAME}" in
		Deneb)          hostcol=$(style bold 3:226) ;;
		Alphard)        hostcol=$(style bold 2:83 ) ;;
		Regulus)        hostcol=$(style bold 2:83 ) ;;
	esac

	PS1="\n${hostcol}\\h${rs}"
	if [[ -n "${TMUX}" ]]; then
		local sid=$(tmux display-message -p '#S')
		local wid=$(tmux display-message -p '#I')
		PS1="${PS1} $(style bold 6:51)${sid}"
		PS1="${PS1}$(style bold 3:226)${wid}${rs}"
		unset sid wid
	elif [[ "${TERM}" = screen* ]]; then
		local sty=${STY#*.}
		[[ "${STY#*.}" =~ pts* ]] && sty=${STY%.*.*}
		PS1="${PS1} $(style bold 6:51)${sty}"
		PS1="${PS1}$(style bold 3:226)${WINDOW}${rs}"
		unset sty
	fi
	PS1="${PS1} [\$(promptstat \$? \j)]"
	PS1="${PS1} $(style bold 5:200)\t${rs}"
	PS1="${PS1} $(style bold 4:26)\w${rs}"
	PS1="${PS1}\n\\[$(style bold 4:26)\\]"
	[[ "${USER}" = "root" ]] && PS1="${PS1}\\[$(style bold 1:198)\\]"
	PS1="${PS1} \$ \\[${rs}\\]"

	# Terminal Title
	case "${TERM}" in
		*rxvt*|*xterm*|st*) PS1='\[\e]2;\h \w\a\]'"${PS1}" ;;
		screen*) PS1='\[\ek${PWD#${PWD%/*}/}\e\\\]'"${PS1}" ;;
	esac
}

promptinit


