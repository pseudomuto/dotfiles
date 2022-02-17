autocmd FileType html,html.eruby,css,haml,eruby,handlebars,liquid,javascript,markdown packadd emmet-vim

let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = "<C-X>"

" Treat these tags like the block tags they are
let g:html_indent_tags = 'li\|p\|header\|footer\|section\|aside\|nav'
