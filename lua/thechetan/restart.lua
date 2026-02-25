function Restart()
  print("Restarting...")
  vim.cmd("bufdo bd!")
end
vim.api.nvim_create_user_command("Restart", Restart, {})
