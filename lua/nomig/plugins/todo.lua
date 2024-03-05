return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    opts ={
        -- highlight = {
        --     pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
        -- },
        -- search = {
        --     pattern = [[\b(KEYWORDS)]], -- ripgrep regex
        -- },
    },
    keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    },
}
