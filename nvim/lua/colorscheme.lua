require("catppuccin").setup({
	float = {
		transparent = false,
		solid = false,
	},
	term_colors = true,
	custom_highlights = function(colors)
		return {
			OilGitAdded = { fg = colors.green },
			OilGitModified = { fg = colors.yellow },
			OilGitRenamed = { fg = colors.mauve },
			OilGitUntracked = { fg = colors.blue },
			OilGitIgnored = { fg = colors.overlay0 },
			OilGitDeleted = { fg = colors.red },
			OilGitConflict = { fg = colors.peach },
			OilGitCopied = { fg = colors.mauve },
		}
	end,
	integrations = {
		barbar = true,
		blink_cmp = {
			style = "bordered",
		},
		snacks = {
			enabled = false,
		},
		diffview = true,
		fidget = true,
		flash = true,
		gitsigns = true,
		neotest = true,
		noice = true,
		render_markdown = true,
		which_key = true,
		dap = true,
		dap_ui = true,
		notify = true,
	},
})
vim.cmd.colorscheme("catppuccin-latte")
