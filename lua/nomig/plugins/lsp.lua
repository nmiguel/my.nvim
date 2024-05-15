return {
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
		"folke/neodev.nvim",
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

		require("neodev").setup({})

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf, noremap = true }

				vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				vim.keymap.set("n", "<leader>va", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>vr", require("telescope.builtin").lsp_references, opts)
				vim.keymap.set("n", "<leader>vn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("i", "<C-s>", function()
					vim.lsp.buf.signature_help()
				end, opts)
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

		-- to learn how to use mason.nvim with lsp-zero
		-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = { "pyright", "gopls", "yamlls", "jsonls", "omnisharp", "zls" },
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
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
								},
							},
						},
					})
				end,
				["omnisharp"] = function()
					require("lspconfig").omnisharp.setup({
						handlers = {
							["textDocument/definition"] = require("omnisharp_extended").handler,
						},
						cmd = { "dotnet", "/usr/bin/omnisharp/OmniSharp.dll"},

						-- Enables support for reading code style, naming convention and analyzer
						-- settings from .editorconfig.
						enable_editorconfig_support = true,

						-- If true, MSBuild project system will only load projects for files that
						-- were opened in the editor. This setting is useful for big C# codebases
						-- and allows for faster initialization of code navigation features only
						-- for projects that are relevant to code that is being edited. With this
						-- setting enabled OmniSharp may load fewer projects and may thus display
						-- incomplete reference lists for symbols.
						enable_ms_build_load_projects_on_demand = false, -- default false

						-- Enables support for roslyn analyzers, code fixes and rulesets.
						enable_roslyn_analyzers = true, -- default false

						-- Specifies whether 'using' directives should be grouped and sorted during
						-- document formatting.
						organize_imports_on_format = true, -- default false

						-- Enables support for showing unimported types and unimported extension
						-- methods in completion lists. When committed, the appropriate using
						-- directive will be added at the top of the current file. This option can
						-- have a negative impact on initial completion responsiveness,
						-- particularly for the first few completion sessions after opening a
						-- solution.
						enable_import_completion = true, -- default false

						-- Specifies whether to include preview versions of the .NET SDK when
						-- determining which version to use for project loading.
						sdk_include_prereleases = true,

						-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
						-- true
						analyze_open_documents_only = true, -- default false
					})
				end,
				["gopls"] = function()
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "go",
						desc = "Set go run key",
						callback = function()
							vim.keymap.set("n", "<leader>rp", ":w<CR>:exec '!go run ' . shellescape(expand('%'))<CR>")
						end,
						once = true,
					})
					local lspconfig = require("lspconfig")
					lspconfig.gopls.setup({})
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
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						settings = { zig_exe_path = "/usr/bin/zig/zig"},
					})
				end,
			},
		})
	end,
}
