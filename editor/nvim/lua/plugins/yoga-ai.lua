-- Yoga Files: minimal terminal AI integration

local function yoga_ai(mode)
  local input = vim.fn.input("yoga-ai " .. mode .. ": ")
  if input == nil or input == "" then
    return
  end

  local cmd = { "yoga-ai", mode, input }
  vim.fn.termopen(cmd)
end

return {
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>ah", function() yoga_ai("help") end, desc = "AI Help (yoga-ai)" },
      { "<leader>af", function() yoga_ai("fix") end, desc = "AI Fix (yoga-ai)" },
      { "<leader>ac", function() yoga_ai("code") end, desc = "AI Code (yoga-ai)" },
    },
  },
}
