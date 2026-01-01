
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            -- Load luv types when vim.uv is used
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "saghen/blink.cmp" },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- vim.lsp.enable("vue_ls")
      -- vim.lsp.config("vue_ls", {
      --   cmd = { "vue-language-server", "--stdio" },
      --   filetypes = { "vue" },
      --   capabilities = capabilities,
      --   root_dir = function(bufnr)
      --     return vim.fs.root(bufnr, { "package.json" })
      --   end
      -- })

      vim.lsp.config.tsserver = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        -- root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
        root_dir = function(bufno, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufno)
          local root = vim.fs.root(fname, { 'tsconfig.json', 'package.json', '.git' })
          return on_dir(root)
        end,

        on_init = function(client)
          -- Ensure the client sees the tsconfig.json paths
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
            typescript = {
              tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib'
            }
          })
        end,
      }
      vim.lsp.enable("tsserver")



      -- To Explore, looks promising
      -- vim.lsp.enable('ast_grep')
    end,
  },
}
