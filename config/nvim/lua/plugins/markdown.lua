return {
  -- Ensure markdown tooling is installed
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "prettier", "markdownlint-cli2" } },
  },

  -- Lint markdown with markdownlint-cli2 (GFM, line length 120)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = { "markdownlint-cli2" }

      opts.linters = opts.linters or {}
      -- Builtin def is `args = { "-" }` (stdin). Prepend our global config.
      opts.linters["markdownlint-cli2"] = {
        args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml", "-" },
      }
    end,
  },
}
