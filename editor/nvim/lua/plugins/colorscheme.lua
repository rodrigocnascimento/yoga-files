vim.opt.termguicolors = true

return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configurações antes de carregar o colorscheme
      vim.g.gruvbox_material_background = "hard" -- opções: 'soft', 'medium', 'hard'
      vim.g.gruvbox_material_foreground = "material" -- opções: 'material', 'mix', 'original'
      vim.g.gruvbox_material_better_performance = 1
      -- Ativa o tema
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}
