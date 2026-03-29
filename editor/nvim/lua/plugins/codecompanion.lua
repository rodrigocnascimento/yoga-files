return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
  },
  -- Trocamos o 'config = function()...' pelo 'opts = {}'
  opts = {
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
    },
    adapters = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "ollama",
          schema = {
            model = {
              default = "qwen2.5-coder:7b-instruct-q5_K_M",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          name = "gemini", -- Adicionei o nome aqui também por consistência
          schema = {
            model = {
              default = "gemini-3-pro", -- Troque se precisar
            },
          },
        })
      end,
    },
  },
}
