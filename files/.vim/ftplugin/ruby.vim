setlocal autoindent
setlocal fileformat=unix
setlocal formatoptions=croql

setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2

setlocal shiftwidth=2
setlocal textwidth=120

" replace all hashrocket 1.8 style ruby hashes with 1.9 style
noremap <buffer> :RubyHashConvert :s/\v:([^ ]+)\s*\=\>/\1:/g
nmap <buffer> <leader>h :RubyHashConvert<cr>
