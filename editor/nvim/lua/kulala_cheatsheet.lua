-- kulala_cheatsheet.lua
-- Cheatsheet interativo Kulala.nvim
-- Abre com :lua require("kulala_cheatsheet").open()

local M = {}

M.open = function()
  -- cria buffer novo
  local buf = vim.api.nvim_create_buf(false, true) -- [listed=false, scratch=true]
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "filetype", "kulala_cheatsheet")
  vim.api.nvim_buf_set_option(buf, "modifiable", true)

  local lines = {
    "📝 Kulala.nvim Cheatsheet Interativo",
    string.rep("─", 50),
    "",
    "🚀 Execução de Requests",
    "  <leader>Rr → Run request atual",
    "  <leader>Ra → Run todos os requests no buffer",
    "  <leader>Rb → Abrir scratchpad",
    "  <leader>Rc → Copiar request como cURL",
    "  <leader>RC → Colar cURL como HTTP request",
    "  <leader>Ri → Inspecionar request atual",
    "",
    "🌍 Environments",
    "  :lua require('kulala').env_select() → Escolher dev/stage/prod",
    "",
    "📊 Resposta / Output",
    "  :lua require('kulala').response_show() → Mostrar último resultado",
    "  JSON formatado com jq (brew install jq)",
    "  Salvar resposta → :w no buffer de resposta",
    "",
    "🔧 Configuração LazyVim Keymaps",
    "  vim.keymap.set('n', '<leader>Rr', '<cmd>lua require(\"kulala\").run()<CR>', { desc = 'Run HTTP request' })",
    "  vim.keymap.set('n', '<leader>Ra', '<cmd>lua require(\"kulala\").run_all()<CR>', { desc = 'Run all requests' })",
    "  vim.keymap.set('n', '<leader>Rb', '<cmd>lua require(\"kulala\").scratchpad()<CR>', { desc = 'Open scratchpad' })",
    "  vim.keymap.set('n', '<leader>Rc', '<cmd>lua require(\"kulala\").copy()<CR>', { desc = 'Copy as cURL' })",
    "  vim.keymap.set('n', '<leader>RC', '<cmd>lua require(\"kulala\").from_curl()<CR>', { desc = 'Paste cURL as HTTP' })",
    "  vim.keymap.set('n', '<leader>Ri', '<cmd>lua require(\"kulala\").inspect()<CR>', { desc = 'Inspect request' })",
    "",
    "💡 Dicas Avançadas",
    "  - # @name NomeDoRequest → útil para run_all()",
    "  - {{TOKEN}}, {{API_URL}} → usar variables de http-client.env.json",
    "  - Export cURL → útil pra CI/CD pipelines",
    "  - Scratchpad → prototipar requests antes de versionar",
    "",
    "📁 Estrutura de Projeto Recomendada",
    "  project/",
    "  ├─ http-client.env.json",
    "  ├─ requests/",
    "  │   ├─ users.http",
    "  │   ├─ auth.http",
    "  │   └─ orders.http",
    "  └─ README.md",
    "",
    string.rep("─", 50),
    "🔹 Press q para fechar o cheatsheet",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- abrir em split flutuante
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- keymap pra fechar
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { nowait = true, noremap = true, silent = true })
end

return M
