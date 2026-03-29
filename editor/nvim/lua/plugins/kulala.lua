return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- prefix global keymaps com <leader>R
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",

      -- default environment (ex: dev, prod, staging)
      default_env = "dev",

      -- permite import de env do VSCode/rest-client se existir
      vscode_rest_client_environmentvars = true,

      -- executa curl com timeout (nil = sem timeout)
      request_timeout = nil,

      -- infer content-type automatic
      infer_content_type = true,
    },
  },
}
