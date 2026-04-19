return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},

		version = "*",
		opts = {
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
					},
				},
				documentation = { auto_show = true, auto_show_delay_ms = 150 },
			},

			signature = { enabled = true },

			sources = {
				default = { "fuzzy-path", "lsp", "path", "snippets", "buffer" },
				providers = {
					["fuzzy-path"] = {
						name = "Fuzzy Path",
						module = "blink-cmp-fuzzy-path",
						score_offset = 0,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},

	{
		"newtoallofthis123/blink-cmp-fuzzy-path",
		dependencies = { "saghen/blink.cmp" },
		opts = {
			filetypes = { "markdown", "json" },
			trigger_char = "@",
			max_results = 5,
		},
	},
}
