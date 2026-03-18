local trial = vim.api.nvim_create_augroup("trial", {clear = true})

vim.keymap.set({"n"}, "<leader>v", "<Cmd>source %<CR>", {silent = true})

local function statusLine(results)
  local file = vim.fn.expand("%:t")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local total = vim.fn.line("$")

  local percent = total > 0 and math.floor((line / total) * 100) or 0

  return string.format(
    " %s %%= %d:%d %d%%%% [%s]",
    file,
    line,
    col,
    percent,
    results
  )
end


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

    -- vim.cmd("!node --test --import tsx --test-reporter=dot " .. test_file)
    vim.fn.jobstart(
      {"node", "--test", "--import", "tsx", "--test-reporter=dot", test_file},
      {
        stdout_buffered = true,
        on_stdout = function (_, data)
          for l, line in ipairs(data) do
            if l == 1 then
              -- vim.api.nvim_buf_set_lines(30, -1, -1, false, { line })
              vim.o.statusline = statusLine(line)
            end
          end
        end
      }
    )
  end,
})
--

