-- Additional configurations from nvim-treesitter. Mostly this is just simple syntax highlighting and folding for some
-- common languages.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
				"cpp",
				"css",
				"gitcommit",
				"graphql",
        "html",
        "javascript",
        "json",
				"kotlin",
        "lua",
				"make",
        "markdown_inline",
				"proto",
        "python",
        "query",
        "regex",
				"scala",
				"sql",
				"toml",
        "vim",
				"xml",
        "yaml",
      })
    end,
  },
}
