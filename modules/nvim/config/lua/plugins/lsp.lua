return {
	-- Disable Mason auto-installation since we're using Nix-managed LSPs
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {}, -- Don't auto-install anything
		},
	},

	-- Configure nvim-lspconfig to use system LSPs
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				["*"] = {
					keys = {
						{ "K", false },
					},
				},
				-- These LSPs are installed via Nix
				buf_ls = {},
				lua_ls = {},
				nil_ls = {}, -- Nix LSP
				tsserver = {},
				html = {},
				cssls = {},
				jsonls = {},
				eslint = {},
				yamlls = {},
				dockerls = {},
				gopls = {},
				rust_analyzer = {},
				terraformls = {},
			},
			setup = {
				-- Prefer system binaries over Mason-installed ones
				["*"] = function(server, opts)
					-- Check if the LSP is available in PATH first
					local cmd = opts.cmd and opts.cmd[1] or server
					if vim.fn.executable(cmd) == 1 then
						-- Use system binary
						require("lspconfig")[server].setup(opts)
						return true
					end
					-- Fall back to Mason if not found in system
					return false
				end,
			},
		},
	},
}
