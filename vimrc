
filetype plugin indent on
syntax on
set bg=dark
set number cursorline showcmd hls
set ts=8

color jellybeans

au BufNewFile,BufRead *.js	setl sw=2 ts=2 expandtab 
au BufNewFile,BufRead *.[ch]	setl sw=8 ts=8 noexpandtab
au BufNewFile,BufRead *.hs	setl sw=4 ts=4 expandtab 

" Folding
function! FoldText() "{{{
	let line = substitute(getline(v:foldstart), "\s*{"."{{\s*", "", "")
	let len = v:foldend - v:foldstart

	return line . ' ('.len.' lines) '
endfunction "}}}
set foldtext=FoldText()


