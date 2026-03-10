local M = {}

function M.detector(markers)
  return function(path) return vim.fs.root(path, markers) or vim.uv.cwd() end
end

return M
