return {
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
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}
