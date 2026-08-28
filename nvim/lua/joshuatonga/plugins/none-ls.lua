return {
	"nvimtools/none-ls.nvim",

	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			debug = false,
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,
				-- Python
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.usort,
				-- null_ls.builtins.diagnostics.ruff,
				-- Go
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports_reviser,
				null_ls.builtins.code_actions.gomodifytags,
				-- TypeScript/JavaScript
				-- null_ls.builtins.formatting.prettierd,
				-- shell
				null_ls.builtins.formatting.shfmt,
				-- markdown
				-- null_ls.builtins.diagnostics.write_good,
				-- others
				null_ls.builtins.diagnostics.ansiblelint,
				-- null_ls.builtins.diagnostics.yamllint,
				--
				null_ls.builtins.formatting.terraform_fmt,
			},
		})
	end,
}
