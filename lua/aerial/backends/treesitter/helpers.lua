local M = {}
local query_cache = {}

M.clear_query_cache = function()
  query_cache = {}
end

---@param node TSNode|TSNode[]|nil
---@return TSNode|nil
M.normalize_node = function(node)
  if type(node) == "table" then
    return node[#node]
  end
  return node
end

---@param start_node TSNode|TSNode[]
---@param end_node TSNode|TSNode[]
---@return aerial.Range
M.range_from_nodes = function(start_node, end_node)
  start_node = assert(M.normalize_node(start_node), "missing start node")
  end_node = assert(M.normalize_node(end_node), "missing end node")
  local row, col = start_node:start()
  local end_row, end_col = end_node:end_()
  return {
    lnum = row + 1,
    end_lnum = end_row + 1,
    col = col,
    end_col = end_col,
  }
end

M.get_buf_lang = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  local result = vim.treesitter.language.get_lang(ft)
  if result then
    return result
  else
    ft = vim.split(ft, ".", { plain = true })[1]
    return vim.treesitter.language.get_lang(ft) or ft
  end
end

M.get_query = function(lang)
  if not query_cache[lang] then
    query_cache[lang] = { query = vim.treesitter.query.get(lang, "aerial") }
  end

  return query_cache[lang].query
end

M.has_parser = function(lang)
  local installed = pcall(vim.treesitter.get_string_parser, "", lang)
  return installed
end

M.get_parser = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local success, parser = pcall(vim.treesitter.get_parser, bufnr)
  return success and parser or nil
end

return M
