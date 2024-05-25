local map = vim.keymap.set

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
	focusable = false,
	relative = "cursor",
	silent = true,
})

local setup_signature = function(client, bufnr)
	local check_triggered_chars = function(triggered_chars)
		local cur_line = vim.api.nvim_get_current_line()
		local pos = vim.api.nvim_win_get_cursor(0)[2]

		cur_line = cur_line:gsub("%s+$", "") -- rm trailing spaces

		for _, char in ipairs(triggered_chars) do
			if cur_line:sub(pos, pos) == char then
				return true
			end
		end

		local group = vim.api.nvim_create_augroup("LspSignature", { clear = false })
		vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }

		local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters

		vim.api.nvim_create_autocmd("TextChangedI", {
			group = group,
			buffer = bufnr,
			callback = function()
				if M.check_triggeredChars(triggerChars) then
					vim.lsp.buf.signature_help()
				end
			end,
		})
	end
end

local on_attach = function(client, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
	map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
	map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts "List workspace folders")

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

	map("n", "<leader>ra", function()
		require "nvchad.lsp.renamer" ()
	end, opts "NvRenamer")

	map("n", "gr", vim.lsp.buf.references, opts "Show references")

	-- setup signature popup
	if client.server_capabilities.signatureHelpProvider then
		setup_signature(client, bufnr)
	end
end

local on_init = function(client, _)
	if client.supports_method "textDocument/semanticTokens" then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

-- disable semanticTokens
-- M.on_init = function(client, _)
--   if client.supports_method "textDocument/semanticTokens" then
--     client.server_capabilities.semanticTokensProvider = nil
--   end
-- end

local lspconfig = require "lspconfig"

local navic = require "nvim-navic"

local util = require "lspconfig/util"

local function mergeTables(dest, src)
	for key, value in pairs(src) do
		if type(value) == "table" and type(dest[key]) == "table" then
			mergeTables(dest[key], value)
		else
			dest[key] = value
		end
	end
end

local servers = {
	['bashls'] = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh" }
	},
	['cssls'] = {
		fileTypes = { "css" }
	},
	['docker_compose_language_service'] = {
		rootDir = util.root_pattern("docker-compose.yaml", "docker-compose.yml"),
		filetypes = { "yaml", "yml" }
	},
	['dockerls'] = {
		filetypes = { "dockerfile" }
	},
	['gopls'] = {
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		rootDir = util.root_pattern("go.work", "go.mod", ".git"),
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				}
			}
		}
	},
	['html'] = {
		filetypes = { "html" }
	},
	['jdtls'] = {
		rootDir = util.root_pattern({ ".gradlew", ".git", "mvnw" }),
		cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/jdtls" },
		filetypes = { "java" }
	},
	['jsonls'] = {
		fileTypes = { "json", "jsonc" },
		settings = {
			json = {
				schemas = {
					{
						fileMatch = { "package.json" },
						url = "https://json.schemastore.org/package.json"
					},
					{
						fileMatch = { "tsconfig*.json" },
						url = "https://json.schemastore.org/tsconfig.json"
					}
				},
			},
		},
	},
	['kotlin_language_server'] = {
		fileTypes = { "kt", "kts" }
	},
	['lua_ls'] = {
		filetypes = { "lua" },
		cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server" },
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {
						'vim',
						'require'
					},
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = {
						[vim.fn.expand "$VIMRUNTIME/lua"] = true,
						[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
						[vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
						vim.api.nvim_get_runtime_file("", true),
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	},
	['rust_analyzer'] = {
		filetypes = { "rust" },
		settings = {
			['rust-analyzer'] = {
				cargo = {
					allFeatures = true,
				}
			}
		},
	},
	['sqls'] = {
		cmd = { "sqls" },
		filetypes = { "sql", "mysql" }
	},
	['tsserver'] = {
		cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/typescript-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
	},
	['yamlls'] = {
		filetypes = { "yaml", "yml" }
	}
}

for lsp, config in pairs(servers) do
	local setup_config = {
		on_init = on_init,
		capabilities = capabilities,

		on_attach = function(client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end

			on_attach(client, bufnr)

			vim.keymap.set(
				{ "n", "v" },
				"<leader>ca",
				"<cmd> Lspsaga code_action <CR>",
				{ buffer = bufnr, desc = "LSP Code action", noremap = true }
			)
		end,
	}

	mergeTables(setup_config, config)

	lspconfig[lsp].setup(setup_config)
end
