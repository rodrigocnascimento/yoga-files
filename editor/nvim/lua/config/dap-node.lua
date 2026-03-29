local dap = require("dap")

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
    "9229",
  },
}

dap.configurations.javascript = {
  {
    name = "Attach Node",
    type = "node2",
    request = "attach",
    port = 9229,
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**" },
  },
}

dap.configurations.typescript = dap.configurations.javascript
