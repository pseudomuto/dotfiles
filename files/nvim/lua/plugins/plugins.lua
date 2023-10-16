return {
	-- extra things
	{ import = "lazyvim.plugins.extras.coding.yanky" },
	{ import = "lazyvim.plugins.extras.test.core" },

	-- extra language support
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{ import = "lazyvim.plugins.extras.lang.docker" },
	{ import = "lazyvim.plugins.extras.lang.java" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.go" },
	{ import = "lazyvim.plugins.extras.lang.rust" },
	{ import = "lazyvim.plugins.extras.lang.terraform" },
	{ "towolf/vim-helm" },

	-- required by vim-markdown
	{ "godlygeek/tabular" },
	{ "plasticboy/vim-markdown" },

	-- randos
	{ "roman/golden-ratio" },
	{ "vim-airline/vim-airline-themes" },
	{ "vim-airline/vim-airline" },
	{ "junegunn/vim-easy-align" },
}
