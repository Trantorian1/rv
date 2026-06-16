if vim.g.did_load_lazygit then
	return
end
vim.g.did_load_lazygit = true

require("lazygit").setup({})
