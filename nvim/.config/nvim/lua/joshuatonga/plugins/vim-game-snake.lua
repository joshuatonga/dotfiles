return {
	"joshuatonga/vim-game-snake-god-mode",

	keys = {
		{ "<Leader>vgs", ":VimGameSnake<CR>" },
	},

	init = function()
		vim.g.VimSnakeMode = "hard"
	end,
}
