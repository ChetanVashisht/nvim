return {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     copilot_node_command = "/Users/cgv/.local/share/fnm/node-versions/v20.19.0/installation/bin/node",
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = {
    --                 enabled = true,
    --                 auto_trigger = true,
    --                 hide_during_completion = false,
    --                 debounce = 25,
    --                 keymap = {
    --                     accept = false,
    --                     accept_word = false,
    --                     accept_line = "<Tab>",
    --                     next = false,
    --                     prev = false,
    --                     dismiss = false,
    --                 },
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     "CopilotC-Nvim/CopilotChat.nvim",
    --     dependencies = {
    --         "zbirenbaum/copilot.lua", -- Ensure Copilot is installed
    --     },
    --     opts = {
    --         debug = false, -- Set to true for debugging
    --     },
    --     keys = {
    --         { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
    --         { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code" },
    --         { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix Code" },
    --         { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests" },
    --     },
    -- },
{
  'kiddos/gemini.nvim',
  opts = {}
}
}
