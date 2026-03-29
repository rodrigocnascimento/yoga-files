require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Importa o extra de markdown aqui:
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.import" },
  },
})
