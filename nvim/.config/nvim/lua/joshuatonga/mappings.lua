-- use \ default leader key
vim.g.mapleader = "\\"

vim.keymap.set("n", "<Leader>pe", vim.cmd.Ex)
vim.keymap.set("n", "<Leader>pv", ":Vex!<CR>")
vim.keymap.set("n", "<Leader>ph", vim.cmd.Hex)

vim.keymap.set("i", "<C-e>", "<C-o>de") -- delete word forward in insert mode. C-w to delete backward

vim.keymap.set("n", "<Leader>sv", ":source %<CR>")

-- Copy/paste with system clipboard
-- ref: https://github.com/echasnovski/mini.basics/blob/d6b0ee8630adb8b9b42fdd6b6923e9b384419d72/lua/mini/basics.lua#L575-L579
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Paste from system clipboard" })

-- Ref: https://github.com/ThePrimeagen/init.lua/blob/bc8324fa1c31bd1bc81fb8a5dde684dffd324f84/lua/theprimeagen/remap.lua
vim.keymap.set("x", "<Leader>p", '"_dP')
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<Leader>hw", ":help <C-r><C-w><CR>") -- Open help page for the word under cursor
vim.keymap.set("n", "<C-w>+", ":resize +10<CR>")
vim.keymap.set("n", "<C-w>-", ":resize -10<CR>")
vim.keymap.set("n", "<C-w>>", ":vertical resize +10<CR>")
vim.keymap.set("n", "<C-w><", ":vertical resize -10<CR>")

-- Quickfix mappings
vim.keymap.set("n", "<Leader>q", ":copen<CR>")
vim.keymap.set("n", "<Leader>Q", ":cclose<CR>")
vim.keymap.set("n", "<Leader>qc", ":cexpr []<CR>")
vim.keymap.set("n", "]q", ":cnext<CR>")
vim.keymap.set("n", "[q", ":cprev<CR>")
vim.keymap.set("n", "[Q", ":cfirst<CR>")
vim.keymap.set("n", "]Q", ":clast<CR>")

-- Locationlist mappings
vim.keymap.set("n", "]l", ":lnext<CR>")
vim.keymap.set("n", "[l", ":lprev<CR>")
vim.keymap.set("n", "]L", ":lfirst<CR>")
vim.keymap.set("n", "[L", ":llast<CR>")

-- Stay in visual mode when indenting. Ref: https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/keymaps.lua
vim.keymap.set("n", "<", "<gv")
vim.keymap.set("n", ">", ">gv")

-- Visual block moving
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
