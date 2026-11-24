-- ~/.config/nvim/lua/plugins/tiltfile.lua
return {
  -- Install the Starlark parser for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "starlark" },
    },
  },

  -- Enable Tilt's built-in language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tilt_ls = {
          mason = false,
        },
      },
    },
  },
}
