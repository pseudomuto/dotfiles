{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
in
{
  config.nixpkgs.overlays = [
    (self: super: {
      golangci-lint = super.golangci-lint.override ({
        # Override https://github.com/NixOS/nixpkgs/pull/166801 which changed this
        # to buildGo118Module because it does not build on Darwin.
        buildGoModule = super.buildGoModule;
      });
    })
  ];

  config = {
    home.file.".config/nvim/lua/config/keymaps.lua".source = ../files/nvim/lua/config/keymaps.lua;
    home.file.".config/nvim/lua/config/lazy.lua".source = ../files/nvim/lua/config/lazy.lua;
    home.file.".config/nvim/lua/config/options.lua".source = ../files/nvim/lua/config/options.lua;
    home.file.".config/nvim/lua/plugins/colorscheme.lua".source = ../files/nvim/lua/plugins/colorscheme.lua;
    home.file.".config/nvim/lua/plugins/nvimcmp.lua".source = ../files/nvim/lua/plugins/nvimcmp.lua;
    home.file.".config/nvim/lua/plugins/nvimlspconfig.lua".source = ../files/nvim/lua/plugins/nvimlspconfig.lua;
    home.file.".config/nvim/lua/plugins/plugins.lua".source = ../files/nvim/lua/plugins/plugins.lua;
    home.file.".config/nvim/lua/plugins/telescope.lua".source = ../files/nvim/lua/plugins/telescope.lua;
    home.file.".config/nvim/lua/plugins/treesitter.lua".source = ../files/nvim/lua/plugins/treesitter.lua;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        LazyVim
      ];

      extraLuaConfig = ''
        -- bootstrap lazy.nvim, LazyVim and your plugins
        require("config.lazy");
      '';
    };
  };
}
