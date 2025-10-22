" ===========================================
" .vimrc — Martin Stadler (mestadler)
" Simple configuration for editing
" ===========================================

" --- Basic Settings ---
set nocompatible              " Use Vim defaults (not vi)
set number                    " Show line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in status line
set showmode                  " Show current mode
set wildmenu                  " Command-line completion
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case-insensitive search
set smartcase                 " Unless search contains uppercase
set autoindent                " Auto indent
set smartindent               " Smart indent
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab = 4 spaces
set shiftwidth=4              " Indent = 4 spaces
set softtabstop=4             " Backspace = 4 spaces
set backspace=indent,eol,start " Backspace behavior
set encoding=utf-8            " UTF-8 encoding
set mouse=a                   " Enable mouse support
set clipboard=unnamedplus     " Use system clipboard
set wrap                      " Wrap long lines
set linebreak                 " Break at word boundaries
syntax on                     " Syntax highlighting
filetype plugin indent on     " File type detection

" --- System Clipboard Integration ---
" Ctrl+C to copy to system clipboard (visual mode)
vnoremap <C-c> "+y

" Ctrl+X to cut to system clipboard (visual mode)
vnoremap <C-x> "+d

" Ctrl+V to paste from system clipboard (insert and normal mode)
inoremap <C-v> <C-r>+
nnoremap <C-v> "+p

" --- Quality of Life ---
" Clear search highlighting with Escape
nnoremap <silent> <Esc> :noh<CR><Esc>

" Save with Ctrl+S (requires terminal config)
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit with Ctrl+Q
nnoremap <C-q> :q<CR>

" --- File Type Specific ---
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal wrap linebreak

" --- Status Line ---
set laststatus=2              " Always show status line
set statusline=%F%m%r%h%w\ [%l/%L,%c]\ [%p%%]

" --- Color Scheme (if available) ---
silent! colorscheme desert

" --- Backup and Swap Files ---
set nobackup                  " No backup files
set nowritebackup             " No backup before overwriting
set noswapfile                " No swap files

" ===========================================
" Note: For Ctrl+C/V to work in terminal:
" 1. Make sure you're using a modern terminal
" 2. Terminal must support clipboard (most do)
" 3. On Linux: may need xclip or xsel installed
"    sudo apt install xclip
" ===========================================
