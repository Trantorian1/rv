vim.keymap.set("n", "o", function()
	require("overseer").open({ dir = "float" })
end)
