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
			default = true,
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
				local ok, util = pcall(require, "overseer.util")
				if ok and util.scroll_to_end then
					util.scroll_to_end(winid)
				end
			end

			if winid then
				vim.api.nvim_set_current_win(params.focus and winid or prev_win)
			end
		end

		return {
			on_complete = function(_self, task, status)
				local trigger =
					params.on_complete == "always"
					or (params.on_complete == "success" and status == STATUS.SUCCESS)
					or (params.on_complete == "failure" and status == STATUS.FAILURE)
				if trigger then
					open_output(task)
				end
			end,
		}
	end,
}
