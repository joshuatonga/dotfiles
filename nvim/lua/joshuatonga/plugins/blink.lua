return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"Kaiser-Yang/blink-cmp-avante",
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
					columns = { { "label", "label_description", gap = 1 }, { "kind", "source_name" } },
				},
			},
			documentation = { auto_show = true, auto_show_delay_ms = 150 },
		},

		signature = { enabled = false },

		sources = {
			default = { "avante", "lsp", "path", "snippets", "buffer" },
			providers = {
				avante = {
					module = "blink-cmp-avante",
					name = "Avante",
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
