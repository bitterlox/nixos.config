local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)

lspconfig["gopls"].setup {
  capabilities = capabilities,
  on_attach = make_on_attach_callback(),
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      -- general settings
      -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
      gofumpt = true,
      analyses = {
        -- analyzers settings
        -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        fieldalignment = true,
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        unusedvariable = true,
      },
      -- use linters from staticcheck.io
      staticcheck = true,
      -- diagnostics reported by the gc_details command
      annotations = {
        bounds = true,
        escape = true,
        inline = true,
        ["nil"] = true,
      },
      hints = {
        -- inlayhints settings
        -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  }
}
