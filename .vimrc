"plugin by vim-plug
call plug#begin()
    Plug 'scrooloose/nerdtree'
    Plug 'scrooloose/syntastic'
    Plug 'Shougo/neocomplete'
    Plug 'tokorom/vim-review'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mattn/emmet-vim'
    Plug 'skanahira/preview-markdown.vim'
call plug#end()

"syntastic setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_python_checkers = ['pylint']

let g:vim_review#include_filetypes=['c',"python","sh","java"]
"end

"neocomplete setup
let g:neocomplete#enable_at_startup=1
let g:neocomplete#max_list=25
inoremap <expr><C-l> neocomplete#complete_common_string()

"let g:neocomplete#max_keyword_width = 80
"let g:neocomplete#enable_ignore_case = 1
"highlight Pmenu ctermbg=6
"highlight PmenuSel ctermbg=3
"highlight PMenuSbar ctermbg=0
"inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : “<CR>”
"end

"powerline setup

set t_Co=256

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'dark'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

"end

"my funcs

command! -nargs=+ Atcoder call SetAtcoder(<f-args>)

function SetAtcoder(...)
    if a:0 == 1
        if a:1 == 'd'
            so $HOME/.vim/atcoder/setup/d.vim
        elseif a:1 == 'ds'
            so $HOME/.vim/atcoder/setup/simpled.vim
        elseif a:1 == 'cpp'
            so $HOME/.vim/atcoder/setup/cpp.vim
        else
            echo "Atcoder: file type '" . a:1 . "' not found."
        endif
    elseif a:0 == 2
        if a:2 == 'old'
            if a:1 == 'd'
                so $HOME/.vim/atcoder/setup/d_2.071_0.vim
            else
                echo "Atcoder: file type '" . a:1 . " " . a:2 . "' not found."
            endif
        else
            echo "Atcoder: file type '" . a:1 . " " . a:2 . "' not found."
        endif
    else
        echo "Atcoder: too many arguments."
    endif
endfunction

command! -nargs=? LaTeXReport call SetLaTeXReport(<f-args>)

function SetLaTeXReport(...)
    if a:0 == 0
        so $HOME/.vim/latex/setup/report.vim
    endif

endfunction

command! -nargs=? LaTeXBeamer call SetLaTeXBeamer(<f-args>)

function SetLaTeXBeamer(...)
    if a:0 == 0
        so $HOME/.vim/latex/setup/beamer.vim
    endif

endfunction

command! -nargs=? LaTeXTikZ call SetLaTeXTikZ(<f-args>)

function SetLaTeXTikZ(...)
    if a:0 == 0
        so $HOME/.vim/latex/setup/tikz.vim
    endif

endfunction

command! -nargs=? LaTeXBook call SetLaTeXBook(<f-args>)

function SetLaTeXBook(...)
    if a:0 == 0
        so $HOME/.vim/latex/setup/book.vim
    endif

endfunction

command! -nargs=? LaTeXTemplate call EditLaTeXTemplate(<f-args>)

function EditLaTeXTemplate(...)
    if a:0 == 0
        vs $HOME/.vim/latex/templates/report.tex
    endif
endfunction

command! LaTeXPDF call SaveAndConvertLaTeXtoPDF()

function SaveAndConvertLaTeXtoPDF()
    write
    !lpreport "%:r"
endfunction

command! OpenPDF !evince "%:r.pdf" &

function ExecuteRDMD()
    write
    !rdmd "%:r"
endfunction

command! RDMD call ExecuteRDMD()

command! ReplacePanctuations call ReplaceJapanesePancuationsTraditionalToAcademic()

function ReplaceJapanesePancuationsTraditionalToAcademic()
    %s/。/．/g
    %s/、/，/g
endfunction

"end

"basic settings

set encoding=utf-8
set number
set showmatch
set hlsearch
set synmaxcol=400
set tabstop=4
set softtabstop=4
set wildmode=list:longest
set expandtab
set shiftwidth=4
set autoindent
set cindent
set wildmenu
set history=5000
set laststatus=2
set timeoutlen=500
syntax on
filetype plugin on

let mapleader="\<Space>"

inoremap (<CR> ()<LEFT><CR><ESC><S-o>
inoremap {<CR> {}<LEFT><CR><ESC><S-o>
inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
inoremap '<CR> '
inoremap "<CR> "
inoremap <<CR> <><LEFT>
inoremap ;<Leader><Leader> <ESC>A;
inoremap {<Leader><Leader> <ESC>A{}<LEFT>
inoremap {<Leader><Leader><CR> <ESC>A{}<LEFT><CR><ESC><S-o>
inoremap (<Leader><Leader> <ESC>A()<LEFT>
inoremap /*<CR> /**/<LEFT><LEFT>
inoremap $$ $$<LEFT>


nnoremap sh <C-h>
nnoremap sj <C-j>
nnoremap sk <C-k>
nnoremap sl <C-l>
nnoremap sw <C-w>
