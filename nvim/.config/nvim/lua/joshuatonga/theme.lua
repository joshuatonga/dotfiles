-- vim.g.tokyonight_style = "night"
-- vim.cmd("colorscheme tokyonight")
-- vim.o.background = "light"
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme github_light")

-- Black background
-- vim.cmd("colorscheme eldar")
-- vim.cmd("colorscheme default")
vim.cmd("colorscheme industry")
-- vim.cmd("colorscheme cinnabar")

-- Example config in Lua
-- require("github-theme").setup({
--   theme_style = "light",
--   function_style = "italic",
--   dark_float = true,
--   sidebars = { "qf", "vista_kind", "terminal", "packer" },
--
--   -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--   colors = { hint = "orange", error = "#ff0000" },
-- })

vim.cmd("highlight Folded guibg=green guifg=white")
vim.cmd("highlight CursorLine guibg=#212121")
