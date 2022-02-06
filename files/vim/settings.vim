set background=dark
set encoding=utf-8
set nocompatible
set t_Co=256
let g:solarized_termcolors=256

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
set wrap linebreak                       " soft-wrap lines at word boundaries
set showbreak=+                          " symbol to display in front of wrapped lines
set tabstop=2 softtabstop=2 shiftwidth=2 " a tab is two spaces
set expandtab autoindent smarttab        " use spaces over tabs (unless overridden by an ftplugin file)
set backspace=indent,eol,start           " backspace through everything in insert mode

set textwidth=120               " number of columns before linewrap
set colorcolumn=+1              " highlight the column that code shouldn't extend beyond
set fileformat=unix
set formatoptions=croql

"" Searching
set nohlsearch                  " don't highlight search matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set wildignore+=*.gif,*.png,*.jpg,*.jpeg,*.bmp,*.tiff,*.psd,*.svg,*.woff,*.eot,*.ttf
set wildignore+=*/.git/*,*/.svn/*,*/log/*,*/vendor/*

set autoread
set laststatus=2

"" Plugins
let g:vim_markdown_folding_disabled = 1

"" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = "<C-X>"

" CommandT
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*"
let g:CommandTFileScanner="git"

" NERDTree
let g:NERDSpaceDelims=1
let g:NERDTreeIgnore=["__pycache__", "\.egg-info", "\.pyc", "bazel-.*$[[dir]]"]

" airline
let g:airline_powerline_fonts        = 1
let g:airline_section_z              = airline#section#create_right(["%l/%L"])
let g:airline#extensions#ale#enabled = 1
let g:airline_theme                  = "badwolf"

" ale global
let g:ale_set_loclist          = 0 " disable loc list
let g:ale_set_quickfix         = 1 " use quickfix list instead
let g:ale_lint_on_enter        = 0 " don't lint when opening a file
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save          = 1 " lint/correct on save
let g:ale_sign_column_always   = 1 " leave the column open all the time

let g:ale_rust_cargo_use_check = 1

" localvimrc
let g:localvimrc_ask     = 0
let g:localvimrc_sandbox = 0

" Treat these tags like the block tags they are
let g:html_indent_tags = 'li\|p\|header\|footer\|section\|aside\|nav'

" use ag if available
if executable("ag")
  let g:ackprg = "ag --nogroup --column"
endif

" go
let g:go_fmt_command = "goimports"

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_command  = "cargo fmt -- "

" scala
let g:scala_scaladoc_indent = 1
