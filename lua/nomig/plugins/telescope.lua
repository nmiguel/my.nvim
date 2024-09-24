return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			-- Uses frecency and other metrics to sort files
			"danielfalk/smart-open.nvim",
			branch = "0.2.x",
			config = function()
				require("telescope").load_extension("smart_open")
			end,
			keys = {
				{
					mode = "n",
					"<leader>pf",
					function()
						require("telescope").extensions.smart_open.smart_open({
							cwd_only = true,
						})
					end,
				},
			},
			dependencies = {
				"kkharji/sqlite.lua",
				-- Optional.  If installed, native fzy will be used when match_algorithm is fzy
				{ "nvim-telescope/telescope-fzy-native.nvim" },
			},
		},
	},
	lazy = false,
	keys = {
		-- { mode = "n", "<leader>pf", require("telescope.builtin").find_files },
		{
			mode = "n",
			"<leader>paf",
			function()
				require("telescope.builtin").find_files({ no_ignore = true })
			end,
		},
		{ mode = "n", "<leader>ps", require("telescope.builtin").live_grep },
		{ mode = "n", "<leader>ds", require("telescope.builtin").help_tags },
	},
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
					},
				},
				path_display = { "filename_first" },
			},
			extensions = {
				smart_open = {
                    open_buffer_indicators = {
                        previous = ">",
                        others = "-"
                    }
				},
			},
		})
	end,
}
