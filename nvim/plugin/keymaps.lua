-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

if vim.g.load_keymaps then
	return
end
vim.g.load_keymaps = true

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Hover diagnostic" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Scrolling
vim.keymap.set("n", "<S-s>", "<C-e>", { desc = "Scroll down" })
vim.keymap.set("n", "<S-w>", "<C-y>", { desc = "Scroll down" })

-- Spellchecking
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.keymap.set("n", "ss", "z=", { desc = "[S]pell [S]uggestions" })
vim.keymap.set("n", "si", "zg", { desc = "[S]pell [I]gnore" })

-- Set full screen in neovide
local fullscreen = false
vim.g.neovide_fullscreen = fullscreen

vim.keymap.set("n", "<F11>", function()
	fullscreen = not fullscreen
	vim.g.neovide_fullscreen = fullscreen
end, { desc = "Fullsceen" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
