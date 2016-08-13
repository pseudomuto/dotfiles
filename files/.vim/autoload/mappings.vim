function mappings#setup()
  "" Nop arrow keys
  map <Up> <Nop>
  map <Right> <Nop>
  map <Down> <Nop>
  map <Left> <Nop>

  "" Splits
  nnoremap <C-H> <C-W><C-H>
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>

  "" shortcut to re-source .vimrc
  map :src :source<space>$MYVIMRC

  " line number toggling between relative and absolute
  nmap <leader>l :call functions#ToggleLineNumberMode()<CR>

  " tab completion
  imap <Tab> <C-N>

  "allows you to use . command in visual mode; harmless otherwise
  vnoremap . :normal.<CR>

  " shortcut to use the 'q' macro
  nmap <space> @q

  " CommandT
  nmap <silent> <C-P> :CommandT<CR>

  " NERDTree
  nmap <silent> <C-D> :NERDTreeToggle<CR>
  nmap <leader>t :NERDTreeFind<CR>

  " syntastic
  nmap <leader>sc :SyntasticCheck<CR>

  " replace all hashrocket 1.8 style ruby hashes with 1.9 style
  map :RubyHashConvert :s/\v:([^ ]+)\s*\=\>/\1:/g
  nmap <leader>h :RubyHashConvert<CR>

  " Ack
  nmap <leader>f :Ack<space>

  " <leader>= to call Tab /=
  nmap <leader>= :Tab /=<CR>
  vmap <leader>= :Tab /=<CR>

  " <leader>' replace ' with "
  nmap <leader>' :s/'/"/g<CR>
  vmap <leader>' :s/'/"/g<CR>

  " <leader>" replace " with '
  nmap <leader>" :s/"/'/g<CR>
  vmap <leader>" :s/"/'/g<CR>

  " <leader><leader> to switch to last buffer
  nnoremap <leader><leader> <c-^>
endfunc
