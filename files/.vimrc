set background=dark
set encoding=utf-8
set nocompatible
set t_Co=256
let g:solarized_termcolors=256

source $HOME/.vimrc.d/Vundlefile.vim

filetype plugin indent on " load file type plugins + indentation
syntax enable

colorscheme solarized

set visualbell      " disable audible bell
let mapleader = "," " map <Leader> to command

set showcmd        " display incomplete commands
set relativenumber " use relative line numbers
set cursorline     " highlight the current line
set ruler          " show the cursor position all the time
set list           " show invisible characters

set noswapfile " don't save swap files

"" List chars
set listchars=""                " Reset the listchars
set listchars=tab:\ \           " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:-          " show trailing spaces as dashes
set listchars+=extends:>        " The character to show in the last column when wrap is
                                " off and the line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the last column when wrap is
                                " off and the line continues beyond the right of the screen

"" Splits
set splitright " open new splits to the right
set splitbelow " ... and bottom

"" Whitespace
set wrap linebreak                " soft-wrap lines at word boundaries
set showbreak=+                   " symbol to display in front of wrapped lines
set tabstop=2 shiftwidth=2        " a tab is two spaces
set expandtab autoindent smarttab " use spaces over tabs (unless overridden by an ftplugin file)
set backspace=indent,eol,start    " backspace through everything in insert mode

set textwidth=120               " number of columns before linewrap
set colorcolumn=+1              " highlight the column that code shouldn't extend beyond
set fileformat=unix

"" Searching
set nohlsearch                  " don't highlight search matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set wildignore+=*.gif,*.png,*.jpg,*.jpeg,*.bmp,*.tiff,*.psd,*.svg,*.woff,*.eot,*.ttf
set wildignore+=*/.git/*,*/.svn/*,*/log/*,*/vendor/*

" setup autocmd, mappings, plugins, etc.
call autocmd#setup()
call mappings#setup()
call plugins#setup()
