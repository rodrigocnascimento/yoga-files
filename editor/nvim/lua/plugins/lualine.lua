return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Localizamos a seção onde a branch mora (lualine_b)
    -- Se por algum motivo ela não existir, criamos uma vazia para não dar erro
    opts.sections.lualine_b = {
      {
        "branch",
        fmt = function(str)
          -- A lógica de Staff: Curto na barra, completo no popup
          if str:len() > 20 then
            return str:sub(1, 20) .. ".."
          end
          return str
        end,
      },
    }
  end,
}
