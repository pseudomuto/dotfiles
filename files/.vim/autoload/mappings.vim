function mappings#setup()
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

  " CommandT
  nnoremap <silent> <c-p> :CommandT<cr>

  " NERDTree
  nnoremap <silent> <c-d> :NERDTreeToggle<cr>
  nnoremap <leader>t :NERDTreeFind<cr>

  " syntastic
  nnoremap <leader>sc :SyntasticCheck<cr>

  " replace all hashrocket 1.8 style ruby hashes with 1.9 style
  noremap :RubyHashConvert :s/\v:([^ ]+)\s*\=\>/\1:/g
  nnoremap <leader>h :RubyHashConvert<cr>

  " Ack
  nnoremap <leader>f :Ack<space>

  " <leader>= to call Tab /=
  nnoremap <leader>= :Tab /=<cr>
  vnoremap <leader>= :Tab /=<cr>

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
endfunc
