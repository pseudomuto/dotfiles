"" Plugins
let g:vim_markdown_folding_disabled = 1

"" Emmet
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = "<C-X>"

" CommandT
let g:CommandTFileScanner="git"
nmap <silent> <C-P> :CommandT<CR>
" map <leader>t :CommandT<CR>
set wildignore+=*.gif,*.png,*.jpg,*.jpeg,*.bmp,*.tiff,*.psd,*.svg,*.woff,*.eot,*.ttf
set wildignore+=*/.git/*,*/.svn/*,*/log/*,*/vendor/*,*/tmp/*
let g:CommandTWildIgnore=&wildignore . ",**/node_modules/*"
let g:CommandTFileScanner="git"
let g:CommandTMatchWindowAtTop=1
let g:CommandTCancelMap='<Esc>'
let g:CommandTSelectNextMap='<Down>'
let g:CommandTSelectPrevMap=['<C-p>', '<C-k>', '<Esc>OA', '<Up>']
map <leader>r :CommandTFlush<CR>

" FZF
map <leader>t :FZF<CR>
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
      \   'source':  reverse(<sid>buflist()),
      \   'sink':    function('<sid>bufopen'),
      \   'options': '+m',
      \   'down':    len(<sid>buflist()) + 2
      \ })<CR>

" NERDTree
let g:NERDSpaceDelims=1
let g:NERDTreeIgnore=["__pycache__", "\.egg-info"]

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

" You complete me
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_show_diagnostics_ui = 1
" let g:ycm_always_populate_location_list = 1
" let g:ycm_seed_identifiers_with_syntax = 1
" let g:ycm_server_log_level = "debug"
let g:ycm_enable_diagnostic_highlighting = 1

" Integrate YouCompleteMe with vim-multiple-cursors, otherwise
" the numerous Cursor events cause great slowness
" (https://github.com/kristijanhusak/vim-multiple-cursors/issues/4)
function Multiple_cursors_before()
  let s:old_ycm_whitelist = g:ycm_filetype_whitelist
  let g:ycm_filetype_whitelist = {}
endfunction

function Multiple_cursors_after()
  let g:ycm_filetype_whitelist = s:old_ycm_whitelist
endfunction

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
