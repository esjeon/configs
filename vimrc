
filetype plugin indent on
syntax on

set bg=dark
set showcmd hls modeline
set ts=8

if empty(matchstr($TERM, '256color'))
	set t_Co=8
else
	set t_Co=256
	color jellybeans
endif

" simpler fold message, with preserved indentation
function! FoldText() "{{{
	let tabsp = repeat(' ', &ts)
	let line = substitute(getline(v:foldstart), "\t", tabsp, "g")
	let len = v:foldend - v:foldstart

	return line . '   (+'.len.') '
endfunction "}}}
set foldtext=FoldText()

