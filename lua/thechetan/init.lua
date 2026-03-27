local opts = { noremap = true, silent = true }

-------------------------------------------------------------------------------
----------------------------- Paste from clipboard ----------------------------
-------------------------------------------------------------------------------
vim.keymap.set("n", "x", '"_x', opts)
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("i", "<D-v>", "<C-r>*", opts)
vim.keymap.set("t", "<D-v>", "<C-r>*", opts)

-- vim.keymap.set("c", "<D-v>", function()
--     -- Open the command-line window (`q:`)
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, true, true), "n", false)
--     -- Small delay, then paste inside the `q:` window
--     vim.defer_fn(function()
--         local clip = vim.fn.getreg("+"):gsub("\n", " ") -- Remove newlines
--         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i" .. clip, true, true, true), "n", false)
--     end, 100) -- Ensure the command-line window is fully open
-- end, { noremap = true, silent = false })

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

vim.keymap.set("n", "<BS>", ":b#<CR>", opts)
vim.keymap.set("n", "<leader>fec", ":e ~/.config/fish/config.fish<CR>", opts)
vim.keymap.set("n", "<leader>fei", ":e ~/.config/nvim/lua/thechetan/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fek", ":e ~/.config/nvim/lua/theprimeagen/init.lua<CR>", opts)
vim.keymap.set("n", "<leader>fel", ":e ~/.config/nvim/lua/theprimeagen/lazy<CR>", opts)
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("only")
end, opts)

local function grep_and_open(q)
  vim.cmd("grep '" .. q .. "' .")
  vim.cmd("copen")
end

-- vim.keymap.set("n", "<leader>s", function()
--   grep_and_open(vim.fn.expand("<cword>"))
-- end, { silent = true })

vim.keymap.set("n", "<D-s>", function()
  grep_and_open(vim.fn.expand("<cword>"))
end, { silent = true })

vim.keymap.set("v", "<leader>s", function()
  vim.cmd([[silent normal! "vy]])
  grep_and_open(vim.fn.getreg("v"):gsub("\n", ""))
end, { silent = true })

vim.keymap.set("v", "<D-s>", function()
  vim.cmd([[silent normal! "vy]])
  grep_and_open(vim.fn.getreg("v"):gsub("\n", ""))
end, { silent = true })

-- Map 'q' to ':q' only in read-only buffers
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.readonly then
      vim.keymap.set("n", "q", "<cmd>q<CR>", { noremap = true, silent = true, buffer = true })
    end
  end
})


vim.keymap.set("n", "<D-o>", vim.lsp.buf.document_symbol, opts)
vim.keymap.set("n", "<D-S-o>", function ()
  vim.lsp.buf.workspace_symbol(vim.fn.expand("<cword>"))
end, opts)
vim.keymap.set({"n", "v"}, "<C-1>", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<D-S-R>", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<D-S-G>", vim.lsp.buf.references, opts)
vim.keymap.set("n", "<D-G>", vim.lsp.buf.incoming_calls, opts)
vim.keymap.set('n', 'gj', vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set('n', '<D-j>', vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, { desc = "Show errors" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show errors" })

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
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldenable = true  -- Ensure folding is enabled
vim.opt.foldlevel = 99     -- Start with all folds open
function MyFoldText()
  return vim.fn.getline(vim.v.foldstart) .. ' ... ' .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end
vim.opt.foldtext = 'v:lua.MyFoldText()'
vim.opt.fillchars:append({fold = " " })

------------------------------------------------------------------------------
--------------------------- Terminal keymaps ---------------------------------
------------------------------------------------------------------------------
-- vim.opt.shell = "/opt/homebrew/bin/fish"
vim.keymap.set('c', '%%', "<C-R>=expand('%:h').'/'<cr>")
vim.api.nvim_set_keymap("t", "jj", "<C-\\><C-n>", opts)

local vim_term = vim.api.nvim_create_augroup('vim_term', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.cmd("startinsert")
  end,
  group = vim_term
})

-- Note vim.g.acd doesn't work for terminal mode, so we have to hack it from the shell
-- # fish.config
-- function sync_nvim_cwd --on-variable PWD
--     if set -q NVIM
--         command nvim --server $NVIM  --remote-expr "execute('cd ' . fnameescape('$PWD'))"
--     end
-- end

-- Note: To prevent opening vim inside vim, we hack a command
-- to open the file in a new tab
--
-- function vim
--     # If we're already inside Neovide, ask Neovim to open a tab
--     if set -q NVIM
--         command nvim --server $NVIM --remote-tab $argv
--     else
--         # Outside Neovide, launch Neovide normally
--         command neovide $argv
--     end
-- end
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

-- vim.opt.scrolloff = 8
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
vim.keymap.set("n", '<leader>bb', '<cmd>CommandTBuffer<cr>', { desc = 'Command-T Buffers' })
vim.keymap.set("t", '<C-b>', '<cmd>CommandTBuffer<cr>', { desc = 'Command-T Buffers' })

vim.keymap.set("n", '<leader><leader>', '<C-^>', { desc = 'switch back' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-------------------------------------------------------------------------------
----------------------------- Colorscheme -------------------------------------
-------------------------------------------------------------------------------
-- https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then return end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function() io.write("\027]111\027\\") end,
})

local function set_theme()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  if result:match("Dark") then
    vim.o.background = "dark"
    vim.cmd.colorscheme("default")
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#bbbbbb", bg = "#000000" })
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("shine")
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#ffffff" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#bbbbbb", bg = "#ffffff" })
  end
end

set_theme()
-- vim.cmd.colorscheme("tokyonight-day")
-- For sepia
-- vim.cmd.colorscheme("retrobox")
-- vim.cmd.colorscheme("rose-pine-dawn")
-- vim.cmd.colorscheme("shine")
-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#fdf6e3" })

vim.g.netrw_banner = 0
vim.opt.winwidth = 80
vim.g.neovide_fullscreen = true

vim.opt.mouse = ""

vim.o.winborder = 'double'
vim.o.fdm = 'indent'

vim.keymap.set("t", "<ScrollWheelUp>",   "", { noremap = true })
vim.keymap.set("t", "<ScrollWheelDown>", "", { noremap = true })
vim.keymap.set("v", "<leader>o", function ()
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg('z')
  vim.ui.open(text)
end)
vim.keymap.set("","<C-t>", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n","<D-t>", "<Cmd>tabnew<CR>", {silent = true})
vim.keymap.set("","<D-w>", "<Cmd>tabclose<CR>", {silent = true})
vim.keymap.set("", "<D-S-Right>", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("", "<D-S-Left>", "<Cmd>tabNext<CR>", { silent = true })
vim.keymap.set("", "<D-Right>", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("", "<D-Left>", "<Cmd>tabNext<CR>", { silent = true })

vim.keymap.set("t","<D-t>", "<Cmd>tabnew<CR>", {silent = true})
vim.keymap.set("t","<D-w>", "<Cmd>tabclose<CR>", {silent = true})
vim.keymap.set("t", "<D-S-Right>", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("t", "<D-S-Left>", "<Cmd>tabNext<CR>", { silent = true })
vim.keymap.set("t", "<D-Right>", "<Cmd>tabnext<CR>", { silent = true })
vim.keymap.set("t", "<D-Left>", "<Cmd>tabNext<CR>", { silent = true })
vim.opt.confirm = true

-- include the restart command from the other file
vim.cmd.source("~/.config/nvim/lua/thechetan/restart.lua")
vim.cmd.source("~/.config/nvim/lua/thechetan/trial.lua")
-- vim.opt.rtp:prepend("~/.opam/default/share/ocp-indent/vim")


-- vim.keymap.set("n", "<leader>y", function()
--   local file = vim.fn.expand("%")
--   local test_file
--
--   if file:match("%.spec.ts$") then
--     test_file = file
--   else
--     test_file = file:gsub("%.ts$", ".spec.ts")
--   end
--
--   vim.cmd("!node --test --import tsx --test-reporter=dot " .. test_file)
-- end, { noremap = true })
