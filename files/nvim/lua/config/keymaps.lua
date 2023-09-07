-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- undo some lazyvim defaults
vim.keymap.set({ "n", "x" }, "k", "k", { noremap = true })
vim.keymap.set({ "n", "x" }, "j", "j", { noremap = true })
vim.keymap.set({ "i", "n" }, "<esc>", "<esc>", { noremap = true })

-- Navigation
vim.keymap.set({ "n", "i" }, "<up>", "<nop>", { noremap = true, desc = "Disable arrow keys" })
vim.keymap.set({ "n", "i" }, "<down>", "<nop>", { noremap = true, desc = "Disable arrow keys" })
vim.keymap.set({ "n", "i" }, "<left>", "<nop>", { noremap = true, desc = "Disable arrow keys" })
vim.keymap.set({ "n", "i" }, "<right>", "<nop>", { noremap = true, desc = "Disable arrow keys" })
vim.keymap.set({ "n", "v" }, "<S-k>", "10k", { noremap = true, desc = "Up faster" })
vim.keymap.set({ "n", "v" }, "<S-j>", "10j", { noremap = true, desc = "Down faster" })
vim.keymap.set("n", "<leader><leader>", "<C-^>", { noremap = true, desc = "Go to previous buffer" })

-- commands
vim.keymap.set("n", "<leader>'", ":s/'/\"/g", { desc = "Replace single quotes with doubles" })
vim.keymap.set("n", '<leader>"', ":s/\"/'/g", { desc = "Replace double quotes with doubles" })
vim.keymap.set("v", ".", ":normal.<CR>", { noremap = true, desc = "Make . work in visual mode" })
vim.keymap.set("n", "<leader>r", "<leader>cr", { remap = true, desc = "Rename item under cursor" })
vim.keymap.set("n", "s", "xi", { noremap = true, desc = "Remove character and enter insert mode" })
vim.keymap.set("n", "<S-s>", "dd<S-o>", { noremap = true, desc = "Remove current line and enter insert mode" })
vim.keymap.set({ "n", "x" }, "ga", "<Plug>(EasyAlign)", { remap = true, desc = "easy align mapping" })
vim.keymap.set({ "n", "v" }, "<leader>=", "gaip=<CR>", { remap = true, desc = "easy align mapping" })

-- Neotree mappings
vim.keymap.set("n", "<C-d>", "<leader>fE", { remap = true, desc = "Toggle NeoTree" })
