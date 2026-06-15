vim.loader.enable()
vim.o.path = vim.o.path .. "**"
vim.g.LanguageClient_loggingLevel = "ERROR"

require("config")
require("colorscheme")
