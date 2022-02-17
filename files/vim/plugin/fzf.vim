function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

let g:fzf_preview_window = ['up:70%', 'ctrl-/']

nnoremap <silent> <leader>b :call fzf#run({
      \   'source':  reverse(<sid>buflist()),
      \   'sink':    function('<sid>bufopen'),
      \   'options': '+m',
      \   'down':    len(<sid>buflist()) + 2
      \ })<cr>

nnoremap <silent> <c-p> :FZF<cr>
nnoremap <leader>c :Commits<cr>
nnoremap <leader>bc :BCommits<cr>
nnoremap <leader>f :Rg<space>
