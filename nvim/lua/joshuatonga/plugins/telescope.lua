return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{
			"someone-stole-my-name/yaml-companion.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
		},
	},

	cmd = {
		"Tel",
		"Maps",
		"Telescope",
	},

	keys = {
		{
			"<C-p>",
			":lua require('telescope.builtin').find_files({ hidden = true, prompt_title = 'Hidden Files' })<CR>",
		},
		{ "<C-\\>", ":lua require('telescope.builtin').commands()<CR>" },
		{ "<leader>fc", ":lua require('telescope.builtin').command_history()<CR>", desc = "command history" },
		{ "<leader>fs", ":lua require('telescope.builtin').live_grep()<CR>", desc = "find in files (grep)" },
		{ "<leader>ff", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", desc = "find in buffer" },
		{ "<leader>fb", ":lua require('telescope.builtin').buffers()<CR>", desc = "buffers" },
		{ "<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>", desc = "help tags" },
		{ "<leader>fm", ":lua require('telescope.builtin').man_pages()<CR>", desc = "man pages" },
		{ "<leader>fr", ":lua require('telescope.builtin').oldfiles()<CR>", desc = "old files" },
		{ "<leader>fk", ":lua require('telescope.builtin').keymaps()<CR>", desc = "key maps" },
		{ "<leader>fa", ":lua require('telescope.builtin').builtin()<CR>", desc = "built-in commands" },
		{ "<leader>fgs", ":lua require('telescope.builtin').git_status()<CR>", desc = "status" },
		{ "<leader>fgc", ":lua require('telescope.builtin').git_bcommits()<CR>", desc = "commits in buffer" },
		{ "<leader>fy", ":Telescope yaml_schema<CR>", desc = "select yaml schema" },
	},

	config = function()
		local actions = require("telescope.actions")
		local actions_layout = require("telescope.actions.layout")
		local lga_actions = require("telescope-live-grep-args.actions")

		require("telescope").setup({
			defaults = {
				mappings = {
					n = {
						["q"] = actions.close,
						["<C-\\>"] = actions_layout.toggle_preview,
					},

					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-\\>"] = actions_layout.toggle_preview,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
			},
			pickers = {
				find_files = {
					mappings = {
						i = {
							["<C-f>"] = function()
								require("telescope.builtin").buffers()
							end,
							["<C-h>"] = function()
								require("telescope.builtin").find_files()
							end,
							["<C-r>"] = function()
								require("telescope.builtin").git_status()
							end,
						},
					},
				},
				oldfiles = {
					mappings = {
						i = {
							["<C-f>"] = function()
								require("telescope.builtin").oldfiles()
							end,
						},
					},
				},
				buffers = {
					show_all_buffers = true,
					sort_mru = true,
					mappings = {
						i = {
							["<C-f>"] = function()
								require("telescope.builtin").find_files({ hidden = true, prompt_title = "Hidden Files" })
							end,
							["<C-]>"] = "delete_buffer",
						},
					},
				},
				git_status = {
					mappings = {
						i = {
							["<C-f>"] = function()
								require("telescope.builtin").find_files()
							end,
						},
					},
				},
			},
			extensions = {
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					mappings = { -- extend mappings
						i = {
							["<C-]>"] = lga_actions.quote_prompt(),
						},
					},
					-- ... also accepts theme settings, for example:
					-- theme = "dropdown", -- use dropdown theme
					-- theme = { }, -- use own theme spec
					-- layout_config = { mirror=true }, -- mirror preview pane
				},
			},
		})

		require("telescope").load_extension("fzf")
		require("telescope").load_extension("live_grep_args")
		require("telescope").load_extension("yaml_schema")

		vim.api.nvim_create_user_command("Tel", "Telescope <args>", { nargs = "*" })
		vim.api.nvim_create_user_command("Maps", "Telescope keymaps", {})
	end,
}
