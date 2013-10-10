
filetype plugin indent on
syntax on
set bg=dark
set number cursorline showcmd hls modeline
set ts=8

color jellybeans

au BufNewFile,BufRead *.js	setl sw=2 ts=2 expandtab
au BufNewFile,BufRead *.html	setl sw=2 ts=2 expandtab
au BufNewFile,BufRead *.[ch]	setl sw=8 ts=8 noexpandtab
au BufNewFile,BufRead *.hs	setl sw=4 ts=4 expandtab
au BufNewFile,BufRead *.fish	setl sw=4 ts=4 expandtab

" Folding
function! FoldText() "{{{
	let tabsp = repeat(' ', &ts)
	let line = substitute(getline(v:foldstart), "\t", tabsp, "g")
	let len = v:foldend - v:foldstart

	return line . '   (+'.len.') '
endfunction "}}}
set foldtext=FoldText()
set foldmethod=syntax
set foldlevelstart=99
let xml_syntax_folding=1
let javaScript_fold=1
let javascript_fold='true'
let sh_fold_enabled=1
let vimsyn_folding='af'
