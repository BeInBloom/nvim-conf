local astrocore = require "astrocore"
local file = require "utils.file"

local php_cs_fixer_files = {
  ".php-cs-fixer.php",
  ".php-cs-fixer.php.dist",
  ".php-cs-fixer.json",
  ".php-cs-fixer.dist.json",
}

local phpstan_files = { "phpstan.neon", "phpstan.neon.dist" }

local function get_php_cs_fixer(null_ls)
  return null_ls.builtins.formatting.phpcsfixer or null_ls.builtins.formatting.php_cs_fixer
end

local function current_root() return require("null-ls.utils").get_root() end

local function has_file(root, names)
  if not root or root == "" then return false end
  for _, name in ipairs(names) do
    if vim.uv.fs_stat(vim.fs.joinpath(root, name)) then return true end
  end
  return false
end

local function is_laravel(root)
  if not root or root == "" then return false end
  if vim.uv.fs_stat(vim.fs.joinpath(root, "artisan")) then return true end

  local composer_json = file.read(vim.fs.joinpath(root, "composer.json"))
  return composer_json and composer_json:find('"laravel/framework"', 1, true) ~= nil or false
end

local function phpstan_level(root)
  local content = file.read_first(root, phpstan_files)
  local level = content and content:match "level%s*=%s*(%d+)"
  return level and tonumber(level) or 8
end

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    local sources = {}
    local php_cs_fixer = get_php_cs_fixer(null_ls)

    table.insert(
      sources,
      null_ls.builtins.formatting.pint.with {
        condition = function() return is_laravel(current_root()) end,
      }
    )

    if php_cs_fixer then
      table.insert(
        sources,
        php_cs_fixer.with {
          condition = function()
            local root = current_root()
            return not is_laravel(root) and has_file(root, php_cs_fixer_files)
          end,
        }
      )
    end

    table.insert(
      sources,
      null_ls.builtins.diagnostics.phpstan.with {
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity.WARN end,
        condition = function(utils) return utils.root_has_file(phpstan_files) or utils.root_has_file "composer.json" end,
        extra_args = function()
          local root = current_root()
          return root and { "--level=" .. phpstan_level(root) } or {}
        end,
      }
    )

    opts.sources = astrocore.list_insert_unique(opts.sources or {}, sources)
  end,
}
