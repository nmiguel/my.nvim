return {
	"stevearc/dressing.nvim",
	{
		"levouh/tint.nvim",
		opts = {},
	},
	{
		"echasnovski/mini.surround",
		event = { "VeryLazy" },
		version = "*",
		config = function()
			require("mini.surround").setup({})
		end,
	},
	{
		"kana/vim-textobj-entire",
		event = { "VeryLazy" },
		dependencies = { "kana/vim-textobj-user" },
	},
}
