set number showmode ai cursorline nocompatible hlsearch
set expandtab tabstop=4 shiftwidth=4
filetype plugin indent on
syntax on
colors colorblind
" Fuck your background color
"hi Normal ctermbg=none
"hi Visual ctermbg=0xff4500
hi OverLength ctermbg=red ctermfg=white
match OverLength /\%80v.\+/

:nnoremap <F8> :setl noai nocin nosi inde=<CR>
"vnoremap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
"nmap <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>

" Idea by Ben Hartley
"function! Terms()
"	call inputsave()
"	let searchterm = input('Search: ')
"	call inputrestore()
"	return searchterm
"endfunction
"map <ESC>:! firefox 'https://duckduckgo.com/?q=<C-R>=Terms()<CR>'<CR><CR>
