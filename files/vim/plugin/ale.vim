let g:ale_set_loclist          = 0 " disable loc list
let g:ale_set_quickfix         = 1 " use quickfix list instead
let g:ale_lint_on_enter        = 0 " don't lint when opening a file
let g:ale_lint_on_save         = 1 " lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save          = 0 " don't correct on save
let g:ale_sign_column_always   = 1 " leave the column open all the time

" go
let g:ale_go_gometalinter_options = ['--fast']

" python
let g:ale_python_auto_poetry = 1
let g:ale_python_flake8_auto_poetry = 1
