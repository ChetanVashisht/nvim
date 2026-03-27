return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'gruvbox'
      },
      sections = {
        lualine_c = {
          'filename',
          {
            function()
              return vim.b.test_output or ""
            end
          }
        },
        lualine_x = {},
        lualine_y = {},
      }
    })
  end,
}
