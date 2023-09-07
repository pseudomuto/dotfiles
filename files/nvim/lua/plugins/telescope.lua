return {
	{
		"nvim-telescope/telescope.nvim",
		-- install fzf native
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		keys = {
			-- leave my prev buffer command alone
			{ "<leader><leader>", vim.NIL },
			-- change a keymap
			{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
			-- add a keymap to browse plugin files
			{
				"<leader>fp",
				function()
					require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
				end,
				desc = "Find Plugin File",
			},
			-- This is using b because it used to be fzf's :Buffers
			{
				"<leader>b",
				"<cmd>Telescope buffers<cr>",
				desc = "Open buffers",
			},
		},
		-- change some options
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = function(...)
							return require("telescope.actions").move_selection_next(...)
						end,
						["<C-k>"] = function(...)
							return require("telescope.actions").move_selection_previous(...)
						end,
					},
				},
			},
		},
	},
}
