return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- 1. Configuração do Adaptador (Mason)
      require("dap-vscode-js").setup({
        node_path = "node",
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = { "pwa-node", "node-terminal", "node" },
        debugger_cmd = { "js-debug-adapter" },
        -- Campos que o warning pediu (opcionais, mas bons para debug)
        log_file_path = vim.fn.stdpath("cache") .. "/dap_vscode_js.log",
        log_file_level = vim.log.levels.ERROR,
        log_console_level = vim.log.levels.ERROR,
      })

      -- 2. Registrar os tipos de arquivos para o DAP
      -- Isso permite que o DAP saiba que deve procurar configs de launch.json
      -- para esses tipos de arquivos específicos.
      local js_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      for _, language in ipairs(js_languages) do
        dap.configurations[language] = dap.configurations[language] or {}
      end

      -- 3. Configuração do UI
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- 4. O "Pulo do Gato" para caminhos não-padrão
      -- Como seu arquivo está em src/.vscode e não na raiz, o Neovim pode não achá-lo sozinho.
      -- Em vez de load_launchjs (deprecated), adicionamos o caminho à lista de busca:
      require("dap.ext.vscode").type_to_filetypes = {
        ["pwa-node"] = js_languages,
        ["node"] = js_languages,
      }
    end,
  },
}
