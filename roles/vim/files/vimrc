" Name this file .vimrc (the dot is important) and put it in your home directory
" GENERAL OPTIONS
set nocompatible
filetype off

if &shell =~# 'fish$'
    set shell=bash
endif

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
set tabstop=2        " ts, number of spaces that a tab read from a file is equivalent to
set softtabstop=2    " number of spaces that a tab read from the keyboard, keymap or
                        "   abbreviation is equivalent to
set shiftwidth=2    " sw, number of spaces shifted left and right when issuing << and >>
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
let g:miniBufExplMaxSize = 1
let g:miniBufExplMaxHeight = 1
let g:go_version_warning = 0

noremap <C-J>   <C-W>j
noremap <C-K>   <C-W>k
noremap <C-H>   <C-W>h
noremap <C-L>   <C-W>l

noremap <C-TAB> :MBEbn<CR>
noremap <C-S-TAB> :MBEbp<CR>

map gn :bn<cr>
map gp :bp<cr>

filetype off

let mapleader=","

if has('nvim')
  if empty(glob("~/.config/nvim/autoload/plug.vim"))
    execute '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif 
else
  if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  endif
endif 

function! BuildYCM(info)
    if a:info.status == 'installed || a.info.force
        !./install.sh
    endif
endfunction

call plug#begin()
Plug 'ervandew/supertab'

Plug 'Lokaltog/vim-easymotion'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'git://git.wincent.com/command-t.git'
" Plug 'airblade/vim-gitgutter'

"Plugin 'scrooloose/syntastic.git'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-speeddating'  " allow <C-A> to work with dates
Plug 'tpope/vim-surround'  " cs\"'
Plug 'tpope/vim-repeat'  " add . completion to tpope vim commands
Plug 'tpope/vim-fugitive'  " git bindings
Plug 'tpope/vim-rhubarb'  " git-hub command :Gbrowse
Plug 'tpope/vim-obsession'  " mksession automatically
Plug 'tpope/vim-dadbod'  " for databases, may remove

Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'jaredly/vim-debug'
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
Plug 'ervandew/supertab'
Plug 'python/black'

Plug 'vim-pandoc/vim-pandoc'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'fatih/vim-go'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'godoctor/godoctor.vim'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
"Plugin 'Townk/vim-autoclose'
"Plugin 'nanotech/jellybeans.vim'

Plug 'nsf/gocode', {'rtp': 'vim/'}

Plug 'derekwyatt/vim-scala'
Plug 'vimwiki/vimwiki'
Plug 'mattn/calendar-vim'

" Plugin 'kien/ctrlp.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'vim-scripts/minibufexpl.vim'
Plug 'fholgado/minibufexpl.vim'
"Plug 'weynhamz/vim-plugin-minibufexpl'
Plug 'Glench/Vim-Jinja2-Syntax'

Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': 'yes \| ./install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'

Plug 'google/vim-maktaba'

Plug 'flazz/vim-colorschemes'

Plug 'godlygeek/tabular'
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'metakirby5/codi.vim'

Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'

Plug 'bkad/CamelCaseMotion'

Plug 'reedes/vim-pencil'
Plug 'google/vim-codefmt'
Plug 'lpenz/vim-codefmt-haskell'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
" Plug 'artur-shaik/vim-javacomplete2'
Plug 'vim-scripts/Conque-GDB'

Plug 'wakatime/vim-wakatime'

Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'quabug/vim-gdscript'

Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'idanarye/vim-vebugger'

Plug 'dag/vim-fish'

se t_Co=256
set background=dark

if filereadable(expand('~/.at_google'))
  " Google only
  source ~/.vimrc.google
else
  " Non-google only
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  Plug 'google/vim-glaive'
endif

call plug#end()
call glaive#Install()


augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  " autocmd FileType python AutoFormatBuffer yapf
augroup END

set t_Co=256
colorscheme grb256

let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1}
" let g:ycm_python_binary_path = '/usr/bin/python3'

let g:airline_powerline_fonts = 1
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 88,
    \ 'x': 88,
    \ 'y': 95,
    \ 'z': 45,
    \ 'warning': 80,
    \ 'error': 80,
    \ }

" let g:airline_section_b = '%{FugitiveStatusline()}'
let g:airline_section_z = '%p%% %l:%c'
let g:airline_section_x = ''
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
" let g:airline#extensions#tabline#enabled = 1

let g:EclimCompletionMethod = 'omnifunc'

let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

let g:deoplete#enable_at_startup = 1
let g:indent_guides_enable_on_vim_startup = 1

let g:pymode_run = 1
let g:pymode_run_bind = '<leader>r'
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_python = 'python'
let g:pymode_indent = 0
let g:pymode_lint_on_fly = 1
let g:pymode_lint_ignore = ["E501",]
let g:jedi#completions_enabled = 0
let g:pymode_rope_autoimport=1
" let g:pymode_rope_rename_bind = '<leader>r'
"
let g:black_linelength = 79

let g:python_host_prog = 'python'

let g:rustfmt_autosave = 1

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'
" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

let vim_markdown_preview_toggle=1
let vim_markdown_preview_github=1

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev Ack Ack!
nnoremap <leader>a :Ack!<Space>

set conceallevel=2

noremap <leader>ve :edit $HOME/.vimrc<CR>
noremap <leader>vs :source $HOME/.vimrc<CR>
augroup rustfmt
  autocmd Filetype rust noremap <leader>fl :RustFmtRange<CR>
  autocmd Filetype rust noremap <leader>fc :RustFmt<CR>
augroup END

augroup pythonfmt
  autocmd Filetype python noremap <leader>fl :FormatLines<CR>
  autocmd Filetype python noremap <leader>fc :FormatCode<CR>
augroup END

noremap <leader>fl :FormatLines<CR>
noremap <leader>fc :FormatCode<CR>

noremap <leader>y "+y

nnoremap tk :tabprevious<CR>
nnoremap tj :tabnext<CR>
nnoremap tn :tabnew<CR>
nnoremap tt :tabedit<Space>

" noremap <leader>e :CtrlP<CR>
noremap <C-t> :TagbarToggle<CR>
noremap <C-b> :NERDTreeToggle<CR>

inoremap <F1> <nop>
nnoremap <F1> <nop>
vnoremap <F1> <nop>

inoremap <expr> <Down>     pumvisible() ? "\<C-e>\<Down>"     : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-e>\<Up>"       : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<C-e>\<PageDown>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<C-e>\<PageUp>"   : "\<PageUp>"

nnoremap <leader>ff :FZF<CR>
nnoremap <leader>mc :call ToggleConceal()<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" vim-go mappings
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
"nnoremap <leader>a :cclose<CR>

" autocmd FileType go nmap <leader>r <Plug>(go-run)
" autocmd FileType go nmap <leader>t <Plug>(go-test)
" autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
" autocmd FileType go nmap <Leader>i <Plug>(go-info)

autocmd FileType rust nmap <leader>gd <Plug>(rust-def)
autocmd FileType rust nmap <leader>gs <Plug>(rust-def-split)
autocmd FileType rust nmap <leader>gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gg <Plug>(rust-doc)

tnoremap <Esc> <C-\><C-n>

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
autocmd VimResized * wincmd =


"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0

filetype plugin indent on

