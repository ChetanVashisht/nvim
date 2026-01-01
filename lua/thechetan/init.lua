local opts = { noremap = true, silent = true }

-------------------------------------------------------------------------------
----------------------------- Paste from clipboard ----------------------------
-------------------------------------------------------------------------------
vim.keymap.set("n", "x", '"_x', opts)
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("i", "<D-v>", "<C-r>*", opts)

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
vim.g.neovide_cursor_animation_length = 0.05

vim.keymap.set("n", "fj", "<C-w>j")
vim.keymap.set("n", "fh", "<C-w>h")
vim.keymap.set("n", "fl", "<C-w>l")
vim.keymap.set("n", "fk", "<C-w>k")

vim.keymap.set("n", "<leader>bd", ":bp | bd #<CR>", opts)

vim.api.nvim_create_user_command("E", "Explore", {})

vim.keymap.set("n", "<BS>", ":b#<CR>", opts)
vim.keymap.set("n", "<leader>fec", ":e ~/.config/fish/config.fish<CR>", opts)
vim.keymap.set("n", "<leader>fei", ":e ~/.config/nvim/lua/thechetan/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fek", ":e ~/.config/nvim/lua/theprimeagen/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fel", ":e ~/.config/nvim/lua/theprimeagen/lazy<CR>", opts)
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("only")
end, opts)

-- Map 'q' to ':q' only in read-only buffers
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.readonly then
            vim.keymap.set("n", "q", "<cmd>q<CR>", { noremap = true, silent = true, buffer = true })
        end
    end
})


vim.keymap.set("n", "<D-1>", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<D-S-R>", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<D-S-G>", vim.lsp.buf.references, opts)
vim.keymap.set("n", "<D-G>", vim.lsp.buf.incoming_calls, opts)
vim.keymap.set('n', 'gj', vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, { desc = "Show errors" })

vim.keymap.set("n", "gg", "ggzz", { silent = true })
vim.keymap.set("n", "G", "Gzz", { silent = true })
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
vim.opt.path:append("src") -- Allows searching inside packages
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
--------------------------- Terminal keymaps ---------------------------------
------------------------------------------------------------------------------
vim.opt.shell = "/opt/homebrew/bin/fish"
vim.keymap.set('c', '%%', "<C-R>=expand('%:h').'/'<cr>")
vim.keymap.set("n", "<leader>t", ":vsplit | terminal<CR>%%", opts)
-- vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
vim.api.nvim_set_keymap("t", "jj", "<C-\\><C-n>", opts)

-- disable line numbering in terminal mode
-- vim.keymap.set("t", "vim ", [[<C-\><C-n>:tabedit <C-R>=getcwd().'/'<CR>]], { silent = true })
local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.cmd("startinsert")
    end,
    group = vim_term
})

vim.api.nvim_set_hl(0, "TermCursorNC", {
    fg = "#fdf6e3",
    bg = "#93a1a1",
    ctermfg = 15,
    ctermbg = 14
})

-------------------------------------------------------------------------------
----------------------------- Evil clever f -----------------------------------
-------------------------------------------------------------------------------

-- local function select_range(start_row, start_col, end_row, end_col)
--     vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
--     vim.cmd("normal! v")
--     vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col -1 })
-- end
--
-- local function listToSet(list)
--     local set = {}
--     for _, v in ipairs(list) do
--         set[v] = true
--     end
--     return set
-- end
--
-- local tokens = {'string', 'parameters', 'arguments', 'table_constructor', "parenthesized_expression", "bracket_index_expression", "interface_type", "parameter_list", "if_statement", "import_spec_list", "argument_list", "interpreted_string_literal", "quoted_attribute_value", "array", "named_imports", "formal_parameters", "interface_body", "statement_block", "for_statement", "object", "function_declaration"}
-- local tokens_set = listToSet(tokens)
-- local terminal_tokens = {'program', 'chunk'}
-- local terminal_tokens_set = listToSet(terminal_tokens)
--
-- local function select_node()
--     local node = vim.treesitter.get_node()
--     local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(node)
--     print(node:type(), start_row, start_col, end_row, end_col)
-- end
--
-- local function select_function_or_string(around)
--     local node = vim.treesitter.get_node()
--     local selected_node = nil
--     while(node) do
--         if(tokens_set[node:type()] ~= nil) then
--             selected_node = node
--             break
--         elseif (terminal_tokens_set[node:type()] ~=nil) then
--             return
--         else
--             node = node:parent()
--         end
--     end
--     local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(selected_node)
--     if (not around) then
--         start_col = start_col + 1
--         end_col = end_col - 1
--     end
--     select_range(start_row, start_col, end_row, end_col)
-- end
--
-- local function del(around)
--     return select_function_or_string(around)
-- end
--
-- vim.keymap.set({ "o", "x" }, "af", function () del(true) end, { silent = true })
-- vim.keymap.set({ "o", "x" }, "if", function () del(false) end, { silent = true })
-- vim.keymap.set("n", "F", select_node, { silent = true })


-------------------------------------------------------------------------------
----------------------------- Useful settings ---------------------------------
-------------------------------------------------------------------------------

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.g.neovide_input_use_logo = true


vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", ";", ":")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.opt.switchbuf = 'usetab'
vim.keymap.set("n", "<leader>x", ":.lua<CR>")

vim.keymap.set('n', '<leader>ff', '<cmd>CommandTFd<cr>', { desc = 'Command-T Files' })
vim.keymap.set('n', '<leader>bb', '<cmd>CommandTBuffer<cr>', { desc = 'Command-T Buffers' })


vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-------------------------------------------------------------------------------
----------------------------- Colorscheme -------------------------------------
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function()
        -- Best for terminal
        -- vim.cmd.colorscheme("rose-pine-dawn")
        --
        -- Best for dark theme
        vim.cmd.colorscheme("brightburn")
        --
        -- Best for light theme
        -- vim.cmd.colorscheme("tokyonight-day")
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "#fdf6e3" })
    end
})


vim.g.netrw_banner = 0
vim.opt.winwidth = 85
vim.g.neovide_fullscreen = true

vim.opt.mouse = ""

vim.o.winborder = 'double'
vim.o.acd = true
vim.o.fdm = 'indent'
