local constants = require("overseer.constants")
local STATUS = constants.STATUS

-- Reuse ONE output window per task name, so repeated runs (e.g. `cargo test`)
-- update the same edgy panel instead of stacking new `OverseerOutput` windows.
--
-- Each `:OverseerRun` creates a brand-new task with a brand-new output buffer,
-- so we key on the task name and repoint the remembered window to the new
-- buffer instead of opening a fresh one.
local output_wins = {} -- [task_name] -> winid

-- Returns a valid, previously-registered output window for `key`, or nil.
-- If the stored window was closed (e.g. user dismissed the panel), forget it
-- so the next run opens a fresh one.
local function get_reused_win(key)
	local winid = output_wins[key]
	if winid and vim.api.nvim_win_is_valid(winid) then
		return winid
	end
	output_wins[key] = nil
	return nil
end

---@type overseer.ComponentFileDefinition
return {
	desc = "Open task output, reusing one window per task across runs (avoids edgy panel stacking)",
	params = {
		on_complete = {
			desc = "Open the output when the task completes",
			type = "enum",
			choices = { "always", "never", "success", "failure" },
			default = "always",
		},
		direction = {
			desc = "Where to open the task output the first time",
			type = "enum",
			choices = { "float", "tab", "vertical", "horizontal" },
			default = "vertical",
		},
		focus = {
			desc = "Focus the output window when it is opened",
			type = "boolean",
			default = false,
		},
	},
	constructor = function(params)
		local function open_output(task)
			local bufnr = task:get_bufnr()
			if not bufnr then
				return
			end

			local key = task.name
			local prev_win = vim.api.nvim_get_current_win()
			local winid = get_reused_win(key)

			if not winid then
				-- First time this task has run: open a fresh window and remember it.
				task:open_output(params.direction)
				for _, w in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == bufnr then
						winid = w
						break
					end
				end
				output_wins[key] = winid
			else
				-- Subsequent runs: repoint the existing window to the new buffer.
				-- Fresh buffer => clean output; single window => no edgy stacking.
				vim.api.nvim_win_set_buf(winid, bufnr)

				-- The swapped-in buffer is a brand-new object with no edgy
				-- buffer-local keymaps (q, <c-q>, ]w/[w, resize, ...) and may have
				-- lost the view title. Edgy only attaches these at claim time
				-- (Window.new -> actions.setup), which does not re-run when a
				-- window is reused, so re-run it now for this window. Fully
				-- guarded so this is a no-op if edgy is unavailable or the window
				-- was never an edgy panel.
				local edgy_win = require("edgy").get_win(winid)
				if edgy_win then
					-- Re-attach keymaps to the new buffer (guarded per-buffer).
					require("edgy.actions").setup(edgy_win)

					-- Re-establish the winbar/title and layout/size.
					require("edgy.layout").update()

					-- Edgy normally applies its window options (self.wo) when
					-- it first claims a window (Edgy.Window.new). We reuse the
					-- same Edgy.Window here, so that step is skipped and
					-- window-local options -- notably `spell` (which is
					-- window-local, so it can't be set per-buffer from the
					-- OverseerOutput ftplugin) -- would be lost and revert to
					-- the buffer/global default. Re-apply them now, mirroring
					-- Window.new.
					for opt, val in pairs(edgy_win.wo) do
						if opt ~= "winhighlight" then
							vim.api.nvim_set_option_value(opt, val, { scope = "local", win = winid })
						end
					end
					if edgy_win.fix_winhl then
						edgy_win:fix_winhl()
					end
				end

				local util = require("overseer.util")

				-- A fresh panel gets window-local number=false,
				-- relativenumber=false and signcolumn=no from overseer's
				-- set_term_window_opts (called during open_output). Reuse
				-- skips that, so the panel falls back to the global
				-- number=true and shows line numbers. Re-apply them now so a
				-- reused panel matches a fresh one.
				util.set_term_window_opts(winid)
				util.scroll_to_end(winid)
			end

			if winid then
				vim.api.nvim_set_current_win(params.focus and winid or prev_win)
			end
		end

		return {
			on_complete = function(_self, task, status)
				local trigger = params.on_complete == "always"
					or (params.on_complete == "success" and status == STATUS.SUCCESS)
					or (params.on_complete == "failure" and status == STATUS.FAILURE)
				if trigger then
					open_output(task)
				end
			end,
		}
	end,
}
