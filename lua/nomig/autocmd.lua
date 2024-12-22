vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	desc = "Clear whitespaces on end of line when saving",
	group = vim.api.nvim_create_augroup("nomig-clear-whitespace", { clear = true }),
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Stop auto commenting",
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Disable mouse
vim.cmd([[
aunmenu PopUp
]])
