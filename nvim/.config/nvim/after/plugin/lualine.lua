local custom_16color = require("lualine.themes.16color")

custom_16color.normal.b.gui = "bold"
custom_16color.inactive.a.bg = "#595959"
custom_16color.inactive.a.fg = "#ffffff"

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = custom_16color,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 3 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 3 } },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { { "tabs", mode = 2, path = 0 } },
		lualine_b = {},
		lualine_c = {},
		lualine_x = { { "filename", path = 2 }, "filesize" },
		lualine_y = {},
		lualine_z = {},
	},
	winbar = {},
	inactive_winbar = {},
	extensions = { "quickfix" },
})
