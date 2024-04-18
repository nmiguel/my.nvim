return {
    "folke/trouble.nvim",
    branch = "dev", -- IMPORTANT!
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        focus = true,
    },
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Document Diagnostics (Trouble)" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Workspace Diagnostics (Trouble)" },
        { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
        -- {
        --     "[d",
        --     function()
        --         if require("trouble").is_open() then
        --             require("trouble").previous({ skip_groups = true, jump = true })
        --         else
        --             local ok, err = pcall(vim.cmd.cprev)
        --             if not ok then
        --                 vim.notify(err, vim.log.levels.ERROR)
        --             end
        --         end
        --     end,
        --     desc = "Previous trouble/quickfix item",
        -- },
        -- {
        --     "]d",
        --     function()
        --         if require("trouble").is_open() then
        --             require("trouble").next({ skip_groups = true, jump = true })
        --         else
        --             local ok, err = pcall(vim.cmd.cnext)
        --             if not ok then
        --                 vim.notify(err, vim.log.levels.ERROR)
        --             end
        --         end
        --     end,
        --     desc = "Next trouble/quickfix item",
        -- },
    },
}
