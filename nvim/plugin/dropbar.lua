if vim.g.did_load_dropbar then
	return
end
vim.g.did_load_dropbar = true

require("dropbar").setup({})
