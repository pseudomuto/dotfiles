return {
	-- add colorschemes
	{ "altercation/vim-colors-solarized" },
	{ "catppuccin/nvim", priority = 1000 },

	-- Configure LazyVim to load catppuccin
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
}
