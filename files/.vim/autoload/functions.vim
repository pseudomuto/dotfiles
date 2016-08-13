function functions#ClearTrailingWhitespace()
  let g:clearwhitespace = exists('g:clearwhitespace') ? g:clearwhitespace : 1
  if g:clearwhitespace
    let save_cursor = getpos(".")
    :silent! %s/\s\+$//e " clear trailing whitespace at the end of each line
    :silent! %s/\($\n\)\+\%$// " clear trailing newlines

    call setpos('.', save_cursor)
  endif
endfunction

function functions#ToggleLineNumberMode()
  if(&relativenumber == 1)
    set relativenumber!
    set number
  else
    set number!
    set relativenumber
  endif
endfunc

