---------- Lazy setup --------------
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "theprimeagen.lazy",
    change_detection = { notify = false }
})

--------------------------------------

-- local augroup = vim.api.nvim_create_augroup
-- local ThePrimeagenGroup = augroup('ThePrimeagen', {})
--
-- local yank_group = augroup('HighlightYank', {})
