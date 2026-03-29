return {
  {
    -- UI para revisar diff local (tipo PR): arquivos + hunks + historico
    "sindrets/diffview.nvim",

    -- Diffview usa plenary; em muitos setups ja existe, mas deixamos explicito
    dependencies = { "nvim-lua/plenary.nvim" },

    -- Carrega o plugin so quando voce chamar esses comandos
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },

    -- Atalhos (leader = Space no LazyVim)
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },

      -- Historico do arquivo atual (% = arquivo atual)
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
    },
  },
}
