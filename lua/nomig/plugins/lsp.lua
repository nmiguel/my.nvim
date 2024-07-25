return {
	{
		"neovim/nvim-lspconfig",
		-- ft = {
		--     "python",
		--     "lua",
		--     "cs",
		--     "yaml"
		-- },

		event = "BufEnter",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Autocompletion
			"L3MON4D3/LuaSnip",
			"nvim-telescope/telescope.nvim",
			"Hoffs/omnisharp-extended-lsp.nvim",
			{
				"iabdelkareem/csharp.nvim",
				dependencies = {
					"williamboman/mason.nvim",
					"Tastyep/structlog.nvim",
				},
				config = function()
					require("csharp").setup()
				end,
			},
			{
				{
					"folke/lazydev.nvim",
					ft = "lua", -- only load on lua files
					opts = {
						library = {
							-- See the configuration section for more details
							-- Load luvit types when the `vim.uv` word is found
							{ path = "luvit-meta/library", words = { "vim%.uv" } },
						},
					},
				},
				{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
				{ -- optional completion source for require statements and module annotations
					"hrsh7th/nvim-cmp",
					opts = function(_, opts)
						opts.sources = opts.sources or {}
						table.insert(opts.sources, {
							name = "lazydev",
							group_index = 0, -- set group index to 0 to skip loading LuaLS completions
						})
					end,
				},
				-- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
			},
		},

		config = function()
			vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

			vim.diagnostic.config({
				virtual_text = {
					prefix = "",
				},
			})

			-- vim.lsp.inlay_hint.enable()

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf, noremap = true }

					vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
					vim.keymap.set("n", "gt", require("telescope.builtin").lsp_type_definitions, opts)
					vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts)
					-- Uses a different plugin
					-- vim.keymap.set("n", "<leader>va", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>vr", require("telescope.builtin").lsp_references, opts)
					-- vim.keymap.set("n", "<leader>vr", vim.lsp.buf., opts)
					vim.keymap.set("n", "<leader>vn", vim.lsp.buf.rename, opts)
					vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, opts)
					vim.keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
				end,
			})

			local _border = "single"
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = _border,
			})
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = _border,
			})

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = { "pyright", "gopls", "yamlls", "jsonls", "zls" },
				handlers = {
					function(server_name) -- default handler (optional)
						require("lspconfig")[server_name].setup({})
					end,
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							on_init = function(client)
								local path = client.workspace_folders[1].name
								if
									vim.loop.fs_stat(path .. "/.luarc.json")
									or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								then
									return
								end

								client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
									runtime = {
										-- Tell the language server which version of Lua you're using
										-- (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
									},
									-- Make the server aware of Neovim runtime files
									workspace = {
										checkThirdParty = false,
										library = {
											vim.env.VIMRUNTIME,
											-- Depending on the usage, you might want to add additional paths here.
											-- "${3rd}/luv/library"
											-- "${3rd}/busted/library",
										},
										-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
										-- library = vim.api.nvim_get_runtime_file("", true)
									},
								})
							end,
							settings = {
								Lua = {
									runtime = { version = "LuaJIT" },
									diagnostics = {
										globals = { "vim", "require" },
									},
									workspace = {
										-- Make the server aware of Neovim runtime files
										library = vim.api.nvim_get_runtime_file("", true),
									},
									-- Do not send telemetry data containing a randomized but unique identifier
									telemetry = {
										enable = false,
									},
								},
							},
						})
					end,
					["pyright"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.pyright.setup({
							settings = {
								python = {
									analysis = {
										autoSearchPaths = true,
										diagnosticMode = "openFilesOnly",
										useLibraryCodeForTypes = true,
										typeCheckingMode = "off",
										exclude = { "venv" },
									},
								},
							},
						})
					end,
					["omnisharp"] = function()
						local pid = vim.fn.getpid()
						local omnisharp_bin = "/usr/bin/Omnisharp/omnisharp"
						require("lspconfig").omnisharp.setup({
							-- cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
							cmd = { "dotnet", omnisharp_bin .. "/OmniSharp.dll" },
							root_dir = require("lspconfig").util.root_pattern("*.sln"),

							settings = {
								FormattingOptions = {
									-- Enables support for reading code style, naming convention and analyzer
									-- settings from .editorconfig.
									EnableEditorConfigSupport = true,
									-- Specifies whether 'using' directives should be grouped and sorted during
									-- document formatting.
									OrganizeImports = nil,
								},
								MsBuild = {
									-- If true, MSBuild project system will only load projects for files that
									-- were opened in the editor. This setting is useful for big C# codebases
									-- and allows for faster initialization of code navigation features only
									-- for projects that are relevant to code that is being edited. With this
									-- setting enabled OmniSharp may load fewer projects and may thus display
									-- incomplete reference lists for symbols.
									LoadProjectsOnDemand = nil,
								},
								RoslynExtensionsOptions = {
									-- Enables support for roslyn analyzers, code fixes and rulesets.
									EnableAnalyzersSupport = nil,
									-- Enables support for showing unimported types and unimported extension
									-- methods in completion lists. When committed, the appropriate using
									-- directive will be added at the top of the current file. This option can
									-- have a negative impact on initial completion responsiveness,
									-- particularly for the first few completion sessions after opening a
									-- solution.
									EnableImportCompletion = nil,
									-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
									-- true
									AnalyzeOpenDocumentsOnly = nil,
								},
								Sdk = {
									-- Specifies whether to include preview versions of the .NET SDK when
									-- determining which version to use for project loading.
									IncludePrereleases = true,
								},
							},
						})
					end,
					["gopls"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.gopls.setup({
							settings = {
								gopls = {
									gofumpt = true,
									codelenses = {
										gc_details = false,
										generate = true,
										regenerate_cgo = true,
										run_govulncheck = true,
										test = true,
										tidy = true,
										upgrade_dependency = true,
										vendor = true,
									},
									hints = {
										assignVariableTypes = true,
										compositeLiteralFields = true,
										compositeLiteralTypes = true,
										constantValues = true,
										functionTypeParameters = true,
										parameterNames = true,
										rangeVariableTypes = true,
									},
									analyses = {
										fieldalignment = true,
										nilness = true,
										unusedparams = true,
										unusedwrite = true,
										useany = true,
									},
									usePlaceholders = true,
									completeUnimported = true,
									staticcheck = true,
									directoryFilters = {
										"-.git",
										"-.vscode",
										"-.idea",
										"-.vscode-test",
										"-node_modules",
									},
									semanticTokens = true,
								},
							},
						})
					end,
					["jsonls"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.jsonls.setup({
							settings = {},
						})
					end,
					["yamlls"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.yamlls.setup({
							settings = {},
						})
					end,
					["zls"] = function()
						vim.g.zig_fmt_autosave = 0
						local lspconfig = require("lspconfig")
						lspconfig.zls.setup({
							settings = {
								zig_exe_path = "/usr/bin/zig/zig",
							},
						})
					end,
				},
			})
		end,
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>va",
				"<cmd>lua require('tiny-code-action').code_action()<cr>",
				{ noremap = true, silent = true }
			)
		end,
	},
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		config = function()
			vim.api.nvim_set_hl(0, "LightBulbSign", { fg = "#FFA500", bg = "none" })
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
				sign = {
					enabled = true,
					-- Text to show in the sign column.
					-- Must be between 1-2 characters.
					text = "",
					-- Highlight group to highlight the sign column text.
					hl = "LightBulbSign",
				},
			})
		end,
	},
}
