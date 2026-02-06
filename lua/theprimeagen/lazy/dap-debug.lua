return {
  {
    'mfussenegger/nvim-dap',
    config = function ()
      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "9229",
        executable = {
          command = "node",
          args = {"/Users/cgv/Documents/js-debug/src/dapDebugServer.js", "9229"},
        }
      }
      require('dap').set_log_level('TRACE')
      require("dap").configurations.typescript = {
        {
          name = "Launch project",
          type = "pwa-node",
          request = "launch",
          cwd = "${workspaceFolder}",
          runtimeArgs = { "debug" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach Program (pwa-node, select pid)",
          cwd = vim.fn.getcwd(),
          skipFiles = { "<node_internals>/**" },
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**"
          }
        },
        {
          type= "pwa-node",
          request= "launch",
          name= "Launch File",
          program= "${file}",
          cwd= "${workspaceFolder}"
        }
      }
    end
  }
}
