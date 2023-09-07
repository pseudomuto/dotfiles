return {
	"neovim/nvim-lspconfig",
	init = function()
		local keys = require("lazyvim.plugins.lsp.keymaps").get()
		-- unmap hover keymap
		keys[#keys + 1] = { "K", false }
	end,
}
