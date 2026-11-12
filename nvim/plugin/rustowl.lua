if vim.g.did_load_rustowl then
	return
end
vim.g.did_load_rustowl = true

local rustowl = require("rustowl")

rustowl.setup({
	highlight_style = {
		definitely_live = "underline",
		maybe_initialized = "undercurl",
	},
	client = {
		on_attach = function(_, buffer)
			vim.keymap.set("n", "<leader>rl", function()
				rustowl.toggle(buffer)
			end, { buffer = buffer, desc = "[R]ust [L]ifetimes" })
		end,
	},
})
