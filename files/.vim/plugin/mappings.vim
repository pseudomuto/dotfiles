"" Nop arrow keys
noremap <up> <nop>
noremap <right> <nop>
noremap <down> <nop>
noremap <left> <nop>
inoremap <up> <nop>
inoremap <right> <nop>
inoremap <down> <nop>
inoremap <left> <nop>

"" Splits
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

"" shortcuts to edit/re-source .vimrc
noremap :vedit :vsplit<space>$MYVIMRC
noremap :src :source<space>$MYVIMRC

" line number toggling between relative and absolute
nnoremap <leader>l :call functions#ToggleLineNumberMode()<cr>

" tab completion
inoremap <tab> <c-n>

"allows you to use . command in visual mode; harmless otherwise
vnoremap . :normal.<cr>

" shortcut to use the 'q' macro
nnoremap <space> @q

" NERDTree
nnoremap <silent> <c-d> :NERDTreeToggle<cr>
nnoremap <leader>t :NERDTreeFind<cr>

" syntastic
nnoremap <leader>sc :SyntasticCheck<cr>

" Ack
nnoremap <leader>f :Ack<space>

" <leader>' replace ' with "
noremap <leader>' :s/'/"/g<cr>

" <leader>" replace " with '
noremap <leader>" :s/"/'/g<cr>

" <leader><leader> to switch to last buffer
nnoremap <leader><leader> <c-^>

" <C-U> capitalizes the current word
nnoremap <c-u> viwUw
inoremap <c-u> <esc>viwUwi

" abbreviations
iabbrev @@ david.muto@gmail.com

" FZF
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <leader>b :call fzf#run({
      \   'source':  reverse(<sid>buflist()),
      \   'sink':    function('<sid>bufopen'),
      \   'options': '+m',
      \   'down':    len(<sid>buflist()) + 2
      \ })<cr>

nnoremap <silent> <c-p> :FZF<cr>

" Easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nmap <leader>= gaip=<cr>
vmap <leader>= gaip=<cr>
