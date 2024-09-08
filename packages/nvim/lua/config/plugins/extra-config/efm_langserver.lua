local lspconfig = require("lspconfig")

local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)

-- maybe pull code required for this into my own config
local prettier = require 'efmls-configs.formatters.prettier'
local eslint = require 'efmls-configs.linters.eslint'

local languages = {
  javascript = { eslint, prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  json = {
    {
      prefix = "jsonlint",
      lintCommand = "jsonlint -c",
      lintStdin = true,
      lintFormats = { 'line %l, col %c, found: %m' },
    }
  },
  yaml = {
    {
      prefix = "yamllint",
      lintCommand = "yamllint -s -f parsable ${INPUT}",
      lintStdin = true,
      -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
      -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
      lintFormats = { '%f:%l:%c: [%t%r] %m' },
    }
  },
  sh = {
    {
      formatCommand = "shellharden --transform ${INPUT}",
      formatStdin = false,
    },
    require('efmls-configs.formatters.shfmt'),
  },
  markdown = {
    {
      prefix = "markdownlint",
      lintCommand = "markdownlint parsable ${INPUT}",
      lintStdin = true,
      -- this is vim error format https://vimhelp.org/quickfix.txt.html#error-file-format
      -- tested with https://github.com/reviewdog/errorformat (which is used in efm-langserver)
      lintFormats = { '%f:%l %m' },
    }
  },
  lua = {
    {
      formatCommand = "stylua-c --color never --output-format unified ${INPUT}",
      formatStdin = false,
    },
  },
}

lspconfig["efm"].setup {
  cmd = { "efm-langserver" },
  capabilities = capabilities,
  on_attach = make_on_attach_callback(),
  filetypes = vim.tbl_keys(languages),
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  }
}
