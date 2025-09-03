-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Trim trailing whitespace on save
-- Exclude certain filetypes where trailing whitespace might be significant
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("trim_whitespace"),
	pattern = "*",
	callback = function()
		-- Filetypes to exclude from trimming
		local exclude_filetypes = {
			"markdown", -- Markdown uses two spaces for line breaks
			"diff", -- Diff files should preserve exact formatting
			"gitcommit", -- Git commit messages might have intentional formatting
			"patch", -- Patch files need exact formatting
			"mail", -- Email messages might have signatures with whitespace
		}

		-- Binary file patterns to exclude
		local exclude_patterns = {
			"%.png$",
			"%.jpg$",
			"%.jpeg$",
			"%.gif$",
			"%.pdf$",
			"%.zip$",
			"%.tar$",
			"%.gz$",
			"%.bz2$",
			"%.7z$",
			"%.exe$",
			"%.dll$",
			"%.so$",
			"%.dylib$",
		}

		local filetype = vim.bo.filetype
		local filename = vim.fn.expand("%:t")

		-- Check if filetype should be excluded
		if vim.tbl_contains(exclude_filetypes, filetype) then
			return
		end

		-- Check if filename matches any excluded pattern
		for _, pattern in ipairs(exclude_patterns) do
			if filename:match(pattern) then
				return
			end
		end

		-- Save cursor position
		local cursor = vim.api.nvim_win_get_cursor(0)

		-- Trim trailing whitespace from each line
		vim.cmd([[%s/\s\+$//e]])

		-- Remove trailing blank lines at end of file while keeping final newline
		-- This ensures the file ends with exactly one newline
		vim.cmd([[silent! %s/\($\n\s*\)\+\%$//e]])

		-- Ensure file ends with a newline (POSIX compliance)
		if vim.fn.getline("$") ~= "" then
			vim.cmd([[silent! $put _]])
			vim.cmd([[silent! $delete _]])
		end

		-- Restore cursor position
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
})
