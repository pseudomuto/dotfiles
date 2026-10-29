return {
  -- Configure nvim-lspconfig to use system LSPs
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", false },
          },
        },
        buf_ls = {},
        cssls = {},
        dockerls = {},
        eslint = {},
        gopls = {},
        html = {},
        java_language_server = {},
        jsonls = {},
        kcl = {},
        lua_ls = {},
        nil_ls = {}, -- Nix LSP
        pylsp = {},
        rust_analyzer = {},
        terraformls = {},
        tsserver = {},
        yamlls = {},
      },
      setup = {
        -- Prefer system binaries over Mason-installed ones
        ["*"] = function(server, opts)
          -- Check if the LSP is available in PATH first
          local cmd = opts.cmd and opts.cmd[1] or server
          if vim.fn.executable(cmd) == 1 then
            -- Use system binary
            require("lspconfig")[server].setup(opts)
            return true
          end
          -- Fall back to Mason if not found in system
          return false
        end,
      },
    },
  },
}
