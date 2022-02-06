{ pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  files = {
    ".config/vim/autocmd.vim" = { source = ../files/vim/autocmd.vim; };
    ".config/vim/functions.vim" = { source = ../files/vim/functions.vim; };
    ".config/vim/mappings.vim" = { source = ../files/vim/mappings.vim; };
    ".config/vim/settings.vim" = { source = ../files/vim/settings.vim; };
  };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # global plugins
        ack-vim
        emmet-vim
        fzf-vim
        golden-ratio
        nerdcommenter
        nerdtree
        null-ls-nvim
        plenary-nvim
        tabular
        vim-airline
        vim-airline-themes
        vim-colors-solarized
        vim-easy-align
        vim-fugitive
        vim-surround

        # optional plugins (:packadd call required)
        { plugin = vim-flake8; optional = true; }
        { plugin = vim-javascript; optional = true; }
        { plugin = vim-jsx-pretty; optional = true; }
        { plugin = vim-nix; optional = true; }

        {
          plugin = dart-vim-plugin;
          optional = true;
          config = ''
            let dart_style_guide = 2
            let dart_format_on_save = 1
          '';
        }

        {
          plugin = vim-go;
          optional = true;
          config = ''
            nnoremap <leader>gc :GoCoverageToggle<cr>
            nnoremap <leader>gt :GoTest<cr>
            nnoremap <leader>gf :GoTestFunc<cr>
            nnoremap <leader>ga :GoAlternate<cr>
          '';
        }
      ];

      extraConfig = ''
        source ${homeDir}/.config/vim/settings.vim
        source ${homeDir}/.config/vim/functions.vim
        source ${homeDir}/.config/vim/autocmd.vim
        source ${homeDir}/.config/vim/mappings.vim

        " Make :GoInstallBinaries work
        let g:go_bin_path = "${homeDir}/bin"

        filetype plugin indent on " load file type plugins + indentation
        syntax enable
      '';
    };
  };
}
