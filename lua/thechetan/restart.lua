function Restart()
  print("Restarting...")
  vim.cmd("bufdo bd!")
end
vim.api.nvim_create_user_command("Restart", Restart, {})

function OpenTestVSplit()
  local file = vim.fn.expand('%:p')
  local test_file

  if file:match('%.spec%.[jt]s$') then
    -- foo.spec.ts -> foo.ts
    test_file = file:gsub('^(.*)%.spec(%.[jt]s)$', '%1%2')
  elseif file:match('%.[jt]s$') then
    -- foo.ts -> foo.spec.ts
    test_file = file:gsub('^(.*)(%.[jt]s)$', '%1.spec%2')
  else
    print("Not JS/TS. I decline.")
    return
  end

  vim.cmd('vsplit ' .. test_file)
end

vim.keymap.set('n', '<leader>t', OpenTestVSplit)
