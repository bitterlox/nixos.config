local lspconfig = require("lspconfig")
local neodev = require("neodev")

local capabilities = vim.g.helpers.lsp.make_capabilities(require("cmp_nvim_lsp"))
local make_on_attach_callback = vim.g.helpers.lsp.make_on_attach_callback(
  require("lsp-inlayhints"),
  require("telescope.builtin")
)

-- this must be called before setting up lua lsp
neodev.setup({})

lspconfig["lua_ls"].setup {
  cmd = { "lua-language-server" },
  capabilities = capabilities,
  on_attach = make_on_attach_callback(),
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      --        diagnostics = {
      --          -- Get the language server to recognize the `vim` global
      --          globals = { "vim" },
      --        },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }
}
