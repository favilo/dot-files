" Name this file .vimrc (the dot is important) and put it in your home directory
" GENERAL OPTIONS
set nocompatible
filetype off


behave xterm
set viminfo='20,\"500,%    " ' Maximum number of previously edited files for which the marks
            "   are remembered.
            " " Maximum number of lines saved for each register.
            " % When included, save and restore the buffer list.  If Vim is
            "   started with a file name argument, the buffer list is not
            "   restored.  If Vim is started without a file name argument, the
            "   buffer list is restored from the viminfo file.  Buffers
            "   without a file name and buffers for help files are not written
            "   to the viminfo file.
set history=1000     " keep {number} lines of command line history
set tabstop=8        " ts, number of spaces that a tab read from a file is equivalent to
set softtabstop=4    " number of spaces that a tab read from the keyboard, keymap or
                        "   abbreviation is equivalent to
set shiftwidth=4    " sw, number of spaces shifted left and right when issuing << and >>
            "   commands
set expandtab           " don't output tabs; replace with spaces.
set autoindent          " follow current indentation
set smartindent         " obey brace-indentation rules
set nocompatible
set backspace=2

set tw=80

set listchars=tab:▸\ ,eol:¬

syntax on

set cinoptions=:0,p0,t0
set cinwords=if,unless,else,while,until,do,for,switch,case
set formatoptions=tcqr
set cindent

" VIM DISPLAY OPTIONS
set showmode        " show which mode (insert, replace, visual)
set ruler
set title
set showcmd        " show commands in status line when typing
set wildmenu
set showmatch
set incsearch
set wrap        " wrap long lines
" Make breaks more obvious
set showbreak=+++\ \  
set number        " number lines
set mouse=a
set clipboard=unnamedplus

set statusline=%{fugitive#statusline()}

set diffopt=horizontal

let html_use_css = 1 " Use stylesheet instead of inline style
let html_number_lines = 0
let html_no_pre = 1

" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
    if &modified
        let save_cursor = getpos(".")
        let n = min([20, line("$")])
        exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
            \ strftime('%a %b %d, %Y  %I:%M%p') . '#e'
        call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre * call LastModified()

set grepprg=grep\ -nH\ $*
filetype indent on

let g:ledger_maxwidth = 80
let g:ledger_fillstring = '   »   »'

let g:miniBufExplMapWindowNavVim=1

map gn :bn<cr>
map gp :bp<cr>

filetype off

let mapleader=","

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'airblade/vim-gitgutter'

"Plugin 'scrooloose/syntastic.git'

Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'

"Plugin 'klen/python-mode'

Plugin 'vim-pandoc/vim-pandoc'

Plugin 'chiphogg/vim-airline'

Plugin 'jnwhiteh/vim-golang'
'
"Plugin 'Townk/vim-autoclose'
"Plugin 'nanotech/jellybeans.vim'

Plugin 'nsf/gocode', {'rtp': 'vim/'}

Plugin 'vimwiki/vimwiki'

" Plugin 'kien/ctrlp.vim'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'junegunn/fzf'

Plugin 'google/vim-maktaba'


set t_Co=256
set background=dark
"colorscheme jellybeans

if filereadable(expand('~/.at_google'))
  " Google only
  source ~/.vimrc.google
else
  " Non-google only
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'google/vim-codefmt'
  Plugin 'google/vim-glaive'
endif

call vundle#end()
call glaive#Install()
Glaive codefmt plugin[mappings]

let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1, 'py': 1}

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:EclimCompletionMethod = 'omnifunc'

let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

noremap <leader>ve :edit $HOME/.vimrc<CR>
noremap <leader>vs :source $HOME/.vimrc<CR>
noremap <leader>fl :FormatLines<CR>

noremap <leader>y "+y

" noremap <leader>e :CtrlP<CR>

inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

inoremap <expr> <Down>     pumvisible() ? "\<C-e>\<Down>"     : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-e>\<Up>"       : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<C-e>\<PageDown>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<C-e>\<PageUp>"   : "\<PageUp>"

cnoremap <leader>ff <C-R>=fzf#run({'down': '40%'})<CR><CR>

let g:gofmt_command = "goimports"
set rtp+=$GOROOT/misc/vim

function RunGlaze()
  let path = expand('%:p')
  if match(path, "/google3/") > 0
    let dir = fnamemodify(path, ':h')
    silent exe "!glaze " . dir . " 2>/tmp/vim.glaze.$USER.err"
    let w = winnr()
    cf /tmp/vim.glaze.$USER.err
    cwindow 3
    exe w . "wincmd w"
    redraw!
  endif
endfunction

autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufWritePost *.go call RunGlaze()

filetype plugin indent on
