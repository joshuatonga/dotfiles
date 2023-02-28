local keymap = require("joshuatonga.core.keymap")
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap

local opts = { silent = true }

vim.g.floaterm_height = 0.9
vim.g.floaterm_width = 0.9

nnoremap("<Leader>tf", ":FloatermNew<CR>", opts)
nnoremap("<Leader>tt", ":FloatermToggle<CR>", opts)
nnoremap("<Leader>tk", ":FloatermKill<CR>", opts)
nnoremap("<Leader>tn", ":FloatermNext<CR>", opts)
nnoremap("<Leader>tp", ":FloatermPrev<CR>", opts)
tnoremap("<Leader>tf", "<C-\\><C-n>:FloatermNew<CR>", opts)
tnoremap("<Leader>tt", "<C-\\><C-n>:FloatermToggle<CR>", opts)
tnoremap("<Leader>tk", "<C-\\><C-n>:FloatermKill<CR>", opts)
tnoremap("<Leader>tn", "<C-\\><C-n>:FloatermNext<CR>", opts)
tnoremap("<Leader>tp", "<C-\\><C-n>:FloatermPrev<CR>", opts)

vim.api.nvim_create_user_command("LG", "FloatermNew --height=0.9 --width=0.9 lazygit", {})
nnoremap("<Leader>gg", ":LG<CR>")
