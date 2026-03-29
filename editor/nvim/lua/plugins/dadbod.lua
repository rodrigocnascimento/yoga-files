return {
  {
    "tpope/vim-dadbod",
    opt = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    keys = {
      -- Abre/Fecha a interface do Banco (Database Toggle)
      { "<leader>bt", "<cmd>DBUIToggle<cr>", desc = "Database UI Toggle" },
      -- Abre a interface e foca nela
      { "<leader>bf", "<cmd>DBUIFindBuffer<cr>", desc = "Database Find Buffer" },
      -- Abre o último resultado da query
      { "<leader>bl", "<cmd>DBUILastQueryInfo<cr>", desc = "Database Last Query" },
    },
    init = function()
      -- Configurações globais do UI
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
    end,
    config = function()
      -- LISTA DE CONEXÕES: Basta editar os campos abaixo
      local connections = {
        {
          name = "HOMOLOG",
          user = "rodrigo.nascimento",
          pass = "mt36hyT3QTPi",
          host = "mysql-hml.cc1kjbmiekyg.us-east-1.rds.amazonaws.com",
          port = "3306",
          db = "pebmedapps",
        },
        {
          name = "PROD",
          user = "rodrigo.nascimento",
          pass = "Peb@9876@#",
          host = "mysql-prd-read.cc1kjbmiekyg.us-east-1.rds.amazonaws.com",
          port = "3306",
          db = "pebmedapps",
        },
      }

      local g_connections = {}
      for _, c in ipairs(connections) do
        -- Monta a URL automaticamente para o Dadbod
        local url = string.format("mysql://%s:%s@%s:%s/%s", c.user, c.pass, c.host, c.port, c.db)
        g_connections[c.name] = url
      end

      vim.g.dbs = g_connections
    end,
  },
}
