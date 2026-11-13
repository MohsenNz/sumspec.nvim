-- Dims a guard (// ... ->) once the language server attaches. The
-- server's semantic tokens are drawn over the syntax file's colours, so
-- each token inside a guard is drawn again, above them, as sumspecGuard.
-- What a guard is comes from the syntax region sumspecGuard; its words
-- (not, and, or, in) and its // keep their own colours.
local M = {}

local function group_name(bufnr)
  return "sumspec_guard_" .. bufnr
end

local function in_guard(bufnr, line, col)
  return vim.api.nvim_buf_call(bufnr, function()
    for _, id in ipairs(vim.fn.synstack(line + 1, col + 1)) do
      if vim.fn.synIDattr(id, "name") == "sumspecGuard" then
        return true
      end
    end
    return false
  end)
end

local function on_token(args)
  local token = args.data.token
  if token.type == "keyword" then
    return
  end
  if token.type == "operator" then
    local text = vim.api.nvim_buf_get_text(
      args.buf, token.line, token.start_col, token.line, token.end_col, {})[1]
    if text == "//" then
      return
    end
  end
  if in_guard(args.buf, token.line, token.start_col) then
    vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "sumspecGuard", {
      priority = vim.hl.priorities.semantic_tokens + 3,
    })
  end
end

function M.attach(bufnr)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  local group = vim.api.nvim_create_augroup(group_name(bufnr), { clear = true })
  vim.api.nvim_create_autocmd("LspTokenUpdate", {
    group = group,
    buffer = bufnr,
    callback = on_token,
  })
end

function M.detach(bufnr)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  pcall(vim.api.nvim_del_augroup_by_name, group_name(bufnr))
end

return M
