return {
  "stevearc/aerial.nvim",
  event = "LazyFile",
  opts = function()
    return {
      -- Prioriza Treesitter para velocidade, fallback para LSP
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = {
        min_width = 28,
        default_direction = "right",
        placement = "window",
      },
      -- Mostra ícones do LSP (combina com o visual do LazyVim)
      show_guides = true,
      filter_kind = false, -- Mostra tudo (funções, variáveis, classes)
      on_attach = function(bufnr)
        -- Navegação rápida dentro do buffer atual sem abrir a lateral
        vim.keymap.set("n", "[[", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial: Previous Symbol" })
        vim.keymap.set("n", "]]", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial: Next Symbol" })
      end,
    }
  end,
  keys = {
    -- Toggle lateral (Keep cursor in place com !)
    { "<leader>cs", "<cmd>AerialToggle!<cr>", desc = "Aerial: Code Outline" },
    -- Navegação estilo "Floating Window" (Muito útil para Staff level reviews)
    { "<leader>ca", "<cmd>AerialNavToggle<cr>", desc = "Aerial: Quick Nav" },
  },
}
