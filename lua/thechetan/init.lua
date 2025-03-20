local opts = { noremap = true, silent = true }

vim.keymap.set("n", "fj", "<C-w>j")
vim.keymap.set("n", "fh", "<C-w>h")
vim.keymap.set("n", "fl", "<C-w>l")
vim.keymap.set("n", "fk", "<C-w>k")

vim.keymap.set("n", "j", "gjzz", { noremap = true })
vim.keymap.set("n", "k", "gkzz", { noremap = true })
vim.keymap.set("n", "}", "]zz", { noremap = true })
vim.keymap.set("n", "]", "}zz", { noremap = true })
vim.keymap.set("n", "{", "[zz", { noremap = true })
vim.keymap.set("n", "[", "{zz", { noremap = true })

vim.keymap.set("n", "<leader>bd", ":bp | bd #<CR>", opts)

vim.api.nvim_create_user_command("E", "Explore", {})

local builtin = require('telescope.builtin')

vim.keymap.set("n", "<BS>", ":b#<CR>", opts)
vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
vim.keymap.set("n", "<leader>pp", ":Telescope project<CR>", opts)
vim.keymap.set("n", "<leader>ff", function()
    vim.cmd("Ex .")
end, opts)

vim.keymap.set("n", "<leader>fei", ":e ~/.config/nvim/lua/thechetan/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fek", ":e ~/.config/nvim/lua/theprimeagen/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fel", ":e ~/.config/nvim/lua/theprimeagen/lazy<CR>", opts)
vim.keymap.set("n", "<leader>bl", ":Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>o", function ()
    builtin.lsp_document_symbols({ symbols='function' })
end )
vim.keymap.set("n", "<C-space>", function ()
    require('cmp').complete()
end, opts)

vim.keymap.set('n', '<leader>h', builtin.builtin, {})
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("only")
end, opts)

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


vim.keymap.set("n", "<D-1>", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<D-R>", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<D-G>", vim.lsp.buf.incoming_calls, opts)

vim.keymap.set("n", "x", '"_x', opts)
vim.opt.clipboard = "unnamedplus"
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true  -- Ensure folding is enabled
vim.opt.foldlevel = 99     -- Start with all folds open

vim.o.guifont = "Monaco:h20"
vim.g.neovide_cursor_animation_length = 0.001

-- Because default vim folding looks ugly
function MyFoldText()
    return vim.fn.getline(vim.v.foldstart) .. ' ... ' .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end
vim.opt.foldtext = 'v:lua.MyFoldText()'
vim.opt.fillchars:append({fold = " " })

vim.keymap.set("n", "<D-S-Down>", ":vertical resize -5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Up>", ":vertical resize +5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Right>", ":resize +5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Left>", ":resize -5<CR>", { silent = true })
vim.keymap.set("n", "gg", "ggzz", { silent = true })
vim.keymap.set("n", "G", "Gzz", { silent = true })
vim.keymap.set('n', '<D-E>', builtin.git_files, {})

vim.g.neovide_fullscreen = true

-------------------------------------------------------------------------------
----------------------------- Frontend Hacks ----------------------------------
-------------------------------------------------------------------------------
-- Because LSP doesn't work in the frontend repo, this
-- workaround allows me to visit a file using `gf`
vim.opt.path:append("packages/**/src") -- Allows searching inside packages
vim.opt.includeexpr = "v:lua.ResolveImportPath(v:fname)" -- Custom resolution function

function _G.ResolveImportPath(fname)
    local new_path = fname:gsub("^@([^/]+)/", "packages/%1/src/")
    local extensions = { "", ".ts" }
    for _, ext in ipairs(extensions) do
        local full_path = new_path .. ext
        if vim.fn.filereadable(full_path) == 1 then
            return full_path
        end
    end

    return new_path
end


require'nvim-treesitter.configs'.setup {
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Jump forward to the next match

            keymaps = {
                -- Strings (double-quoted, single-quoted, backticks)
                ["af"] = { query = "@string.outer", desc = "Select outer string" },
                ["if"] = { query = "@string.inner", desc = "Select inner string" },

                -- Brackets: (), {}, []
                ["aB"] = { query = "@block.outer", desc = "Select outer block" }, -- {}, (), []
                ["iB"] = { query = "@block.inner", desc = "Select inner block" },

                -- Specific for function calls/definitions
                ["aF"] = { query = "@function.outer", desc = "Select outer function" },
                ["iF"] = { query = "@function.inner", desc = "Select inner function" },
            },
        },
    },
}


vim.keymap.set("n", "<D-F>", function()
    require("spectre").open()
end, { silent = true, noremap = true, desc = "Open Spectre" })


------------------------------------------------------------------------------
--------------------------- Terminal keymaps ---------------------------------
------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>t", ":vsplit | terminal<CR>", opts)
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", opts)
vim.api.nvim_set_keymap("t", "jj", "<C-\\><C-n>", opts)

-- disable line numbering in terminal mode
local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
    end,
    group = vim_term
})

local function term_map(lhs, action)
    vim.keymap.set({ "n", "t" }, lhs, function()
        if vim.bo.buftype == "terminal" then
            if vim.fn.mode() == "t" then
                -- If already in terminal mode, send terminal-specific action
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(lhs, true, false, true), "n", false)
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i" .. action, true, false, true), "n", false)
            end
        else
            -- Default Vim behavior for normal buffers
            vim.api.nvim_feedkeys(lhs, "n", false)
        end
    end, { noremap = true, silent = true })
end

term_map("x", "<BS><C-\\><C-n>")
term_map("s", "<BS>")
term_map("C", "<C-u>")
term_map("dd", "<C-u><C-\\><C-n>")
term_map("D", "<C-u><C-\\><C-n>")
term_map("<C-k>", "<C-u>clear<CR>")
