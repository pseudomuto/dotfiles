filetype off " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle required!
Plugin 'gmarik/Vundle.vim'

" My Bundles here:
Plugin 'mileszs/ack.vim'
Plugin 'wincent/command-t'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/localvimrc'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-fireplace'
Plugin 'roman/golden-ratio'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'

" Syntax
Plugin 'scrooloose/syntastic'
Plugin 'nono/vim-handlebars'
Plugin 'kchmck/vim-coffee-script'
Plugin 'fatih/vim-go'
Plugin 'heartsentwined/vim-ember-script'
Plugin 'plasticboy/vim-markdown'
Plugin 'mattn/emmet-vim'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'vim-scripts/python.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-cucumber'

" Colour Schemes
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
