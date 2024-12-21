return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		-- enabled = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				sidebars = { "Packer" },
				style = "night",
				dim_inactive = true,
				styles = {
					sidebars = "transparent",
					float = "transparent",
				},
				on_colors = function(c)
					c.bg = "NONE"
					c.bg_dark = "NONE"
					c.bg_float = "NONE"
				end,

				on_highlights = function(hl, c)
					hl.StatusLine = {
						fg = c.fg,
						bg = "none",
					}
					hl.LineNr = {
						fg = c.purple,
						bg = "none",
					}
					hl.DiagnosticVirtualTextInfo = {
						bg = "none",
						fg = hl.DiagnosticVirtualTextInfo.fg,
					}
					hl.DiagnosticVirtualTextWarn = {
						bg = "none",
						fg = hl.DiagnosticVirtualTextWarn.fg,
					}
					hl.DiagnosticVirtualTextError = {
						bg = "none",
						fg = hl.DiagnosticVirtualTextError.fg,
					}
					hl.DiagnosticVirtualTextHint = {
						bg = "none",
						fg = hl.DiagnosticVirtualTextHint.fg,
					}
					hl.WinSeparator = {
						fg = c.purple,
						bg = "none",
					}
					hl.GitSignsAdd = {
						fg = c.green,
						bg = "none",
					}
					hl.GitSignsChange = {
						fg = c.blue,
						bg = "none",
					}

					-- Completion Menu Adjustments
					hl.BlinkCmpMenu = {
						fg = c.fg,
						bg = "none",
					}
					hl.Pmenu = {
						fg = c.fg,
						bg = "none",
					}
					hl.BlinkCmpMenuBorder = hl.TelescopeBorder
					hl.BlinkCmpMenuSelection = hl.PmenuSel
					hl.BlinkCmpLabel = {
						fg = "none",
						bg = "none",
					}
					hl.BlinkCmpLabelMatch = {
						fg = c.red,
						bg = "none",
					}

					-- Scrollbar and Border Adjustments
					hl.PmenuThumb = {
						fg = hl.TelescopeBorder.fg,
						bg = "none",
					}
					hl.BlinkCmpScrollBarThumb = { fg = c.fg, bg = c.fg }

					-- Additional Blink Highlight Groups
					hl.BlinkCmpDoc = hl.Float
					hl.BlinkCmpDocBorder = hl.TelescopeBorder
					hl.BlinkCmpSignatureHelp = hl.Float
					hl.BlinkCmpSignatureHelpBorder = hl.TelescopeBorder
					hl.BlinkCmpSignatureHelpActiveParameter = hl.LspSignatureActiveParameter

					hl.LspInlayHint = {
						fg = hl.Comment.fg,
						bg = "none",
						italic = true,
						-- underline = true,
					}
				end,
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
}
