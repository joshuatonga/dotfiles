require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

local lsp = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

vim.diagnostic.config({
	float = {
		source = true,
	},
})

vim.keymap.set("n", "<Space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP Mappings",
	callback = function(ev)
		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap = true, silent = true, buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "<Space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set("n", "<Space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set("n", "<Space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set("n", "<Space>D", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
		vim.keymap.set("n", "<Space>f", function()
			vim.lsp.buf.format({ async = true })
		end, bufopts)
	end,
})

local servers = {
	"ansiblels",
	"bashls",
	"cssls",
	"dockerls",
	"emmet_ls",
	"gopls",
	"helm_ls",
	"html",
	"pyright",
	"solargraph",
	"terraformls",
}

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local default_server_setup = {
	flags = lsp_flags,
	capabilities = capabilities,
}

for _, server in pairs(servers) do
	lsp[server].setup(default_server_setup)
end

lsp.lua_ls.setup({
	flags = lsp_flags,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			format = {
				enable = false,
			},
		},
	},
})

lsp.yamlls.setup(require("yaml-companion").setup())

require("typescript").setup({
	disable_commands = false, -- prevent the plugin from creating Vim commands
	debug = false, -- enable debug logging for commands
	go_to_source_definition = {
		fallback = true, -- fall back to standard LSP definition on failure
	},
})

vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr })
		end,
	},
}
