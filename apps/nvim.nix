{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file.".config/nvim/autoload/functions.vim".source = ../files/vim/autoload/functions.vim;
    home.file.".config/nvim/plugin/autocmd.vim".source = ../files/vim/plugin/autocmd.vim;
    home.file.".config/nvim/plugin/mappings.vim".source = ../files/vim/plugin/mappings.vim;
    home.file.".config/nvim/plugin/settings.vim".source = ../files/vim/plugin/settings.vim;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # global plugins
        {
          plugin = ack-vim;
          config = ''
            let g:ackprg = "ag --nogroup --column"

            nnoremap <leader>f :Ack<space>
          '';
        }
        {
          plugin = dart-vim-plugin;
          optional = true;
          config = ''
            autocmd FileType dart packadd dart-vim-plugin

            let dart_style_guide = 2
            let dart_format_on_save = 1
          '';
        }
        {
          plugin = emmet-vim;
          config = ''
            autocmd FileType html,html.eruby,css,haml,eruby,handlebars,liquid,javascript,markdown packadd emmet-vim
            let g:user_emmet_install_global = 0
            let g:user_emmet_leader_key     = "<C-X>"

            " Treat these tags like the block tags they are
            let g:html_indent_tags = 'li\|p\|header\|footer\|section\|aside\|nav'
          '';
        }
        {
          plugin = fzf-vim;
          config = ''
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
          '';
        }
        golden-ratio
        nerdcommenter
        {
          plugin = nerdtree;
          config = ''
            " close when NERDTree is the last open buffer
            autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
            let g:NERDSpaceDelims=1
            let g:NERDTreeIgnore=["__pycache__", "\.egg-info", "\.pyc", "bazel-.*$[[dir]]"]

            nnoremap <silent> <c-d> :NERDTreeToggle<cr>
            nnoremap <leader>t :NERDTreeFind<cr>
          '';
        }
        tabular
        {
          plugin = vim-airline;
          config = ''
            let g:airline_powerline_fonts        = 1
            let g:airline_section_z              = airline#section#create_right(["%l/%L"])
            let g:airline#extensions#ale#enabled = 1
            let g:airline_theme                  = "badwolf"
          '';
        }
        vim-airline-themes
        vim-colors-solarized
        {
          plugin = vim-easy-align;
          config = ''
            " Easy align
            xmap ga <Plug>(EasyAlign)
            nmap ga <Plug>(EasyAlign)

            nmap <leader>= gaip=<cr>
            vmap <leader>= gaip=<cr>
          '';
        }
        {
          plugin = vim-flake8;
          optional = true;
          config = ''
            autocmd FileType python packadd vim-flake8
          '';
        }
        vim-fugitive
        {
          plugin = vim-go;
          optional = true;
          config = ''
            autocmd BufRead,BufNewFile *.go setfiletype go
            autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
            autocmd FileType go packadd vim-go
            autocmd FileType go nmap <leader>ga :GoAlternate<cr>
            autocmd FileType go nmap <leader>gc :GoCoverageToggle<cr>
            autocmd FileType go nmap <leader>gf :GoTestFunc<cr>
            autocmd FileType go nmap <leader>gr :GoRename<cr>
            autocmd FileType go nmap <leader>gt :GoTest<cr>

            " Make :GoInstallBinaries work
            let g:go_auto_sameids = 1
            let g:go_auto_type_info = 1
            let g:go_bin_path = "${homeDir}/bin"
            let g:go_debug_windows = { 'vars': 'rightbelow 60vnew', 'stack': 'rightbelow 10new' }
            let g:go_fmt_command = "goimports"
            let g:go_metalinter_autosave = 1
            let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck']
            let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
            let g:go_play_open_browser = 0
          '';
        }
        {
          plugin = vim-javascript;
          optional = true;
          config = ''
            autocmd BufRead,BufNewFile *.json.erb setfiletype javascript.eruby
            autocmd BufRead,BufNewFile *.json,*.ejson,*.ehs,*.es6 setfiletype javascript
            autocmd FileType javascript packadd vim-javascript
          '';
        }
        {
          plugin = vim-jsx-pretty;
          optional = true;
          config = ''
            autocmd BufRead,BufNewFile *.jsx setfiletype javascript.jsx
            autocmd FileType javascript.jsx packadd vim-jsx-pretty
          '';
        }
        {
          plugin = vim-nix;
          optional = true;
          config = ''
            autocmd BufRead,BufNewFile *.nix setfiletype nix
            autocmd FileType nix packadd vim-nix
          '';
        }
        vim-surround
      ];

      extraConfig = ''
        " make files should always leave tabs
        autocmd FileType make set noexpandtab

        filetype plugin indent on
        syntax enable
      '';
    };
  };
}
