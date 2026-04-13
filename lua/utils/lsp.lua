local M = {}

local function code_action_params(bufnr, kind)
  return {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
    },
    context = { only = { kind }, diagnostics = {} },
  }
end

local function get_client(bufnr, client_name)
  if not client_name then return nil end
  return vim.lsp.get_clients({ bufnr = bufnr, name = client_name })[1]
end

local function run_command(bufnr, client, action)
  local command = action.command
  if not client or not command then
    return
  end

  if type(command) == "table" then
    client:exec_cmd(command, { bufnr = bufnr })
  elseif type(command) == "string" then
    client:exec_cmd(action, { bufnr = bufnr })
  end
end

local function apply_action(bufnr, client, action)
  local encoding = client and client.offset_encoding or "utf-16"
  if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, encoding) end
  run_command(bufnr, client, action)
end

function M.apply_code_action(bufnr, kind, client_name, timeout_ms)
  bufnr = bufnr or 0

  local selected_client = get_client(bufnr, client_name)
  if client_name and not selected_client then return false end

  local responses =
    vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", code_action_params(bufnr, kind), timeout_ms or 1000)
  local applied = false

  for client_id, response in pairs(responses or {}) do
    local client = selected_client or vim.lsp.get_client_by_id(client_id)
    for _, action in ipairs(response.result or {}) do
      apply_action(bufnr, client, action)
      applied = true
    end
  end

  return applied
end

function M.disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

function M.organize_imports(bufnr, client_name, timeout_ms)
  return M.apply_code_action(bufnr, "source.organizeImports", client_name, timeout_ms)
end

function M.organize_imports_on_save(client_name, timeout_ms)
  return function(args) M.organize_imports(args.buf, client_name, timeout_ms) end
end

function M.map_organize_imports(bufnr, client_name, desc)
  vim.keymap.set(
    "n",
    "<Leader>oi",
    function() M.organize_imports(bufnr, client_name, 1000) end,
    { buffer = bufnr, desc = desc or "Organize imports" }
  )
end

return M
