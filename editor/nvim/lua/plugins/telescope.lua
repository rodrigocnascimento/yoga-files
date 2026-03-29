return {
  "nvim-telescope/telescope.nvim",
  -- Usamos uma função para manter as configs originais do LazyVim
  opts = function(_, opts)
    -- 1. Garante que o buscador de arquivos mostre arquivos ocultos (.)
    opts.pickers = opts.pickers or {}
    opts.pickers.find_files = {
      hidden = true,
      -- Opcional: não mostrar a pasta .git (ocupa muito espaço na busca)
      file_ignore_patterns = { ".git/" },
    }

    -- 2. Garante que o Live Grep (busca de texto) também olhe dentro de arquivos ocultos
    opts.defaults = opts.defaults or {}
    opts.defaults.vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- A mágica acontece aqui
      "--glob",
      "!**/.git/*",
    }
  end,
}
