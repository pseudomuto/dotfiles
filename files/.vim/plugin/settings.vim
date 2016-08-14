"" Plugins
let g:vim_markdown_folding_disabled = 1

"" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = "<C-X>"

" CommandT
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*"
let g:CommandTFileScanner="git"

" NERDTree
let g:NERDSpaceDelims=1

" airline
let g:airline_powerline_fonts              = 1
let g:airline_section_z                    = airline#section#create_right(["%l/%L"])
let g:airline#extensions#syntastic#enabled = 1
let g:airline_theme                        = "badwolf"

" syntastic
let g:syntastic_always_populate_loc_list  = 1
let g:syntastic_auto_loc_list             = 1
let g:syntastic_check_on_open             = 0
let g:syntastic_check_on_wq               = 1
let g:syntastic_eruby_ruby_quiet_messages = { "regex": "possibly useless use of a variable in void context" }
let g:syntastic_ruby_checkers             = ["rubocop"]
let g:syntastic_javascript_checkers       = ["jshint", "eslint", "jsxhint"]
let g:syntastic_cucumber_checkers         = []

" localvimrc
let g:localvimrc_ask     = 0
let g:localvimrc_sandbox = 0

" Treat these tags like the block tags they are
let g:html_indent_tags = 'li\|p\|header\|footer\|section\|aside\|nav'

" use ag if available
if executable("ag")
  let g:ackprg = "ag --nogroup --column"
endif

" scala
let g:scala_scaladoc_indent = 1