
filetype plugin indent on
syntax on
set bg=dark
set number cursorline showcmd

color jellybeans

au BufNewFile,BufRead *.js	set sw=2 ts=2 expandtab 
au BufNewFile,BufRead *.[ch]	set sw=4 ts=4 noexpandtab

" Folding
function! FoldText() "{{{
	let line = substitute(getline(v:foldstart), "\s*{"."{{\s*", "", "")
	let len = v:foldend - v:foldstart

	return line . ' ('.len.' lines) '
endfunction "}}}
set foldtext=FoldText()


