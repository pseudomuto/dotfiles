set nocompatible
set t_Co=256
set background=dark
filetype off

call plug#begin('~/.vim/bundle')

" Common plugins (always loaded)
Plug 'mileszs/ack.vim'
Plug 'wincent/command-t', { 'on': 'CommandT', 'do': 'cd ruby/command-t && ruby extconf.rb && make clean && make' }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'roman/golden-ratio'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/localvimrc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'

" Rubby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }

" Python
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Closure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Javascript
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee', 'coffeescript' ] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.eruby'] }
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }

" Go
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'ekalinin/Dockerfile.vim'

" HTML/Markdown
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mattn/emmet-vim'

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" Swift
Plug 'keith/swift.vim', { 'for': 'swift' }

" Scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

call plug#end()
