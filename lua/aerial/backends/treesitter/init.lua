local backends = require("aerial.backends")
local config = require("aerial.config")
local helpers = require("aerial.backends.treesitter.helpers")
local util = require("aerial.backends.util")

local M = {}

---@param bufnr? integer
---@return boolean
---@return string? msg
M.is_supported = function(bufnr)
  local lang = helpers.get_buf_lang(bufnr)
  if not helpers.has_parser(lang) then
    return false, string.format("No treesitter parser for %s", lang)
  end
  if helpers.get_query(lang) == nil then
    return false, string.format("No queries defined for '%s'", lang)
  end
  return true, nil
end

---@param bufnr integer
---@param lang string
---@param query vim.treesitter.Query
---@param syntax_tree? TSTree
local function set_symbols_from_treesitter(bufnr, lang, query, syntax_tree)
  if not syntax_tree then
    backends.set_symbols(
      bufnr,
      {},
      { backend_name = "treesitter", lang = lang, syntax_tree = syntax_tree }
    )
    return
  end

  local extensions = require("aerial.backends.treesitter.extensions")
  local get_node_text = vim.treesitter.get_node_text
  local include_kind = config.get_filter_kind_map(bufnr)
  local items = {}
  local stack = {}
  local ext = extensions[lang]

  for _, matches, metadata in query:iter_matches(syntax_tree:root(), bufnr) do
    local match = vim.tbl_extend("force", {}, metadata)
    for id, node in pairs(matches) do
      match = vim.tbl_extend("keep", match, {
        [query.captures[id]] = {
          metadata = metadata[id],
          node = helpers.normalize_node(node),
        },
      })
    end

    local name_match = match.name or {}
    local selection_match = match.selection or {}
    local symbol_node = helpers.normalize_node((match.symbol or match.type or {}).node)
    if not symbol_node then
      goto continue
    end

    local start_node = helpers.normalize_node((match.start or {}).node) or symbol_node
    local end_node = helpers.normalize_node((match["end"] or {}).node) or start_node
    local parent_item, parent_node, level = ext.get_parent(stack, match, symbol_node)
    if symbol_node == parent_node then
      goto continue
    end

    local kind = match.kind
    if not kind then
      vim.api.nvim_echo(
        { { string.format("Missing 'kind' metadata in query file for language %s", lang) } },
        true,
        { err = true }
      )
      break
    elseif not vim.lsp.protocol.SymbolKind[kind] then
      vim.api.nvim_echo({
        {
          string.format("Invalid 'kind' metadata '%s' in query file for language %s", kind, lang),
        },
      }, true, { err = true })
      break
    end

    local range = helpers.range_from_nodes(start_node, end_node)
    local selection_range
    if selection_match.node then
      local node = helpers.normalize_node(selection_match.node)
      selection_range = helpers.range_from_nodes(node, node)
    end

    local name
    if name_match.node then
      local node = helpers.normalize_node(name_match.node)
      name = get_node_text(node, bufnr, { metadata = name_match.metadata }) or "<parse error>"
      if not selection_range then
        selection_range = helpers.range_from_nodes(node, node)
      end
    else
      name = "<Anonymous>"
    end

    local scope
    if match.scope and match.scope.node then
      scope = get_node_text(helpers.normalize_node(match.scope.node), bufnr, { metadata = match.scope.metadata })
    else
      scope = match.scope
    end

    local item = {
      kind = kind,
      name = name,
      level = level,
      lnum = range.lnum,
      end_lnum = range.end_lnum,
      col = range.col,
      end_col = range.end_col,
      parent = parent_item,
      selection_range = selection_range,
      scope = scope,
    }

    if ext.postprocess(bufnr, item, match) == false or not include_kind[item.kind] then
      goto continue
    end

    local ctx = {
      backend_name = "treesitter",
      lang = lang,
      syntax_tree = syntax_tree,
      match = match,
    }
    if config.post_parse_symbol and config.post_parse_symbol(bufnr, item, ctx) == false then
      goto continue
    end

    if item.parent then
      if not item.parent.children then
        item.parent.children = {}
      end
      table.insert(item.parent.children, item)
    else
      table.insert(items, item)
    end
    table.insert(stack, { node = symbol_node, item = item })

    ::continue::
  end

  ext.postprocess_symbols(bufnr, items)
  backends.set_symbols(
    bufnr,
    items,
    { backend_name = "treesitter", lang = lang, syntax_tree = syntax_tree }
  )
end

local function get_lang_and_query(bufnr)
  local parser = helpers.get_parser(bufnr)
  if not parser then
    backends.set_symbols(bufnr, {}, { backend_name = "treesitter", lang = "unknown" })
    return
  end
  local lang = parser:lang()
  local query = helpers.get_query(lang)
  if not query then
    backends.set_symbols(bufnr, {}, { backend_name = "treesitter", lang = lang })
    return
  end
  return parser, query
end

M.fetch_symbols_sync = function(bufnr)
  bufnr = bufnr or 0
  local parser, query = get_lang_and_query(bufnr)
  if not parser or not query then
    return
  end
  local lang = parser:lang()
  local syntax_tree = parser:parse()[1]
  set_symbols_from_treesitter(bufnr, lang, query, syntax_tree)
end

M.fetch_symbols = function(bufnr)
  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  local parser, query = get_lang_and_query(bufnr)
  if not parser or not query then
    return
  end
  local lang = parser:lang()
  local syntax_trees = parser:parse(nil, function(err, parsed)
    if err then
      vim.api.nvim_echo(
        { { string.format("Error parsing buffer: %s", err) } },
        true,
        { err = true }
      )
      backends.set_symbols(bufnr, {}, { backend_name = "treesitter", lang = lang })
      return
    end

    assert(parsed)
    set_symbols_from_treesitter(bufnr, lang, query, parsed[1])
  end)
  if syntax_trees then
    set_symbols_from_treesitter(bufnr, lang, query, syntax_trees[1])
  end
end

M.attach = function(bufnr)
  util.add_change_watcher(bufnr, "treesitter")
end

M.detach = function(bufnr)
  util.remove_change_watcher(bufnr, "treesitter")
end

return M
