function autocmd#setup()
  set autoread

  " Filetypes
  au BufRead,BufNewFile *.rb,*.rabl,*.json.jbuilder,Capfile,Vagrantfile setf ruby
  au BufRead,BufNewFile *.htm.erb setf html.eruby
  au BufRead,BufNewFile *.json.erb setf javascript.eruby
  au BufRead,BufNewFile *.json,*.ejson,*.ehs,*.es6 setf javascript
  au BufRead,BufNewFile *.go setf go

  " Emmet file types
  au FileType html,html.eruby,css,haml,eruby,handlebars,liquid EmmetInstall

  " File types that require tabs, not spaces
  au FileType make set noexpandtab

  " Manage whitespace on save, maintaining cursor position
  au FileType vim,ruby,haml,eruby,javascript,coffee,css,scss,lua,handlebars,python,yaml
        \au BufWritePre <buffer> call functions#ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Close when NERDTree is the last open buffer
  au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endfunc
