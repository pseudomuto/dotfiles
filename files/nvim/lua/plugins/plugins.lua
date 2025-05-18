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

	-- Workaround for Mason breaking changes
	{ "mason-org/mason.nvim", version = "^1.0.0" },
	{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },

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

	-- extra things
	{ import = "lazyvim.plugins.extras.coding.nvim-cmp" },
	{ import = "lazyvim.plugins.extras.coding.yanky" },
	{ import = "lazyvim.plugins.extras.test.core" },

	-- extra language support
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{ import = "lazyvim.plugins.extras.lang.docker" },
	{ import = "lazyvim.plugins.extras.lang.go" },
	{ import = "lazyvim.plugins.extras.lang.helm" },
	{ import = "lazyvim.plugins.extras.lang.java" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.lang.markdown" },
	{ import = "lazyvim.plugins.extras.lang.toml" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.rust" },
	{ import = "lazyvim.plugins.extras.lang.terraform" },
	{ import = "lazyvim.plugins.extras.lang.toml" },
	{ import = "lazyvim.plugins.extras.lang.yaml" },
}
