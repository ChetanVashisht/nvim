local opts = { noremap = true, silent = true }

-------------------------------------------------------------------------------
----------------------------- Paste from clipboard ----------------------------
-------------------------------------------------------------------------------
vim.keymap.set("n", "x", '"_x', opts)
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("i", "<D-v>", "<C-r>*", opts)

-- vim.keymap.set("c", "<D-v>", function()
--     local clip = vim.fn.getreg("+") -- Get clipboard content
--     clip = clip:gsub("\n", " ") -- Replace newlines with spaces to prevent accidental execution
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(clip, true, true, true), "c", false)
-- end, { noremap = true, silent = false })


vim.keymap.set("c", "<D-v>", function()
    -- Open the command-line window (`q:`)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, true, true), "n", false)
    -- Small delay, then paste inside the `q:` window
    vim.defer_fn(function()
        local clip = vim.fn.getreg("+"):gsub("\n", " ") -- Remove newlines
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i" .. clip, true, true, true), "n", false)
    end, 100) -- Ensure the command-line window is fully open
end, { noremap = true, silent = false })

-------------------------------------------------------------------------------
----------------------------- Window Management --------------------------------
-------------------------------------------------------------------------------
vim.o.guifont = "Monaco:h20"
vim.g.neovide_cursor_animation_length = 0.001

vim.keymap.set("n", "fj", "<C-w>j")
vim.keymap.set("n", "fh", "<C-w>h")
vim.keymap.set("n", "fl", "<C-w>l")
vim.keymap.set("n", "fk", "<C-w>k")

vim.keymap.set("n", "<leader>bd", ":bp | bd #<CR>", opts)

vim.api.nvim_create_user_command("E", "Explore", {})
vim.g.neovide_fullscreen = true

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

vim.keymap.set("n", "<D-S-Down>", ":vertical resize -5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Up>", ":vertical resize +5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Right>", ":resize +5<CR>", { silent = true })
vim.keymap.set("n", "<D-S-Left>", ":resize -5<CR>", { silent = true })
vim.keymap.set("n", "gg", "ggzz", { silent = true })
vim.keymap.set("n", "G", "Gzz", { silent = true })
vim.keymap.set('n', '<D-E>', builtin.git_files, {})


vim.keymap.set("n", "<D-1>", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<D-R>", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<D-G>", vim.lsp.buf.incoming_calls, opts)

vim.keymap.set("n", "j", "gjzz", { noremap = true })
vim.keymap.set("n", "k", "gkzz", { noremap = true })
vim.keymap.set("n", "}", "]zz", { noremap = true })
vim.keymap.set("n", "]", "}zz", { noremap = true })
vim.keymap.set("n", "{", "[zz", { noremap = true })
vim.keymap.set("n", "[", "{zz", { noremap = true })

-------------------------------------------------------------------------------
------------------------------- Command line keymap ---------------------------
-------------------------------------------------------------------------------
vim.opt.wildignorecase = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

-------------------------------------------------------------------------------
------------------------------- Folding  --------------------------------------
-------------------------------------------------------------------------------
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true  -- Ensure folding is enabled
vim.opt.foldlevel = 99     -- Start with all folds open
function MyFoldText()
    return vim.fn.getline(vim.v.foldstart) .. ' ... ' .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end
vim.opt.foldtext = 'v:lua.MyFoldText()'
vim.opt.fillchars:append({fold = " " })

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

------------------------------------------------------------------------------
--------------------------- Search and Replace -------------------------------
------------------------------------------------------------------------------
vim.keymap.set("n", "<D-F>", function()
    require("spectre").open()
end, { silent = true, noremap = true, desc = "Open Spectre" })

------------------------------------------------------------------------------
--------------------------- Terminal keymaps ---------------------------------
------------------------------------------------------------------------------
vim.opt.shell = "/opt/homebrew/bin/fish"
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
term_map("<D-k>", "<C-u>clear<CR>")
term_map("<CR>", "<CR>")

vim.keymap.set("t", "<D-k>", function()
    if vim.bo.buftype == "terminal" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i<C-u>clear<CR>", true, false, true), "t", false)
    end
end, { noremap = true, silent = true })

vim.api.nvim_set_hl(0, "TermCursorNC", {
    fg = "#fdf6e3",
    bg = "#93a1a1",
    ctermfg = 15,
    ctermbg = 14,
    cterm = {}
})

-------------------------------------------------------------------------------
----------------------------- Evil clever f -----------------------------------
-------------------------------------------------------------------------------

local function select_range(start_row, start_col, end_row, end_col)
    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col -1 })
end

local function listToSet(list)
    local set = {}
    for _, v in ipairs(list) do
        set[v] = true
    end
    return set
end

local tokens = {'string', 'parameters', 'arguments', 'table_constructor', "parenthesized_expression", "bracket_index_expression", "interface_type", "parameter_list", "if_statement", "import_spec_list", "argument_list", "interpreted_string_literal", "quoted_attribute_value", "array", "named_imports", "formal_parameters", "interface_body", "statement_block", "for_statement", "object", "function_declaration"}
local tokens_set = listToSet(tokens)
local terminal_tokens = {'program', 'chunk'}
local terminal_tokens_set = listToSet(terminal_tokens)

local function select_node()
    local node = vim.treesitter.get_node()
    local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(node)
    print(node:type(), start_row, start_col, end_row, end_col)
end

local function select_function_or_string(around)
    local node = vim.treesitter.get_node()
    local selected_node = nil
    while(node) do
        if(tokens_set[node:type()] ~= nil) then
            selected_node = node
            break
        elseif (terminal_tokens_set[node:type()] ~=nil) then
            return
        else
            node = node:parent()
        end
    end
    local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(selected_node)
    if (not around) then
        start_col = start_col + 1
        end_col = end_col - 1
    end
    select_range(start_row, start_col, end_row, end_col)
end

local function del(around)
    return select_function_or_string(around)
end

vim.keymap.set({ "o", "x" }, "af", function () del(true) end, { silent = true })
vim.keymap.set({ "o", "x" }, "if", function () del(false) end, { silent = true })
vim.keymap.set("n", "gf", select_node, { silent = true })

-------------------------------------------------------------------------------
----------------------------- Git Fugitive ------------------------------------
-------------------------------------------------------------------------------

-- Note: Overriding vim's builtin function
local original_gwrite = vim.fn["fugitive#WriteCommand"]

vim.api.nvim_create_user_command("Gwrite", function(args)
    if vim.bo.filetype == "fugitive" then
        vim.api.nvim_err_writeln("🚫 Cannot run :Gwrite in a Fugitive buffer!")
    else
        original_gwrite(1, vim.v.count, "+", 0, "", args.args)
    end
end, { nargs = "?" })


