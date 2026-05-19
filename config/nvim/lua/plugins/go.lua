return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gci", "goimports", "gofumpt" },
      },
      formatters = {
        gci = {
          -- Define the command and arguments for gci
          command = "gci",
          args = {
            "write",
            "$FILENAME",
            "-s",
            "standard",
            "-s",
            "default",
            "-s",
            "localmodule",
          },
          stdin = false, -- gci works on files
        },
      },
    },
  },
}
