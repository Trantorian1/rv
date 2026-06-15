-- First tab: empty (this is already open by default)

-- Second tab: git diff with diffview
if vim.fn.isdirectory(".git") ~= 0 then
	require("diffview").open({})
end

-- Third tab: terminal
vim.cmd("tabnew")
vim.cmd("term")
vim.cmd("set relativenumber nospell")
vim.cmd("file term1")
vim.cmd("vspl")
vim.cmd("term")
vim.cmd("set relativenumber nospell")
vim.cmd("file term2")

-- Go back to first tab
vim.cmd("tabfirst")
