local M = {}

function M.prompt_args(prompt)
  local value = vim.trim(vim.fn.input(prompt or "Arguments: "))
  if value == "" then return {} end
  return vim.split(value, "%s+", { trimempty = true })
end

return M
