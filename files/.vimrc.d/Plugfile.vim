set nocompatible
set t_Co=256
set background=dark
filetype off

call plug#begin('~/.vim/bundle')

" Common plugins (always loaded)
Plug 'mileszs/ack.vim'
Plug 'wincent/command-t', { 'do': 'cd ruby/command-t && ruby extconf.rb && make clean && make' }
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'roman/golden-ratio'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/localvimrc'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'altercation/vim-colors-solarized'

" Rubby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-cucumber'

" Python
" Plug 'vim-scripts/python'
Plug 'nvie/vim-flake8'

" Closure
Plug 'tpope/vim-fireplace'

" Javascript
Plug 'nono/vim-handlebars'
Plug 'heartsentwined/vim-ember-script'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Go
Plug 'fatih/vim-go'
Plug 'ekalinin/Dockerfile.vim'

" HTML/Markdown
Plug 'plasticboy/vim-markdown'
Plug 'mattn/emmet-vim'

" Rust
Plug 'rust-lang/rust.vim'

" Swift
Plug 'keith/swift.vim'

" Scala
Plug 'derekwyatt/vim-scala'

call plug#end()
