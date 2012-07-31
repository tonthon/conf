"Pour le collage"
set pt=<F5>
set vb t_vb="
set expandtab
set ts=4
syntax on
filetype indent on
filetype plugin on
set autoindent
if $LC_TERMBG == 'dark'
    set bg=dark
endif
if $LC_TERMBG == 'light'
    set bg=light
endif

set hlsearch          " Surligne les resultats de recherche
set nowrap            " Pas de retour a la ligne auto (affichage)
set showmatch         " Affiche parenthese correspondante
set softtabstop=4     " Largeur d'une tabulation
set shiftwidth=4      " Largeur de l'indentation
"set fdm=indent        " Repli selon l'indentation
" " Police de caractere pour gvim
set guifont=Deja\ Vu\ Sans\ Mono\ Bold\ 9
set wrap

map T :TaskList<CR>
map CL :TlistToggle<CR>

autocmd BufRead *.lzx set filetype=lzx
autocmd BufRead *.ptl set filetype=python
autocmd BufRead *.rpy set filetype=python
autocmd BufRead *.tac set filetype=python
autocmd BufRead *.eol set filetype=dosini
autocmd BufRead nginx.* set filetype=nginx
autocmd BufRead .pystartup set filetype=python
autocmd BufRead *.mako set filetype=mako
autocmd BufRead *.mak set filetype=mako
autocmd BufRead *.kv set filetype=kivy

"autocmd bufnewfile *.py so /home/gas/.vim/header.txt
autocmd! BufNewFile * silent! so ~/.vim/skel/tmpl.%:e

autocmd bufnewfile *.py exe "1," . 10 . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.py exe "1," . 10 . "g/Creation Date :.*/s//Creation Date : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.py execute "normal ma"
autocmd Bufwritepre,filewritepre *.py  exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.py execute "normal `a"
au BufRead,BufNewFile *.cf set ft=cf3
au BufRead,BufNewFile /etc/cfengine3/*.* set ft=cf3


autocmd bufnewfile *.js exe "1," . 10 . "g/File Name :.*/s//File Name : " .expand("<afile>:f:e")
autocmd bufnewfile *.css exe "1," . 10 . "g/File Name :.*/s//File Name : " .expand("%")
"autocmd bufnewfile *.html so /home/gas/.vim/html.txt
"autocmd bufnewfile *.php so /home/gas/.vim/php.txt
"autocmd bufnewfile *.js so /home/gas/.vim/jscss.txt
"autocmd bufnewfile *.css so /home/gas/.vim/jscss.txt


au FileType html,css setl shiftwidth=2
au FileType html,css setl softtabstop=2
au FileType html,css setl tabstop=2

""""""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""""""
au FileType python call PythonFold()

function! PythonFold()
    call SetColorColumn()
    filetype plugin indent on
endfunction

" Supprime les espaces en fin de ligne avant de sauver
autocmd BufWrite *.* silent! %s/[\r \t]\+$//
"
autocmd FileType python set omnifunc=pythoncomplete#Complete

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
    setl shiftwidth=2
    setl softtabstop=2
    setl tabstop=2

    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
    inoremap ( ()<Esc>i
    inoremap [ []<Esc>i
    inoremap { {}<Esc>i
    inoremap ) <c-r>=ClosePair(')')<CR>
    inoremap ] <c-r>=ClosePair(']')<CR>
    inoremap } <c-r>=ClosePair('}')<CR>
    inoremap " <c-r>=QuoteDelim('"')<CR>
    inoremap ' <c-r>=QuoteDelim("'")<CR>

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
    call SetColorColumn()
endfunction
"""""""""""""""""""""""""""""""""""
" => Php section
"""""""""""""""""""""""""""""""""""
au filetype php call PhpFold()
autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>

function! PhpFold()
    setl shiftwidth=2
    setl softtabstop=2
    setl tabstop=2

    inoremap ( ()<Esc>i
    inoremap [ []<Esc>i
    inoremap { {}<Esc>i
    inoremap ) <c-r>=ClosePair(')')<CR>
    inoremap ] <c-r>=ClosePair(']')<CR>
    inoremap } <c-r>=ClosePair('}')<CR>
    inoremap " <c-r>=QuoteDelim('"')<CR>
    inoremap ' <c-r>=QuoteDelim("'")<CR>
    call SetColorColumn()
endfunction
function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf

function CloseBracket()
    if match(getline(line('.') + 1), '\s*}') < 0
        return "\<CR>}"
    else
        return "\<Esc>j0f}a"
    endif
endf

function QuoteDelim(char)
    let line = getline('.')
    let col = col('.')
    if line[col - 2] == "\\"
        "Inserting a quoted quotation mark into the string
        return a:char
    elseif line[col - 1] == a:char
        "Escaping out of the string
        return "\<Right>"
    else
        "Starting a string
        return a:char.a:char."\<Esc>i"
    endif
endf
function! SetColorColumn()
    if exists('+colorcolumn')
        set colorcolumn=80
    else
        let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    endif
endf
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
