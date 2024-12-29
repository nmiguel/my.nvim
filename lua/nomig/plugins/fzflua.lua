return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	opts = function(_, opts)
		local config = require("fzf-lua.config")
		local actions = require("fzf-lua.actions")

		local img_previewer ---@type string[]?
		for _, v in ipairs({
			{ cmd = "ueberzug", args = {} },
			{ cmd = "chafa", args = { "{file}", "--format=symbols" } },
			{ cmd = "viu", args = { "-b" } },
		}) do
			if vim.fn.executable(v.cmd) == 1 then
				img_previewer = vim.list_extend({ v.cmd }, v.args)
				break
			end
		end

		return {
			"default-title",
			fzf_colors = true,
			fzf_opts = {
				["--no-scrollbar"] = true,
			},
			defaults = {
				-- formatter = "path.filename_first",
				formatter = "path.dirname_first",
			},
			previewers = {
				builtin = {
					extensions = {
						["png"] = img_previewer,
						["jpg"] = img_previewer,
						["jpeg"] = img_previewer,
						["gif"] = img_previewer,
						["webp"] = img_previewer,
					},
					ueberzug_scaler = "fit_contain",
				},
			},
			-- Custom LazyVim option to configure vim.ui.select
			ui_select = function(fzf_opts, items)
				return vim.tbl_deep_extend("force", fzf_opts, {
					prompt = " ",
					winopts = {
						title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
						title_pos = "center",
					},
				}, fzf_opts.kind == "codeaction" and {
					winopts = {
						layout = "vertical",
						-- height is number of items minus 15 lines for the preview, with a max of 80% screen height
						height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
						width = 0.5,
						preview = {
							layout = "vertical",
							vertical = "down:15,border-top",
						},
					},
				} or {
					winopts = {
						width = 0.5,
						-- height is number of items, with a max of 80% screen height
						height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
					},
				})
			end,
			winopts = {
				width = 0.8,
				height = 0.8,
				row = 0.5,
				col = 0.5,
				preview = {
					scrollchars = { "┃", "" },
				},
			},
			files = {
				cwd_prompt = false,
				actions = {
					["ctrl-i"] = { actions.toggle_ignore },
					["ctrl-h"] = { actions.toggle_hidden },
				},
			},
			grep = {
				actions = {
					["ctrl-i"] = { actions.toggle_ignore },
					["ctrl-h"] = { actions.toggle_hidden },
				},
			},
			lsp = {
				symbols = {
					symbol_hl = function(s)
						return "TroubleIcon" .. s
					end,
					symbol_fmt = function(s)
						return s:lower() .. "\t"
					end,
					child_prefix = false,
				},
				code_actions = {
					previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
				},
			},
		}
	end,
	config = function(_, opts)
		if opts[1] == "default-title" then
			-- use the same prompt for all pickers for profile `default-title` and
			-- profiles that use `default-title` as base profile
			local function fix(t)
				t.prompt = t.prompt ~= nil and " " or nil
				for _, v in pairs(t) do
					if type(v) == "table" then
						fix(v)
					end
				end
				return t
			end
			opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
			opts[1] = nil
		end
		require("fzf-lua").setup(opts)
	end,
	keys = {
		{ "<leader>ps", "<cmd>FzfLua live_grep<cr>", desc = "Smart Grep" },
		{
			"<leader>pf",
			function()
				local cmd = ""
				local buffers = {}
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(bufnr) then
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						if bufname ~= "" then
							bufname = vim.fn.fnamemodify(bufname, ":~:.")
							if
								string.find(vim.fs.basename(bufname), "NvimTree_") ~= 1 -- filter out nvim tree buffer
								and bufname ~= vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.") -- filter out current buffer
							then
								local info = vim.fn.getbufinfo(bufnr)
								table.insert(buffers, { name = bufname, info = info[1] or info })
							end
						end
					end
				end

				table.sort(buffers, function(a, b)
					return a.info.lastused > b.info.lastused
				end)

				for _, buffer in ipairs(buffers) do
					cmd = cmd .. 'echo "' .. buffer.name .. '" && '
				end

				cmd = cmd .. "fd --color=never --type f --hidden --follow --exclude .git"

				for _, buffer in ipairs(buffers) do
					cmd = cmd .. ' --exclude "' .. buffer.name .. '"'
				end

				require("fzf-lua").files({ cmd = cmd, fzf_opts = { ["--tiebreak"] = "index" } })
			end,
			desc = "Smart Open",
		},
	},
}
