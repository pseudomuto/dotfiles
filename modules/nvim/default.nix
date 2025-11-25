{
  config,
  lib,
  pkgs,
  enabledModules ? [ ],
  ...
}:

with lib;

let
  cfg = config.dotfiles.nvim;
  isEnabled = elem "nvim" enabledModules;
in
{
  imports = [ ./lazyvim.nix ];
  options.dotfiles.nvim = {
    enable = mkOption {
      type = types.bool;
      default = isEnabled;
      description = "Enable Neovim with custom configuration";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neovim;
      description = "The Neovim package to use";
    };

    viAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vi alias for nvim";
    };

    vimAlias = mkOption {
      type = types.bool;
      default = true;
      description = "Create vim alias for nvim";
    };

    lazyVim = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable LazyVim configuration";
      };

      colorscheme = mkOption {
        type = types.str;
        default = "tokyonight";
        description = "Default colorscheme for LazyVim";
        example = "catppuccin";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional Lua configuration to append";
        example = ''
          vim.opt.relativenumber = true
          vim.opt.wrap = false
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Install neovim and dependencies
    home.packages = with pkgs; [
      cfg.package

      # LazyVim dependencies
      nodejs
      python3

      # Build tools for Treesitter
      gcc
      gnumake
      tree-sitter

      # Language servers
      lua-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      nodePackages.yaml-language-server
      nodePackages.dockerfile-language-server-nodejs
      gopls # Go LSP
      nil # Nix LSP

      # Formatters and linters (that LazyVim might use)
      stylua # Lua formatter
      nodePackages.prettier # Code formatter
      shfmt # Shell formatter
      nixpkgs-fmt # Nix formatter
      black # Python formatter
      isort # Python import sorter

      # Additional tools
      luajitPackages.luarocks
      lazygit # Git UI (if not already installed elsewhere)
      gdu # Disk usage analyzer (used by LazyVim)
      bottom # Process viewer (used by LazyVim)
      terraform-ls # Terraform LSP
    ];

    # Set up shell aliases
    home.shellAliases = mkMerge [
      (mkIf cfg.viAlias { vi = "nvim"; })
      (mkIf cfg.vimAlias { vim = "nvim"; })
    ];

    # Set as default editor
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Fallback minimal config if LazyVim is disabled
    home.file = mkIf (!cfg.lazyVim.enable) {
      ".config/nvim/init.lua".text = ''
        -- Minimal Neovim configuration
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.smartindent = true
        vim.opt.wrap = false
        vim.opt.termguicolors = true
        vim.opt.signcolumn = "yes"
        vim.opt.scrolloff = 8
        vim.opt.sidescrolloff = 8
        vim.opt.cursorline = true
        vim.opt.clipboard = "unnamedplus"

        -- Set leader key
        vim.g.mapleader = ","
        vim.g.maplocalleader = "\\"

        -- Better search
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.incsearch = true

        -- Basic keymaps
        vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
        vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
        vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
        vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
        vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
        vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
      '';
    };
  };
}
