if vim.g.did_load_overseer then
	return
end
vim.g.did_load_overseer = true

local overseer = require("overseer")

overseer.setup({
	task_list = {
		direction = "left",
	},
	form = {
		border = "rounded",
	},
	task_win = {
		border = "rounded",
	},
})

overseer.add_template_hook({ name = "cargo doc" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_dispose")
end)

vim.keymap.set("n", "<leader>eo", function()
	overseer.toggle()
end, { desc = "[E]xecute [O]verview" })

vim.keymap.set("n", "<leader>ee", function()
	overseer.run_task()
end, { desc = "[E]xecute in background" })
