augroup default_group
  autocmd!

  " Filetypes
  autocmd BufRead,BufNewFile *.rb,*.rabl,*.json.jbuilder,Capfile,Vagrantfile setfiletype ruby
  autocmd BufRead,BufNewFile *.htm.erb setfiletype html.eruby
  autocmd BufRead,BufNewFile *.json.erb setfiletype javascript.eruby
  autocmd BufRead,BufNewFile *.json,*.ejson,*.ehs,*.es6 setfiletype javascript
  autocmd BufRead,BufNewFile *.go setfiletype go

  " Emmet file types
  autocmd FileType html,html.eruby,css,haml,eruby,handlebars,liquid EmmetInstall

  " File types that require tabs, not spaces
  autocmd FileType make set noexpandtab

  " Manage whitespace on save, maintaining cursor position
  autocmd FileType vim,ruby,haml,eruby,javascript,coffee,css,scss,lua,handlebars,python,yaml
        \ autocmd BufWritePre <buffer> call functions#ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Close when NERDTree is the last open buffer
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END
