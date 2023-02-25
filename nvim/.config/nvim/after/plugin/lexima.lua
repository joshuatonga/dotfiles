local keymap = require("joshuatonga.core.keymap")
local inoremap = keymap.inoremap

vim.g.lexima_enable_basic_rules = 1

local enable_lexima = function()
	vim.b.lexima_disabled = 0
end

local disable_lexima = function()
	vim.b.lexima_disabled = 1
end

vim.api.nvim_create_user_command("LD", disable_lexima, {})
vim.api.nvim_create_user_command("LE", enable_lexima, {})

inoremap("<C-s>l", function()
	if vim.b.lexima_disabled then
		enable_lexima()
	else
		disable_lexima()
	end
end, {})
