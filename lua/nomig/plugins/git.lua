return {
	{
		{
			"FabijanZulj/blame.nvim",
			keys = {
				{
					"<leader>bg",
					"<cmd>BlameToggle<CR>",
					mode = "n",
					desc = "Toggle Blame",
				},
			},
			config = function()
				local function fix_size(str, size)
					if string.len(str) < size then
						str = str .. string.rep(" ", size - string.len(str))
					elseif string.len(str) > size then
						str = string.sub(str, 1, size - 3) .. "..."
					end
					return str
				end

				require("blame").setup({
					colors = {
						"#29c4d6",
						"#98c379",
						"#c678dd",
						"#e86671",
						"#d19a66",
					},
					format_fn = function(line_porcelain, config, idx)
						local hash = string.sub(line_porcelain.hash, 0, 7)
						local summary
						if #line_porcelain.summary > config.max_summary_width then
							summary = string.sub(line_porcelain.summary, 0, config.max_summary_width - 3) .. "..."
						else
							summary = line_porcelain.summary
						end
						return {
							idx = idx,
							values = {
								{
									textValue = os.date(config.date_format, line_porcelain.committer_time),
									hl = "Comment",
								},
								{
									textValue = fix_size(line_porcelain.author, 15),
									hl = hash,
								},
								{
									textValue = summary,
									hl = "@text",
								},
							},
							format = "%s  %s  %s",
						}
					end,
				})
			end,
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufEnter",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "│" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
}
