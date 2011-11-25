"Pour le collage"
set pt=<F5>
set vb t_vb="
set expandtab
set ts=4
syntax on
filetype indent on
filetype plugin on
set autoindent

set hlsearch          " Surligne les resultats de recherche
set nowrap            " Pas de retour a la ligne auto (affichage)
set showmatch         " Affiche parenthese correspondante
set softtabstop=4     " Largeur d'une tabulation
set shiftwidth=4      " Largeur de l'indentation
"set fdm=indent        " Repli selon l'indentation

autocmd BufRead *.lzx set filetype=lzx
autocmd BufRead *.ptl set filetype=python
autocmd BufRead *.rpy set filetype=python
autocmd BufRead *.tac set filetype=python
autocmd BufRead *.eol set filetype=dosini
autocmd BufRead nginx.* set filetype=nginx
autocmd BufRead .pystartup set filetype=python

autocmd bufnewfile *.py so /home/gas/.vim/header.txt
autocmd bufnewfile *.py exe "1," . 10 . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.py exe "1," . 10 . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.py execute "normal ma"
autocmd Bufwritepre,filewritepre *.py  exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.py execute "normal `a"
autocmd bufnewfile *.html so /home/gas/.vim/html.txt


" Supprime les espaces en fin de ligne avant de sauver
autocmd BufWrite *.py silent! %s/[\r \t]\+$//
"
" " Police de caractere pour gvim
set guifont=Deja\ Vu\ Sans\ Mono\ Bold\ 9
set wrap
if exists('+colorcolumn')
      set colorcolumn=80
  else
        au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    endif

let g:pydiction_location = '/home/gas/.vim/other/complete-dict'

"autocmd FileType python runtime! autoload/pythoncomplete.vim
"autocmd FileType python set omnifunc=pythoncomplete#Complete
""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> AJS.log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction
"""""""""""""""""""""""""""""""""""
" => Php section
"""""""""""""""""""""""""""""""""""
au filetype php call PhpFold()

function! PhpFold()
    setl shiftwidth=2
    setl softtabstop=2
    setl tabstop=2
endfunction
