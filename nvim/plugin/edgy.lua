if vim.g.did_load_edgy then
	return
end
vim.g.did_load_edgy = true

vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

require("edgy").setup({
	left = {
		{ ft = "dapui_scopes" },
		{ ft = "dapui_breakpoints" },
		{ ft = "dapui_watches" },
		{ ft = "dap-repl" },
	},

	right = {
		{
			ft = "help",
			-- only show help buffers
			filter = function(buf)
				return vim.bo[buf].buftype == "help"
			end,
		},
	},

	bottom = {
		{ ft = "dap_disassembly" },
	},

	options = {
		left = { size = 50 },
		right = { size = 90 },
		bottom = { size = 15 },
	},

	animate = {
		enabled = false,
	},

	-- enable this to exit Neovim when only edgy windows are left
	exit_when_last = true,
	-- close edgy when all windows are hidden instead of opening one of them
	-- disable to always keep at least one edgy split visible in each open section
	close_when_all_hidden = true,
})
