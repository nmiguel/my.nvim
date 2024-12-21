return {
	"saghen/blink.cmp",
	lazy = false,
	dependencies = "rafamadriz/friendly-snippets",
	version = "v0.*",

	config = function()
		local rounded_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
		require("blink.cmp").setup({
			appearance = {
				nerd_font_variant = "normal",
			},

			keymap = {
				preset = "default",
                -- Allow tab to accept in cmdline
				-- ["<Tab>"] = {
				-- 	function(_)
				-- 		if vim.api.nvim_get_mode().mode == "c" then
				-- 			return
				-- 		end
				-- 		return true
				-- 	end,
				-- 	"accept",
				-- },
                -- TODO: add back the default tab function
			},

			completion = {
				accept = {
					create_undo_point = false,
					auto_brackets = {
						enabled = false,
					},
				},

				menu = {
					border = rounded_border,
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 100,
					window = {
						border = rounded_border,
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					border = rounded_border,
				},
			},
			sources = {
				default = { "lsp", "path", "buffer" },
                cmdline = {}
			},
		})
	end,
}
