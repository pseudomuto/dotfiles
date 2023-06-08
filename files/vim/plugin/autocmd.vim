augroup default_group
  autocmd!

  " Filetypes
  autocmd BufRead,BufNewFile *.rb,*.rabl,*.json.jbuilder,Capfile,Vagrantfile setfiletype ruby
  autocmd BufRead,BufNewFile *.htm.erb setfiletype html.eruby

  " Manage whitespace on save, maintaining cursor position
  autocmd FileType vim,ruby,haml,eruby,javascript,coffee,css,scss,lua,handlebars,python,yaml,scala,cpp,dart,crystal,nix,rust
        \ autocmd BufWritePre <buffer> call functions#ClearTrailingWhitespace()

  " Remember last location in file, but not for commit messages. (see :help last-position-jump)
  autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
