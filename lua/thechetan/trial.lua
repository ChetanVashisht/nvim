
-- vim.keymap.set({"n"}, "<leader>v", "<Cmd>source %<CR>", {silent = true})
--
-- local trial = vim.api.nvim_create_augroup("trial", {clear = true})
-- vim.api.nvim_create_autocmd({"BufWritePost"}, {
--   desc = "For TDDing the flow",
--   pattern = {"*.ts", "*.spec.ts", "*.js", "*.spec.js"},
--   group = trial,
--   callback = function ()
--     local file = vim.fn.expand("%")
--     local test_file
--
--     if file:match("%.spec.[jt]s$") then
--       test_file = file
--     else
--       test_file = file:gsub("%.ts$", ".spec.ts")
--     end
--     vim.b.test_output = ""
--
--     vim.fn.jobstart(
--       {"node", "--test", "--import", "tsx", "--test-reporter=dot", test_file},
--       {
--         stdout_buffered = true,
--         on_stdout = function (_, data)
--           for l, line in ipairs(data) do
--             if l == 1 then
--               vim.b.test_output = (vim.b.test_output or "") .. line
--             end
--           end
--         end
--       }
--     )
--   end,
-- })
--
-- Custom function to handle logs with prepended timestamps
local function log_fold_expr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)

  -- 1. Matches standard Render timestamp logs: "2026-07-13 11:03:15  	at ..."
  -- %d%d%d%d%-%d%d%-%d%d matches the date YYYY-MM-DD
  -- .-%s+at%s+ skips the time/spaces and looks for the explicit 'at ' trace anchor
  if string.match(line, "^%d%d%d%d%-%d%d%-%d%d.-%s+at%s+") then
    return "1"
  end

  -- 2. Fallback for the "... common frames omitted" line at the end of the trace
  if string.match(line, "^%d%d%d%d%-%d%d%-%d%d.-%s+%.%.%.%s+%d+%s+common") then
    return "1"
  end

  -- If it's a log header line or database query, close the fold
  return "0"
end

-- Create the autocommand for log and text files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.log", "*.txt" },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.log_fold_expr()"
    
    -- Keep them open by default; use zM to collapse all, zR to expand all, <Space> to toggle
    vim.opt_local.foldlevel = 99 
    vim.keymap.set("n", "<space>", "za", { buffer = true, silent = true })
  end,
})

-- Expose function globally to NeoVim
_G.log_fold_expr = log_fold_expr
