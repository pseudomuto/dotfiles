filetype off " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle "gmarik/vundle"

" My Bundles here:
Bundle "mileszs/ack.vim"
Bundle "kien/ctrlp.vim"
Bundle "tpope/vim-rails"
Bundle "scrooloose/nerdtree"
Bundle "scrooloose/nerdcommenter"
Bundle "vim-scripts/localvimrc"
Bundle "godlygeek/tabular"
Bundle "tpope/vim-fireplace"
Bundle "roman/golden-ratio"
Bundle "tpope/vim-surround"

" Syntax
Bundle "tpope/vim-fugitive"
Bundle "nono/vim-handlebars"
Bundle "kchmck/vim-coffee-script"
Bundle "jnwhiteh/vim-golang"
Bundle "heartsentwined/vim-ember-script"
Bundle "plasticboy/vim-markdown"
Bundle "mattn/emmet-vim"
Bundle "ekalinin/Dockerfile.vim"
Bundle "pangloss/vim-javascript"
Bundle "mxw/vim-jsx"

" Colour Schemes
Bundle "tpope/vim-vividchalk"
Bundle "nanotech/jellybeans.vim"
Bundle "altercation/vim-colors-solarized"
Bundle "jgdavey/vim-railscasts"
Bundle "sickill/vim-monokai"
