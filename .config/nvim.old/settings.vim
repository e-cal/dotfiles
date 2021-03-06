filetype plugin indent off
syntax enable					" Syntax highlighing
set t_Co=256                    " Support 256 colors
set shell=/usr/bin/bash         " Set default terminal shell
set showtabline=2               " Always show buffer tabs
set termguicolors				" Enable termguicolors
set background=dark             " Set background color
set hidden                      " Allow multiple buffers to be open
set nowrap                      " Don't wrap line
set number relativenumber		" Relative line numbers
set cursorline                  " Highlight current line
set splitbelow                  " Hsplit below
set splitright                  " Vsplit to the right
set colorcolumn=80              " Column at line 80
set noerrorbells                " Disable error sounds
set nohlsearch                  " Don't highlight search matches
set ignorecase                  " Default case insensitive search
set smartcase                   " Case sensitive if search has a capital letter
set mouse=a                     " Enable mouse
set scrolloff=8                 " Start scrolling before reaching the bottom
"hi! Cursor ctermfg=1 ctermbg=1 guifg=#FF0000 guibg=#FF0000 HOW DO I CHANGE MY CURSOR COLOR

" Use undofile instead of swap files for history
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile

set tabstop=4 softtabstop=4     " Tab = 4 spaces
set shiftwidth=4                " Indent = 4 space
set expandtab					" Leave tabs as tabs
set smartindent                 " Makes indenting smart
set autoindent                  " Auto indent

set encoding=utf-8              " Displayed encoding
set fileencoding=utf-8          " File encoding
set pumheight=10                " Popup menu height
set cmdheight=1                 " Space for cmd messages
set laststatus=0                " Always display the status line
set iskeyword+=-                " Treat dash separated words as a word text object
set conceallevel=0              " Show `` in markdown files
set noshowmode                  " Hide the editing mode
set nowritebackup               " This is recommended by coc
set updatetime=300              " Faster completion
set timeoutlen=500              " By default timeoutlen is 1000 ms
set clipboard=unnamedplus       " Copy paste between vim and everything else

au! BufWritePost $MYVIMRC source % " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

let g:netrw_fastbrowse = 0

let g:python_highlight_space_errors = 0 " Disable red whitespace in python
let g:polyglot_disabled = ['autoindent'] " Disable polyglot autoindent
let g:vim_markdown_conceal_code_blocks = 0
autocmd BufNewFile,BufRead *.md filetype plugin indent off
"let g:python3_host_prog = '~/.local/share/virtualenvs/nvim/bin/python'
