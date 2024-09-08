local lspconfig = require("lspconfig")

local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)

lspconfig["rust_analyzer"].setup {
  cmd = { "rust-analyzer" },
  capabilities = capabilities,
  on_attach = make_on_attach_callback(),
  settings = {
    ["rust_analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  }
}
