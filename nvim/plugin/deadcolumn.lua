if vim.g.did_load_dead_column then
	return
end
vim.g.did_load_dead_column = true

vim.o.colorcolumn = "80,100,120"
require("deadcolumn").setup({})
