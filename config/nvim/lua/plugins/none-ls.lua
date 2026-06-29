return {
  -- none-ls scoped to CODE ACTIONS ONLY.
  --
  -- LazyVim's Go extra already wires up `impl` (interface implementation) and
  -- `gomodifytags` as none-ls code actions, but they stay dormant unless none-ls
  -- is installed. We add it here, but deliberately do NOT register it as a
  -- formatter (unlike `extras.lsp.none-ls`, which sets priority 200 and would
  -- hijack conform.nvim). Formatting stays with conform.nvim, linting with nvim-lint.
  --
  -- Usage: cursor on a struct -> `<leader>ca` -> "Implement interface" (e.g. io.Reader).
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir =
        require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git", "go.mod")

      -- Keep only code-action sources; drop any formatting/diagnostics sources
      -- that the go/docker/terraform extras append to none-ls.
      opts.sources = vim.tbl_filter(function(source)
        return source.method == nls.methods.CODE_ACTION
      end, opts.sources or {})
    end,
  },
}
