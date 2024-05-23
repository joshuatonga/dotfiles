return {
	-- Text/Movement
	"tpope/vim-surround", -- CRUD of surrounding pairs makes easy
	"tpope/vim-rhubarb",
	"leafOfTree/vim-matchtag",
	"ntpeters/vim-better-whitespace",

	-- UI
	"nvim-lualine/lualine.nvim",
	"lewis6991/gitsigns.nvim",
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl" },
	"norcalli/nvim-colorizer.lua",
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = ":TSUpdate",
		config = function()
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"dockerfile",
					"json",
					"markdown",
					"regex",
					"yaml",
					"vim",
					"javascript",
					"lua",
					"python",
					"typescript",
					"rust",
					"rust",
					"go",
				},
				-- ignore_install = { "diff" },
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,
				-- Automatically install missing parsers when entering buffer
				auto_install = true,
				highlight = {
					enable = true,
					disable = {},
				},
				indent = {
					enable = true,
					disable = { "python", "yaml" },
				},
				rainbow = {
					enable = false,
					extended_mode = true,
					max_file_lines = nil,
				},
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = false,
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = { query = "@class.outer", desc = "Next class start" },
							--
							-- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
							["]o"] = "@loop.*",
							-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } },
							--
							-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
							-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
							-- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
							["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						goto_next = {
							["]t"] = "@conditional.outer",
						},
						goto_previous = {
							["[t"] = "@conditional.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- vim way: ; goes to the direction you were moving.
			-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

			-- Workaround when using treesitter with folds. See: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
			vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
				group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
				callback = function()
					vim.opt.foldmethod = "expr"
					vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
				end,
			})
		end,
	},
	{ "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },

	-- Tools
	"lambdalisue/suda.vim",
	"folke/which-key.nvim",
	"Einenlum/yaml-revealer",
	"tpope/vim-fugitive",
	"voldikss/vim-floaterm",
	"mtth/scratch.vim",
	{ "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },
	"mhinz/vim-grepper",
	"tpope/vim-dispatch",
	"vim-test/vim-test",
	"skywind3000/asynctasks.vim",
	"skywind3000/asyncrun.vim",
	"vimwiki/vimwiki",
	"phelipetls/jsonpath.nvim",
	"laytan/cloak.nvim",

	-- LSP
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
	},
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-nvim-lsp-document-symbol",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"quangnguyen30192/cmp-nvim-ultisnips",
	"davidsierradz/cmp-conventionalcommits",
	"hrsh7th/nvim-cmp",
	"SirVer/ultisnips",
	"honza/vim-snippets",
	"folke/neodev.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"nvimtools/none-ls.nvim",
	"pearofducks/ansible-vim",
	"jose-elias-alvarez/typescript.nvim",
	"fatih/vim-go",
	{
		"someone-stole-my-name/yaml-companion.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
		end,
	},
	"mrcjkb/rustaceanvim",

	-- Debugging
	"nvim-neotest/nvim-nio",
	"mfussenegger/nvim-dap",
	"jay-babu/mason-nvim-dap.nvim",
	"theHamsta/nvim-dap-virtual-text",
	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
	{ "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
	{
		"microsoft/vscode-js-debug",
		tag = "v1.89.0",
		pin = true,
		lazy = true,
		build = "npm install --legacy-peer-deps && npm run compile",
		-- tag = "v1.74.1",
	},
	"leoluz/nvim-dap-go",

	-- Themes
	"vimoxide/vim-cinnabar",
	"agude/vim-eldar",
	"ellisonleao/gruvbox.nvim",
	"scottmckendry/cyberdream.nvim",

	-- Games
	"joshuatonga/vim-game-snake-god-mode",
}
