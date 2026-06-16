if vim.g.did_load_dap then
	return
end
vim.g.did_load_dap = true

local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
	controls = {
		-- Disables clickable icons
		enabled = false,
	},
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.5,
				},
				{
					id = "watches",
					size = 0.5,
				},
			},
			position = "left",
			-- This is set by Edgy anyway
			size = 10,
		},
		{
			elements = {
				{
					id = "repl",
					size = 1,
				},
			},
			position = "bottom",
			-- This is set by Edgy anyway
			size = 10,
		},
	},
})

require("nvim-dap-virtual-text").setup({})

-- Change breakpoint icons
local breakpoint_icons = {
	Breakpoint = "",
	BreakpointCondition = "",
	BreakpointRejected = "",
	LogPoint = "",
	Stopped = "",
}
for type, icon in pairs(breakpoint_icons) do
	local tp = "Dap" .. type
	local hl = tp
	vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

-- Automatically open and close dapui
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- keybinds
vim.keymap.set("n", "<F1>", function()
	dap.step_into()
end, { desc = "Debugger: step into" })

vim.keymap.set("n", "<F2>", function()
	dap.step_over()
end, { desc = "Debugger: step over" })

vim.keymap.set("n", "<F3>", function()
	dap.step_out()
end, { desc = "Debugger: step out" })

vim.keymap.set("n", "<F4>", function()
	dap.continue()
end, { desc = "Debugger: continue" })

vim.keymap.set("n", "<F5>", function()
	vim.cmd.RustLsp("debug")
end, { desc = "Debugger: start session" })

vim.keymap.set("n", "<F6>", function()
	dap.disconnect()
	dap.close()
	dapui.close()
end, { desc = "Debugger: end session" })

vim.keymap.set("n", "<leader>b", function()
	dap.toggle_breakpoint()
end, { desc = "Debugger: toggle breakpoint" })

vim.keymap.set("n", "<leader>dui", function()
	dapui.toggle()
end, { desc = "Debugger: toggle ui" })

vim.keymap.set("n", "<leader>dw", function()
	local snacks = require("snacks")

	-- Gets the height of the current window
	local win_height = vim.api.nvim_win_get_height(0)
	local center = win_height / 2 - 1

	-- Opens a prompt for the user to enter a watch expression
	local opts = {
		icon = "󰈈",
		prompt = "watch expression",
		win = { style = "input", position = "float", row = center },
	}
	local on_confirm = function(input)
		dapui.elements.watches.add(input)
	end

	snacks.input(opts, on_confirm)
end, { desc = "Debugger: watch expression" })
