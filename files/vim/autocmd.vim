augroup default_group
  autocmd!

  " Filetypes
  autocmd BufRead,BufNewFile *.rb,*.rabl,*.json.jbuilder,Capfile,Vagrantfile setfiletype ruby
  autocmd BufRead,BufNewFile *.htm.erb setfiletype html.eruby
  autocmd BufRead,BufNewFile *.json.erb setfiletype javascript.eruby
  autocmd BufRead,BufNewFile *.json,*.ejson,*.ehs,*.es6 setfiletype javascript
  autocmd BufRead,BufNewFile *.jsx setfiletype javascript.jsx
  autocmd BufRead,BufNewFile *.go setfiletype go
  autocmd BufRead,BufNewFile *.nix setfiletype nix

  " File types that require tabs, not spaces
  autocmd FileType make set noexpandtab

  " Manage whitespace on save, maintaining cursor position
  autocmd FileType vim,ruby,haml,eruby,javascript,coffee,css,scss,lua,handlebars,python,yaml,scala,cpp,dart,crystal,nix
        \ autocmd BufWritePre <buffer> call functions#ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Close when NERDTree is the last open buffer
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

  " auto-add packs
  autocmd FileType dart packadd dart-vim-plugin
  autocmd FileType html,html.eruby,css,haml,eruby,handlebars,liquid,javascript,markdown packadd emmet-vim
  autocmd FileType javascript packadd vim-javascript
  autocmd FileType javascript.jsx packadd vim-jsx-pretty
  autocmd FileType go packadd vim-go
  autocmd FileType nix packadd vim-nix
  autocmd FileType python packadd vim-flake8
augroup END
