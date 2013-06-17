
if status -l
	set -gx PATH ~/bin $PATH /usr/local/bin
end

[ -f ~/.aliases ]; and . ~/.aliases

