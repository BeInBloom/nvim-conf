local M = {}

function M.read(path)
  local file = io.open(path, "r")
  if not file then return nil end

  local content = file:read "*a"
  file:close()

  return content
end

function M.read_first(root, names)
  for _, name in ipairs(names) do
    local path = vim.fs.joinpath(root, name)
    local content = M.read(path)
    if content then return content, path end
  end
end

return M
