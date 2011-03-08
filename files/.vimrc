set showmatch
"Pour le collage"
set pt=<F5>
set vb t_vb="
set shiftwidth=4
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


" Supprime les espaces en fin de ligne avant de sauver
autocmd BufWrite * silent! %s/[\r \t]\+$//
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
