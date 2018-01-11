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
set tabstop=4        " ts, number of spaces that a tab read from a file is equivalent to
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

" set statusline=%{fugitive#statusline()}

set diffopt=horizontal

let html_use_css = 1 " Use stylesheet instead of inline style
let html_number_lines = 0
let html_no_pre = 1

" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: Wed Dec 06, 2017  12:43PM
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
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 



map gn :bn<cr>
map gp :bp<cr>

map <C-n> :NERDTreeToggle<CR>

filetype off

let mapleader=","

if has('nvim')
  if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif 
else
  if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  endif
endif 

call plug#begin()

Plug 'Lokaltog/vim-easymotion'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'git://git.wincent.com/command-t.git'
" Plug 'airblade/vim-gitgutter'

"Plugin 'scrooloose/syntastic.git'
Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
"Plugin 'tpope/vim-fugitive'

"Plugin 'klen/python-mode'

Plug 'vim-pandoc/vim-pandoc'

Plug 'chiphogg/vim-airline'

Plug 'fatih/vim-go'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'godoctor/godoctor.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plugin 'Townk/vim-autoclose'
"Plugin 'nanotech/jellybeans.vim'

Plug 'nsf/gocode', {'rtp': 'vim/'}

Plug 'derekwyatt/vim-scala'
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'

" Plugin 'kien/ctrlp.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-scripts/minibufexpl.vim'

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'google/vim-maktaba'

Plug 'flazz/vim-colorschemes'

Plug 'godlygeek/tabular'
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
Plug 'metakirby5/codi.vim'

Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'

Plug 'bkad/CamelCaseMotion'

Plug 'reedes/vim-pencil'
Plug 'google/vim-codefmt'
Plug 'lpenz/vim-codefmt-haskell'
"Plug 'artur-shaik/vim-javacomplete2'

Plug 'wakatime/vim-wakatime'

Plug 'martinda/Jenkinsfile-vim-syntax'

se t_Co=256
set background=dark

if filereadable(expand('~/.at_google'))
  " Google only
  source ~/.vimrc.google
else
  " Non-google only
  Plug 'Valloric/YouCompleteMe'
  Plug 'google/vim-glaive'
endif

call plug#end()
call glaive#Install()

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
augroup END

set t_Co=256
colorscheme grb256

let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1}

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let g:EclimCompletionMethod = 'omnifunc'

let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

let g:deoplete#enable_at_startup = 1

set conceallevel=2

noremap <leader>ve :edit $HOME/.vimrc<CR>
noremap <leader>vs :source $HOME/.vimrc<CR>
noremap <leader>fl :FormatLines<CR>

noremap <leader>y "+y

nnoremap tk :tabprevious<CR>
nnoremap tj :tabnext<CR>
nnoremap tn :tabnew<CR>
nnoremap tt :tabedit<Space>

" noremap <leader>e :CtrlP<CR>

inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

inoremap <expr> <Down>     pumvisible() ? "\<C-e>\<Down>"     : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-e>\<Up>"       : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<C-e>\<PageDown>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<C-e>\<PageUp>"   : "\<PageUp>"

nnoremap <leader>ff :FZF<CR>
nnoremap <leader>mc :call ToggleConceal()<CR>
nnoremap <leader>mt :Toch<CR>
"
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" vim-go mappings
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>i <Plug>(go-info)


" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>


let g:go_list_type = "quickfix"
let g:go_auto_type_info = 0
let g:go_auto_sameids = 1
"let g:go_fmt_command = "goimports"

" END vim-go mappings

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

set rtp+=$GOROOT/misc/vim

function! ToggleConceal()
    if &conceallevel != 0
        set conceallevel=0
        echo "Conceal Off"
    else
        set conceallevel=2
        echo "Conceal on"
    endif
endfunction

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd Filetype go nmap <leader>r <Plug>(go-run)

"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0

filetype plugin indent on
