{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.dotfiles.nvim.lazyVim;
  nvimConfigDir = ./config;
in
{
  # LazyVim configuration files
  config = mkIf cfg.enable {
    # Copy all config files to ~/.config/nvim
    home.file = {
      # Main init.lua
      ".config/nvim/init.lua".source = "${nvimConfigDir}/init.lua";

      # Config files
      ".config/nvim/lua/config/lazy.lua".source = "${nvimConfigDir}/lua/config/lazy.lua";
      ".config/nvim/lua/config/options.lua".source = "${nvimConfigDir}/lua/config/options.lua";
      ".config/nvim/lua/config/keymaps.lua".source = "${nvimConfigDir}/lua/config/keymaps.lua";
      ".config/nvim/lua/config/autocmds.lua".source = "${nvimConfigDir}/lua/config/autocmds.lua";

      # Plugin files
      ".config/nvim/lua/plugins/colorscheme.lua".source = "${nvimConfigDir}/lua/plugins/colorscheme.lua";
      ".config/nvim/lua/plugins/lsp.lua".source = "${nvimConfigDir}/lua/plugins/lsp.lua";
      ".config/nvim/lua/plugins/user.lua".source = "${nvimConfigDir}/lua/plugins/user.lua";

      # Stylua config for formatting
      ".config/nvim/.stylua.toml".text = ''
        indent_type = "Spaces"
        indent_width = 2
        column_width = 120
        quote_style = "AutoPreferDouble"
        call_parentheses = "Always"
      '';

      # .luarc.json for Lua LSP
      ".config/nvim/.luarc.json".text = builtins.toJSON {
        diagnostics.globals = [ "vim" ];
        runtime.version = "LuaJIT";
        workspace = {
          checkThirdParty = false;
          library = [
            "$VIMRUNTIME"
            "\${3rd}/luv/library"
          ];
        };
      };
    };
  };
}
