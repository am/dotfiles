" https://github.com/JHaals/.dotfiles/blob/master/.vimrc

syntax on
filetype plugin indent on
set backspace=2 " make backspace work like most other apps

set encoding=utf-8
"colorscheme railscasts
set background=dark
colorscheme Tomorrow-Night
set autoindent      " Indent same level as the previous line
"set t_Co=256        " 256 colors
set smartindent
map <F3> :set list!
set title

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" TABS
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set listchars=tab:»\ ,trail:·
set list
cmap w!! %!sudo tee > /dev/null %

" SEARCH highlight
set incsearch
set hlsearch

"syntac check
let mapleader = ","

let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list=2
let g:syntastic_mode_map = { 'mode': 'active',
    \ 'active_filetypes': ['puppet', 'ruby', 'php', 'bash'],
    \ 'passive_filetypes': [] }

autocmd BufReadPost * :SyntasticCheck

map <Leader>e :SyntasticCheck<CR>

map <Leader>n :set nonumber<CR>
map <Leader>y "+y<CR>

" Enable the mouse
"set mouse=a

" Show matching brackets/paranthesis
set showmatch

" Python-mode
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_syntax_print_as_function = 1

" Trim whitespace off line-endings on save
autocmd BufWritePre * :%s/\s\+$//e

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Highlight current line only for active window
autocmd BufWinEnter * setlocal cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" On OSX
vmap <D-c> y:call system("pbcopy", getreg("\""))<CR>
nmap <D-v> :call setreg("\"",system("pbpaste"))<CR>p
execute pathogen#infect()
