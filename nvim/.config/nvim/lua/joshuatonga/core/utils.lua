--lua/code_action_utils.lua
local M = {}

local lsp_util = vim.lsp.util

vim.fn.sign_define("TestLightbulb", { text = "💡", texthl = "LspDiagnosticsDefaultInformation" })

function M.code_action_listener()
	local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
	local params = lsp_util.make_range_params()
	params.context = context
	vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, _, result)
		local new_line = result.params.range.start.line
		--  local bufnr = result.bufnr
		local bufnr = vim.api.nvim_get_current_buf()
		vim.fn.sign_place(new_line, "test-lightbulb", "TestLightbulb", bufnr, { lnum = new_line + 1, priority = 40 })
		print(vim.inspect(result))
	end)
end

return M
