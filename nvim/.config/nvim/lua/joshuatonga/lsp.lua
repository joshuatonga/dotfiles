require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

local lsp = require("lspconfig")
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local keymap = require("joshuatonga.core.keymap")

local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap

require("lsp_signature").setup({
	hint_enable = false,
	handler_opts = {
		border = "none",
	},
})

nnoremap("<Space>e", vim.diagnostic.open_float)
nnoremap("<Space>q", vim.diagnostic.setloclist)

vim.diagnostic.config({
	float = {
		source = "always",
	},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	nnoremap("gD", vim.lsp.buf.declaration, bufopts)
	nnoremap("gd", vim.lsp.buf.definition, bufopts)
	nnoremap("K", vim.lsp.buf.hover, bufopts)
	nnoremap("gi", vim.lsp.buf.implementation, bufopts)
	nnoremap("<Space>k", vim.lsp.buf.signature_help, bufopts)
	nnoremap("<Space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	nnoremap("<Space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	nnoremap("<Space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	nnoremap("<Space>D", vim.lsp.buf.type_definition, bufopts)
	nnoremap("<Space>rn", vim.lsp.buf.rename, bufopts)
	nnoremap("<Space>ca", vim.lsp.buf.code_action, bufopts)
	nnoremap("gr", vim.lsp.buf.references, bufopts)
	nnoremap("<Space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
	inoremap("<C-g>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = function()
		vim.opt_local.filetype = "terraform"
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

local servers = {
	"gopls",
	"ansiblels",
	"bashls",
	"terraformls",
	"pyright",
	"dockerls",
	"html",
	"cssls",
	"emmet_ls",
	"solargraph",
}

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local default_server_setup = {
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
}

for _, server in pairs(servers) do
	lsp[server].setup(default_server_setup)
end

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = ".env",
	group = vim.api.nvim_create_augroup("__env", { clear = true }),
	callback = function(args)
		vim.diagnostic.disable(args.buf)
	end,
})

lsp.lua_ls.setup({
	on_attach = on_attach,
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

if not configs.helm_ls then
	configs.helm_ls = {
		default_config = {
			cmd = { "helm_ls", "serve" },
			filetypes = { "helm" },
			root_dir = function(fname)
				return util.root_pattern("Chart.yaml")(fname)
			end,
		},
	}
end

lsp.helm_ls.setup({
	filetypes = { "helm" },
	cmd = { "helm_ls", "serve" },
})

lsp.yamlls.setup(require("yaml-companion").setup())

require("typescript").setup({
	disable_commands = false, -- prevent the plugin from creating Vim commands
	debug = false, -- enable debug logging for commands
	go_to_source_definition = {
		fallback = true, -- fall back to standard LSP definition on failure
	},
	server = { -- pass options to lspconfig's setup method
		on_attach = on_attach,
	},
})

local rt = require("rust-tools")
rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Space>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})
