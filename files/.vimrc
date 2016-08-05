set nocompatible
set t_Co=256
set background=dark
let g:solarized_termcolors=256

source $HOME/.vimrc.d/Vundlefile.vim

filetype plugin indent on " load file type plugins + indentation
syntax enable
set encoding=utf-8
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

set splitright " open new splits to the right
set splitbelow " ... and bottom

"" Whitespace
set wrap
set linebreak                   " soft-wrap lines at word boundaries
set showbreak=+                 " symbol to display in front of wrapped lines
set tabstop=2 shiftwidth=2      " a tab is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

set textwidth=120               " number of columns before linewrap
set colorcolumn=+1              " highlight the column that code shouldn't extend beyond

"" Nop arrow keys
map <Up> <Nop>
map <Right> <Nop>
map <Down> <Nop>
map <Left> <Nop>

"" Splits
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

"" Searching
set nohlsearch                  " don't highlight search matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set wildignore+=*.gif,*.png,*.jpg,*.jpeg,*.bmp,*.tiff,*.psd,*.svg,*.woff,*.eot,*.ttf
set wildignore+=*/.git/*,*/.svn/*,*/log/*,*/vendor/*
map <space> /                   " space to search
map <C-space> ?                 " CTRL+space to search backwards

set autoread                    " when a file's content's have changed, automatically load it again

if has("autocmd")
  "" Filetypes
  autocmd BufRead,BufNewFile *.rabl setf ruby
  autocmd BufRead,BufNewFile *.god setf ruby
  autocmd BufRead,BufNewFile *.cap setf ruby
  " use set filetype to override default
  autocmd BufRead,BufNewFile *.htm.erb set filetype=html.eruby
  autocmd BufRead,BufNewFile *.json setf javascript
  autocmd BufRead,BufNewFile *.ejson setf javascript
  autocmd BufRead,BufNewFile *.json.erb setf javascript.eruby
  autocmd BufRead,BufNewFile *.json.jbuilder setf ruby
  autocmd BufRead,BufNewFile *.ejs setf javascript
  autocmd BufRead,BufNewFile *.es6 setf javascript
  autocmd BufRead,BufNewFile *.go setf go
  " File types that require tabs, not spaces
  autocmd FileType make set noexpandtab
  autocmd FileType python set noexpandtab

  " Manage whitespace on save, maintaining cursor position
  function ClearTrailingWhitespace()
    let g:clearwhitespace = exists('g:clearwhitespace') ? g:clearwhitespace : 1
    if g:clearwhitespace
      let save_cursor = getpos(".")
      :silent! %s/\s\+$//e " clear trailing whitespace at the end of each line
      :silent! %s/\($\n\)\+\%$// " clear trailing newlines
      call setpos('.', save_cursor)
    endif
  endfunction
  autocmd FileType ruby,haml,eruby,javascript,coffee,css,scss,lua,handlebars,yaml autocmd BufWritePre <buffer> call ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " Close when NERDTree is the last open buffer
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

  autocmd FileType html,css,haml,eruby,handlebars,liquid EmmetInstall
endif

"" shortcut to re-source .vimrc
map :src :source<space>$MYVIMRC

"" line numbers
function! ToggleLineNumberMode()
  if(&relativenumber == 1)
    set relativenumber!
    set number
  else
    set number!
    set relativenumber
  endif
endfunc

nmap <leader>l :call ToggleLineNumberMode()<CR>

" tab completion
imap <Tab> <C-N>

"allows you to use . command in visual mode; harmless otherwise
vnoremap . :normal.<CR>

" shortcut to use the 'q' macro
nmap <space> @q

"" Plugins
let g:vim_markdown_folding_disabled = 1

"" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = '<C-X>'

" CommandT
nmap <silent> <C-P> :CommandT<CR>
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*"
let g:CommandTFileScanner="git"

" NERDTree
nmap <silent> <C-D> :NERDTreeToggle<CR>
nmap <leader>t :NERDTreeFind<CR>
let g:NERDSpaceDelims=1

" airline
set laststatus=2
let g:airline_powerline_fonts              = 1
let g:airline_section_z                    = airline#section#create_right(["%l/%L"])
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme                        = "badwolf"

" syntastic
nmap <leader>sc :SyntasticCheck<CR>

let g:syntastic_always_populate_loc_list  = 1
let g:syntastic_auto_loc_list             = 1
let g:syntastic_check_on_open             = 0
let g:syntastic_check_on_wq               = 1
let g:syntastic_eruby_ruby_quiet_messages = { 'regex': 'possibly useless use of a variable in void context' }
let g:syntastic_ruby_rubocop_exec         = "rubocop-syntastic"
let g:syntastic_ruby_checkers             = ["rubocop"]
let g:syntastic_javascript_checkers       = ["jshint", "eslint", "jsxhint"]
let g:syntastic_cucumber_checkers         = []

" localvimrc
let g:localvimrc_ask     = 0
let g:localvimrc_sandbox = 0

" replace all hashrocket 1.8 style ruby hashes with 1.9 style
map :RubyHashConvert :s/\v:([^ ]+)\s*\=\>/\1:/g
nmap <leader>h :RubyHashConvert<CR>

" Treat these tags like the block tags they are
let g:html_indent_tags = 'li\|p\|header\|footer\|section\|aside\|nav'

" Ack
nmap <leader>f :Ack<space>

" use ag if available
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
endif

" <leader>= to call Tab /=
nmap <leader>= :Tab /=<CR>

" <leader><leader> to switch to last buffer
nnoremap <leader><leader> <c-^>

