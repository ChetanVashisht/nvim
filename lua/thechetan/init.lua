vim.keymap.set("n", "fj", "<C-w>j")
vim.keymap.set("n", "fh", "<C-w>h")
vim.keymap.set("n", "fl", "<C-w>l")
vim.keymap.set("n", "fk", "<C-w>k")

-- vim.keymap.set("n", "ew", "E", { noremap = true })
-- vim.keymap.set("n", "we", "W", { noremap = true })
-- vim.keymap.set("n", "be", "B", { noremap = true })
-- vim.keymap.set("n", "bw", "B", { noremap = true })

vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })
vim.keymap.set("n", "0", "g0", { noremap = true })
vim.keymap.set("n", "}", "]", { noremap = true })
vim.keymap.set("n", "]", "}", { noremap = true })
vim.keymap.set("n", "{", "[", { noremap = true })
vim.keymap.set("n", "[", "{", { noremap = true })

vim.keymap.set("n", "<leader>bd", ":bp | bd #<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("E", "Explore", {})

local builtin = require('telescope.builtin')

vim.keymap.set("n", "<BS>", ":b#<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
vim.keymap.set("n", "<leader>ff", function()
  vim.cmd("Ex .")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>fei", ":e ~/.config/nvim/lua/thechetan/init.lua<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fek", ":e ~/.config/nvim/lua/theprimeagen/init.lua<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fel", ":e ~/.config/nvim/lua/theprimeagen/lazy<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>o", function ()
    builtin.lsp_document_symbols({ symbols='function' })
end )
vim.keymap.set("n", "<C-space>", function ()
    require('cmp').complete()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>h', builtin.builtin, {})
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("only")
end, { noremap = true, silent = true })

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

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true  -- Ensure folding is enabled
vim.opt.foldlevel = 99     -- Start with all folds open

vim.keymap.set("n", "<D-1>", vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.o.guifont = "Monaco:h20"
vim.g.neovide_cursor_animation_length = 0.001

-- require("clever_delete")
--
function MyFoldText()
    return vim.fn.getline(vim.v.foldstart) .. ' ... ' .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
  -- return vim.fn.getline(vim.v.foldstart)
end
vim.opt.foldtext = 'v:lua.MyFoldText()'
vim.opt.fillchars:append({fold = " " })
