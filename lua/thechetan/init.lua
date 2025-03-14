vim.keymap.set("n", "fj", "<C-w>j")
vim.keymap.set("n", "fh", "<C-w>h")
vim.keymap.set("n", "fl", "<C-w>l")
vim.keymap.set("n", "fk", "<C-w>k")

vim.keymap.set("n", "e", "E", { noremap = true })
vim.keymap.set("n", "E", "e", { noremap = true })
vim.keymap.set("n", "w", "W", { noremap = true })
vim.keymap.set("n", "W", "w", { noremap = true })
vim.keymap.set("n", "b", "B", { noremap = true })
vim.keymap.set("n", "B", "b", { noremap = true })

vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "0", "g0", { noremap = true })

vim.keymap.set("n", "<leader>bd", ":bp | bd #<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("E", "Explore", {})

require('telescope').setup({})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>h', builtin.builtin, {})

vim.keymap.set('n', '<leader>s', function()
    local word = vim.fn.expand("<cword>")
    builtin.grep_string({ search = word })
end)

-- Map 'q' to ':q' only in read-only buffers
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.readonly then
            vim.keymap.set("n", "q", "<cmd>q<CR>", { noremap = true, silent = true, buffer = true })
        end
    end,
})

vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })
vim.opt.clipboard = "unnamedplus"
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }
