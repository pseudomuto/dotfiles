-- Add your custom plugins here
return {
	-- required by vim-markdown
	{ "godlygeek/tabular" },
	{ "plasticboy/vim-markdown" },

	-- randos
	{ "roman/golden-ratio" },
	{ "vim-airline/vim-airline-themes" },
	{ "vim-airline/vim-airline" },
	{ "junegunn/vim-easy-align" },
	{ "tpope/vim-surround" },
	{ "towolf/vim-helm" },

	{
		-- Install markdown preview, use npx if available.
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
			else
				vim.cmd([[Lazy load markdown-preview.nvim]])
				vim.fn["mkdp#util#install"]()
			end
		end,
		init = function()
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
		end,
	},

	-- Nix language support
	{
		"LnL7/vim-nix",
		ft = "nix",
	},

	{
		"nvim-web-devicons",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- Override Treesitter to ensure more parsers
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
				-- "lua",
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
				"bash",
				"c",
				"diff",
				"dockerfile",
				"go",
				"hcl",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"rust",
				"terraform",
				"tsx",
				"typescript",
				"vimdoc",
			})
		end,
	},
}
