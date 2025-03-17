local M = {}

M.delete_till_delimiter = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local char = line:sub(col, col)

  local pairs = { ['('] = ')', ['{'] = '}', ['['] = ']', ['<'] = '>' }

  if char == '"' or char == "'" then
    vim.cmd("normal! f" .. char .. "c")
  elseif pairs[char] then
    local match = pairs[char]
    if line:find(match, col + 1) then
      vim.cmd("normal! f" .. match .. "c")
    else
      vim.cmd("normal! C") -- If no match found, default to C
    end
  else
    vim.cmd("normal! C")
  end
end

vim.api.nvim_set_keymap("n", "C", ":lua require('clever_delete').delete_till_delimiter()<CR>", { noremap = true, silent = true })

return M
