{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config = {
    home.file.".config/nvim/autoload/functions.vim".source = ../files/vim/autoload/functions.vim;
    home.file.".config/nvim/ftdetect/emmet.vim".source = ../files/vim/ftdetect/emmet.vim;
    home.file.".config/nvim/ftdetect/go.vim".source = ../files/vim/ftdetect/go.vim;
    home.file.".config/nvim/ftdetect/javascript.vim".source = ../files/vim/ftdetect/javascript.vim;
    home.file.".config/nvim/ftdetect/jsx.vim".source = ../files/vim/ftdetect/jsx.vim;
    home.file.".config/nvim/ftdetect/nix.vim".source = ../files/vim/ftdetect/nix.vim;
    home.file.".config/nvim/ftdetect/python.vim".source = ../files/vim/ftdetect/python.vim;
    home.file.".config/nvim/ftplugin/go.vim".source = ../files/vim/ftplugin/go.vim;
    home.file.".config/nvim/plugin/_settings.vim".source = ../files/vim/plugin/_settings.vim;
    home.file.".config/nvim/plugin/ale.vim".source = ../files/vim/plugin/ale.vim;
    home.file.".config/nvim/plugin/airline.vim".source = ../files/vim/plugin/airline.vim;
    home.file.".config/nvim/plugin/autocmd.vim".source = ../files/vim/plugin/autocmd.vim;
    home.file.".config/nvim/plugin/easy-align.vim".source = ../files/vim/plugin/easy-align.vim;
    home.file.".config/nvim/plugin/fzf.vim".source = ../files/vim/plugin/fzf.vim;
    home.file.".config/nvim/plugin/mappings.vim".source = ../files/vim/plugin/mappings.vim;
    home.file.".config/nvim/plugin/nerdtree.vim".source = ../files/vim/plugin/nerdtree.vim;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        ale
        emmet-vim
        fzf-vim
        golden-ratio
        nerdcommenter
        nerdtree
        tabular
        vim-airline
        vim-airline-themes
        vim-colors-solarized
        vim-easy-align
        { plugin = vim-flake8; optional = true; }
        vim-fugitive
        { plugin = vim-go; optional = true; }
        { plugin = vim-javascript; optional = true; }
        { plugin = vim-jsx-pretty; optional = true; }
        { plugin = vim-nix; optional = true; }
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
