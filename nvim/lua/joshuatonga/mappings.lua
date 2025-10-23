-- TODO: check if there's a need to integrate with which-key
vim.keymap.set("n", "<leader>pe", vim.cmd.Ex, { desc = "netrw in current buffer" })
vim.keymap.set("n", "<leader>pv", ":Vex<CR>", { desc = "netrw in vertical split" })
vim.keymap.set("n", "<leader>ph", vim.cmd.Hex, { desc = "netrw in horizontal split" })

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "save file" })

-- vim.keymap.set("i", "<C-e>", "<C-o>de") -- delete word forward in insert mode. C-w to delete backward

vim.keymap.set("n", "<leader>sv", ":source %<CR>", { desc = "source current buffer" })

-- Copy/paste with system clipboard
-- ref: https://github.com/echasnovski/mini.basics/blob/d6b0ee8630adb8b9b42fdd6b6923e9b384419d72/lua/mini/basics.lua#L575-L579
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "x" }, "gp", '"+p', { desc = "Paste from system clipboard" })

-- Ref: https://github.com/ThePrimeagen/init.lua/blob/bc8324fa1c31bd1bc81fb8a5dde684dffd324f84/lua/theprimeagen/remap.lua
vim.keymap.set("n", "<leader><C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>hw", ":help <C-r><C-w><CR>") -- Open help page for the word under cursor
vim.keymap.set("n", "<C-w>+", ":resize +10<CR>")
vim.keymap.set("n", "<C-w>-", ":resize -10<CR>")
vim.keymap.set("n", "<C-w>>", ":vertical resize +10<CR>")
vim.keymap.set("n", "<C-w><", ":vertical resize -10<CR>")

-- Quickfix mappings
vim.keymap.set("n", "<leader>q", ":copen<CR>", { desc = "open quickfix window" })
vim.keymap.set("n", "<leader>Q", ":cclose<CR>", { desc = "close quickfix window" })
vim.keymap.set("n", "<leader>qc", ":cexpr []<CR>", { desc = "clear quickfix list" })
vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "next item in quickfix" })
vim.keymap.set("n", "[q", ":cprev<CR>", { desc = "previous item in quickfix" })
vim.keymap.set("n", "[Q", ":cfirst<CR>", { desc = "first item in quickfix" })
vim.keymap.set("n", "]Q", ":clast<CR>", { desc = "last item in quickfix" })

-- Locationlist mappings
vim.keymap.set("n", "]l", ":lnext<CR>")
vim.keymap.set("n", "[l", ":lprev<CR>")
vim.keymap.set("n", "]L", ":lfirst<CR>")
vim.keymap.set("n", "[L", ":llast<CR>")

-- Stay in visual mode when indenting. Ref: https://github.com/ChristianChiarulli/nvim/blob/master/lua/user/keymaps.lua
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Visual block moving
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
	print("Copied: " .. vim.fn.expand("%:p"))
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>crp", function()
	local abs_path = vim.fn.expand("%:p")
	local rel_path = vim.fn.fnamemodify(abs_path, ":.")
	vim.fn.setreg("+", rel_path)
	print("Copied relative path: " .. rel_path)
end, { desc = "Copy file path relative to cwd" })

vim.keymap.set("n", "<leader>cd", function()
	local dir = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", dir)
	print("Copied dir: " .. dir)
end, { desc = "Copy buffer directory path" })

vim.keymap.set("n", "<leader>crd", function()
	local abs_dir = vim.fn.expand("%:p:h")
	local rel_dir = vim.fn.fnamemodify(abs_dir, ":.")
	vim.fn.setreg("+", rel_dir)
	print("Copied relative dir: " .. rel_dir)
end, { desc = "Copy buffer directory relative to cwd" })
