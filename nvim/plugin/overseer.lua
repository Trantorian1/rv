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
	keymaps = false,
})

overseer.add_template_hook({ name = "cargo doc" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.remove_component(task_defn, "on_complete_dispose")
end)

overseer.add_template_hook({ name = "cargo run" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.add_component(task_defn, { "my.open_output_if_closed", on_complete = "always", direction = "vertical" })
end)

overseer.add_template_hook({ name = "cargo test" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.add_component(task_defn, { "my.open_output_if_closed", on_complete = "always", direction = "vertical" })
end)

overseer.add_template_hook({ name = "cargo bench" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.add_component(task_defn, { "my.open_output_if_closed", on_complete = "always", direction = "vertical" })
end)

overseer.add_template_hook({ name = "cargo check" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.add_component(task_defn, { "my.open_output_if_closed", on_complete = "always", direction = "vertical" })
end)

overseer.add_template_hook({ name = "cargo clippy" }, function(task_defn, util)
	util.remove_component(task_defn, "on_complete_notify")
	util.add_component(task_defn, { "my.open_output_if_closed", on_complete = "always", direction = "vertical" })
end)

vim.keymap.set("n", "<leader>eo", function()
	overseer.toggle()
end, { desc = "[E]xecute [O]verview" })

vim.keymap.set("n", "<leader>ee", function()
	overseer.run_task({})
end, { desc = "[E]xecute in background" })
