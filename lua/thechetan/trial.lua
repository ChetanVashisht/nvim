local trial = vim.api.nvim_create_augroup("trial", {clear = true})

vim.keymap.set({"n"}, "<leader>v", "<Cmd>source %<CR>", {silent = true})

vim.api.nvim_create_autocmd({"BufWritePost"}, {
  desc = "For TDDing the flow",
  pattern = {"*.ts", "*.spec.ts"},
  group = trial,
  callback = function ()
    local file = vim.fn.expand("%")
    local test_file

    if file:match("%.spec.ts$") then
      test_file = file
    else
      test_file = file:gsub("%.ts$", ".spec.ts")
    end
    vim.b.test_output = ""

    vim.fn.jobstart(
      {"node", "--test", "--import", "tsx", "--test-reporter=dot", test_file},
      {
        stdout_buffered = true,
        on_stdout = function (_, data)
          for l, line in ipairs(data) do
            if l == 1 then
              vim.b.test_output = (vim.b.test_output or "") .. line
            end
          end
        end
      }
    )
  end,
})


