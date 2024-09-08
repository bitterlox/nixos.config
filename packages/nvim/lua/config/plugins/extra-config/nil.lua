local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)


lspconfig["nil_ls"].setup {
  capabilities        = capabilities,
  on_attach           = make_on_attach_callback(),
  cmd                 = { "nil" },
  filetypes           = { "nix" },
  root_dir            = util.root_pattern(".nixd.json", "flake.nix", ".git"),
  single_file_support = true,
  settings            = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" }
      }
    }
  }
}
