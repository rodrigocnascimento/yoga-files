-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- ==========================================
-- Atalhos do CodeCompanion (Gemini e Ollama)
-- ==========================================

-- Abre um novo chat especificamente com o Gemini
map(
  { "n", "v" },
  "<leader>cg",
  "<cmd>CodeCompanionChat gemini<cr>",
  { desc = "CodeCompanion: Chat com Gemini", noremap = true, silent = true }
)

-- Abre um novo chat especificamente com o Ollama (usará o Qwen2.5 que configuramos)
map(
  { "n", "v" },
  "<leader>co",
  "<cmd>CodeCompanionChat ollama<cr>",
  { desc = "CodeCompanion: Chat com Ollama", noremap = true, silent = true }
)

-- Atalho útil para abrir/fechar (Toggle) o último chat ativo, não importando qual IA é
map(
  { "n", "v" },
  "<leader>cc",
  "<cmd>CodeCompanionChat Toggle<cr>",
  { desc = "CodeCompanion: Toggle Chat", noremap = true, silent = true }
)

-- Atalho para o menu de ações inline (explicar código, refatorar, etc)
map(
  { "n", "v" },
  "<leader>ca",
  "<cmd>CodeCompanionActions<cr>",
  { desc = "CodeCompanion: Ações", noremap = true, silent = true }
)

-- Mostra a branch no rodapé (Nativo, sem erro, sem conflito com Tmux)
vim.keymap.set("n", "<leader>B", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  if branch ~= "" then
    -- 'echo' é nativo e não depende de interface flutuante
    vim.api.nvim_echo({ { " Branch Atual: " .. branch, "Identifier" } }, true, {})
    -- Limpa a mensagem depois de 3 segundos
    vim.defer_fn(function()
      vim.api.nvim_command('echo ""')
    end, 3000)
  end
end, { desc = "Ver branch completa no rodapé" })

local km = vim.keymap.set
-- Run a single request
km("n", "<leader>Rr", "<cmd>lua require('kulala').run()<CR>", { desc = "Run HTTP request" })
-- Run all in current buffer
km("n", "<leader>Ra", "<cmd>lua require('kulala').run_all()<CR>", { desc = "Run all requests" })
-- Open scratchpad
km("n", "<leader>Rb", "<cmd>lua require('kulala').scratchpad()<CR>", { desc = "Open HTTP scratchpad" })
-- Copy as curl
km("n", "<leader>Rc", "<cmd>lua require('kulala').copy()<CR>", { desc = "Copy request as cURL" })
-- Paste cURL into .http
km("n", "<leader>RC", "<cmd>lua require('kulala').from_curl()<CR>", { desc = "Paste cURL as HTTP" })
-- Inspect current request
km("n", "<leader>Ri", "<cmd>lua require('kulala').inspect()<CR>", { desc = "Inspect HTTP request" })
vim.keymap.set("n", "<leader>Kh", ":lua require('kulala_cheatsheet').open()<CR>", { desc = "Open Kulala Cheatsheet" })

-- debugger
local dap = require("dap")

vim.keymap.set("n", "<leader>db", function()
  dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
  dap.continue()
end, { desc = "Continue" })
vim.keymap.set("n", "<leader>di", function()
  dap.step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function()
  dap.step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dO", function()
  dap.step_out()
end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dr", function()
  dap.repl.open()
end, { desc = "Open REPL" })
