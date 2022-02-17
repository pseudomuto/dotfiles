" close when NERDTree is the last open buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let g:NERDSpaceDelims=1
let g:NERDTreeIgnore=["__pycache__", "\.egg-info", "\.pyc", "bazel-.*$[[dir]]"]

nnoremap <silent> <c-d> :NERDTreeToggle<cr>
nnoremap <leader>t :NERDTreeFind<cr>
