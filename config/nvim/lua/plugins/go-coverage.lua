return {
  -- Line coverage for Go, surgical replacement for vim-go's `:GoCoverage`.
  -- Renders covered/uncovered/partial markers in the sign column (not full-line
  -- highlight like vim-go). Does nothing to gopls/conform/nvim-lint, so there's
  -- no conflict with LazyVim's Go extra.
  --
  -- Workflow: `<leader>cv` runs `go test` with a coverprofile and shows the signs.
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    opts = {
      auto_reload = true,
      lang = {
        go = {
          coverage_file = "coverage.out",
        },
      },
    },
    keys = {
      {
        "<leader>cv",
        function()
          vim.notify("go test: generating coverage...", vim.log.levels.INFO)
          vim.fn.jobstart({ "go", "test", "./...", "-coverprofile=coverage.out" }, {
            cwd = vim.fn.getcwd(),
            on_exit = function(_, code)
              vim.schedule(function()
                -- Tests may fail (code ~= 0) but still emit a usable profile,
                -- so load whenever the file exists; just warn on failures.
                if vim.uv.fs_stat(vim.fn.getcwd() .. "/coverage.out") then
                  require("coverage").load(true)
                end
                if code ~= 0 then
                  vim.notify("go test exited " .. code .. " (coverage may be partial)", vim.log.levels.WARN)
                else
                  vim.notify("coverage loaded", vim.log.levels.INFO)
                end
              end)
            end,
          })
        end,
        desc = "Go coverage (test + show)",
        ft = "go",
      },
      { "<leader>cV", "<cmd>CoverageToggle<cr>", desc = "Toggle coverage signs", ft = "go" },
      { "<leader>cu", "<cmd>CoverageSummary<cr>", desc = "Coverage summary", ft = "go" },
    },
  },
}
