if vim.g.did_load_notify then
	return
end
vim.g.did_load_notify = true

local notify = require("notify")

notify.setup({
	timeout = 2000,
	level = vim.log.levels.ERROR,

	max_width = function()
		if vim.bo.filetype == "TelescopePrompt" then
			local action_state = require("telescope.actions.state")
			local picker = action_state.get_current_picker(vim.api.nvim_get_current_buf())

			return vim.api.nvim_win_get_width(picker.preview_win)
		else
			return math.floor(vim.o.columns / 3)
			-- return 10
		end
	end,

	render = "wrapped-default",
	stages = "static",

	merge_duplicates = true,
})
vim.notify = notify
