-- Additional configurations from nvim-treesitter. Mostly this is just simple syntax highlighting and folding for some
-- common languages.
return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"bash",
				"comment",
				"cpp",
				"css",
				"gitcommit",
				"gotmpl",
				"graphql",
				"groovy",
				"html",
				"javascript",
				"json",
				"kotlin",
				"lua",
				"make",
				"markdown_inline",
				"nix",
				"proto",
				"python",
				"query",
				"regex",
				"scala",
				"sql",
				"templ",
				"toml",
				"vim",
				"xml",
				"yaml",
			})
		end,
	},
}
