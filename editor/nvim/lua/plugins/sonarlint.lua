return {
  {
    "sonarlint.nvim",
    -- Como o repositório é do GitLab, precisamos da URL completa
    url = "https://gitlab.com/schrieveslaach/sonarlint.nvim.git",
    ft = { "typescript", "javascript", "dockerfile", "python" },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- O Mason instala os arquivos em ~/.local/share/nvim/mason/
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      require("sonarlint").setup({
        server = {
          cmd = {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            -- Como você trabalha com TypeScript/Backend, use estes JARs:
            vim.fn.expand(mason_path .. "/share/sonarlint-analyzers/sonarts.jar"),
            vim.fn.expand(mason_path .. "/share/sonarlint-analyzers/sonarjs.jar"),
            -- Se precisar de Docker para seus microserviços:
            vim.fn.expand(mason_path .. "/share/sonarlint-analyzers/sonariac.jar"),
          },
        },
        filetypes = {
          "typescript",
          "javascript",
          "dockerfile",
        },
      })
    end,
  },
}
