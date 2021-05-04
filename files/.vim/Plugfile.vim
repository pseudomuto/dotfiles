set nocompatible
set t_Co=256
set background=dark
filetype off

call plug#begin('~/.vim/bundle')

" Common plugins (always loaded)
Plug 'mileszs/ack.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '~/.vim/bundle/fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'scrooloose/nerdcommenter'
Plug 'roman/golden-ratio'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'embear/vim-localvimrc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'
Plug 'w0rp/ale'

" C++
Plug 'JBakamovic/cxxd-vim', { 'for': 'cpp' }
Plug 'rhysd/vim-clang-format', { 'for': 'cpp' }

" Rubby / Crystal
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
Plug 'tpope/vim-rails'
Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }

" Python
Plug 'nvie/vim-flake8', { 'for': 'python' }

" Clojure
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Javascript
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee', 'coffeescript' ] }
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.eruby'] }
Plug 'mxw/vim-jsx', { 'for': 'javascript.jsx' }
Plug 'jparise/vim-graphql'
Plug 'dart-lang/dart-vim-plugin', { 'for': 'dart' }

" Go
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'ekalinin/Dockerfile.vim'

" HTML/Markdown/Templates
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mattn/emmet-vim'
Plug 'glench/vim-jinja2-syntax'

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" Swift
Plug 'keith/swift.vim', { 'for': 'swift' }

" Scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

" E(xtended) BNF
Plug 'killphi/ebnf.vim'

" for them nix files
Plug 'LnL7/vim-nix', { 'for': 'nix' }

call plug#end()
