if vim.g.did_load_snacks then
	return
end
vim.g.did_load_snacks = true

require("snacks").setup({
	indent = {
		enabled = true,
		animate = {
			enabled = false,
		},
	},

	terminal = {
		win = {
			position = "right",
			width = 0.5,
		},
	},
})

vim.keymap.set("n", "<Leader>tt", function()
	require("snacks").terminal.open()
end, { desc = "open new [T]erminal" })
