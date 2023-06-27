local keymap = require("joshuatonga.core.keymap")
local nnoremap = keymap.nnoremap

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
						require("telescope.builtin").oldfiles()
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
						require("telescope.builtin").buffers()
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
					["<C-m>"] = "delete_buffer",
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

vim.api.nvim_create_user_command("Tel", "Telescope <args>", { nargs = "*" })
vim.api.nvim_create_user_command("Maps", "Telescope keymaps", {})

nnoremap("<C-p>", ":lua require('telescope.builtin').find_files({ hidden = true, prompt_title = 'Hidden Files' })<CR>")
nnoremap("<C-\\>", ":lua require('telescope.builtin').commands()<CR>")
nnoremap("<leader>fc", ":lua require('telescope.builtin').command_history()<CR>")
-- nnoremap("<leader>fs", ":lua require('telescope.builtin').live_grep()<CR>")
nnoremap("<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
nnoremap("<leader>ff", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
nnoremap("<leader>fb", ":lua require('telescope.builtin').buffers()<CR>")
nnoremap("<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>")
nnoremap("<leader>fm", ":lua require('telescope.builtin').man_pages()<CR>")
nnoremap("<leader>fr", ":lua require('telescope.builtin').oldfiles()<CR>")
nnoremap("<leader>fk", ":lua require('telescope.builtin').keymaps()<CR>")
nnoremap("<leader>fa", ":lua require('telescope.builtin').builtin()<CR>")
nnoremap("<leader>fgs", ":lua require('telescope.builtin').git_status()<CR>")
nnoremap("<leader>fgc", ":lua require('telescope.builtin').git_bcommits()<CR>")
nnoremap("<leader>fy", ":Telescope yaml_schema<CR>")
