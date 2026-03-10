local data_path = vim.fn.stdpath "data"

local M = {}

function M.bin(executable) return vim.fs.joinpath(data_path, "mason", "bin", executable) end

function M.package(...) return vim.fs.joinpath(data_path, "mason", "packages", ...) end

return M
