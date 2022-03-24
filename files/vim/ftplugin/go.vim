setlocal noexpandtab tabstop=4 shiftwidth=4

nmap <buffer> <leader>ga :GoAlternate<cr>
nmap <buffer> <leader>gc :GoCoverageToggle<cr>
nmap <buffer> <leader>d :GoDecls<cr>
nmap <buffer> <leader>gf :GoTestFunc<cr>
nmap <buffer> <leader>gr :GoRename<cr>
nmap <buffer> <leader>gt :GoTest<cr>

let b:ale_linters = ['gometalinter', 'golint', 'staticcheck']

let g:go_addtags_transform = 'camelcase'
let g:go_auto_type_info = 1
let g:go_bin_path = $HOME . "/bin"
let g:go_debug_windows = { 'vars': 'rightbelow 60vnew', 'stack': 'rightbelow 10new' }
let g:go_def_mode='gopls'
let g:go_diagnostics_level = 2
let g:go_echo_command_info = 0
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_imports_autosave = 1
let g:go_imports_mode = "goimports"
let g:go_info_mode='gopls'
let g:go_list_type = "quickfix"
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck', 'varcheck']
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_play_open_browser = 0
let g:go_updatetime = 250
