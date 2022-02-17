autocmd BufRead,BufNewFile *.json.erb setfiletype javascript.eruby
autocmd BufRead,BufNewFile *.json,*.ejson,*.ehs,*.es6 setfiletype javascript
autocmd FileType javascript packadd vim-javascript
