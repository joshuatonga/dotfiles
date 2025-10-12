-- <C-w>d to open diagnostic float
vim.diagnostic.config({
	virtual_text = true,
	float = {
		border = "single",
		source = true,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP Mappings",
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client.server_capabilities.inlayHintProvider then
			vim.g.inlay_hints_visible = true
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		local add_desc = function(opts, desc)
			return vim.tbl_deep_extend("force", opts, { desc = desc })
		end

		vim.keymap.set("n", "<Space>q", vim.diagnostic.setqflist, { desc = "send diagnostics to quickfix" })

		-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, add_desc(bufopts, "go to declaration"))
		-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, add_desc(bufopts, "go to definition"))
		-- vim.keymap.set("n", "gI", vim.lsp.buf.implementation, add_desc(bufopts, "go to implementation"))
		-- vim.keymap.set("n", "<Space>D", vim.lsp.buf.type_definition, add_desc(bufopts, "go to type definition")) - grt default
		-- vim.keymap.set("n", "gr", vim.lsp.buf.references, add_desc(bufopts, "find references"))
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, add_desc(bufopts, "show signature"))
		vim.keymap.set("n", "<Space>wa", vim.lsp.buf.add_workspace_folder, add_desc(bufopts, "add workspace folder"))
		vim.keymap.set(
			"n",
			"<Space>wr",
			vim.lsp.buf.remove_workspace_folder,
			add_desc(bufopts, "remove workspace folder")
		)
		vim.keymap.set("n", "<Space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, add_desc(bufopts, "list workspace folders"))
		vim.keymap.set("n", "<Space>rn", vim.lsp.buf.rename, add_desc(bufopts, "rename word"))
		vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action, add_desc(bufopts, "view code actions"))
		vim.keymap.set("n", "<Space>f", function()
			vim.lsp.buf.format({ async = true })
		end, add_desc(bufopts, "format"))
	end,
})

local servers = {
	ansiblels = {},
	bashls = {},
	cssls = {
		settings = { css = { lint = { unknownAtRules = "ignore" } } },
	},
	dockerls = {},
	gopls = {},
	helm_ls = {},
	html = {},
	pyright = {},
	solargraph = {},
	terraformls = {},
	astro = {},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {
		settings = {
			yaml = {
				format = {
					enable = false,
				},
				validate = true,
				hover = true,
				completion = true,
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	},

	lua_ls = {
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
	},
}

for server, config in pairs(servers) do
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end

vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "<leader>ca", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr })
		end,
	},
}
