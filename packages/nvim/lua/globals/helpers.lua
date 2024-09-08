local lsp_keybindings = function(builtin)
  return function(client, bufnr)
    local bufopts = { remap = false, buffer = bufnr }

    -- keybinding to disable prettier; it works, but since we don't have
    -- prettier on save it's not needed; also by doing this we also stop
    -- eslint which may not be what we want
    --
    -- vim.keymap.set("n", "epr", function()
    --   local clients = vim.lsp.get_clients()
    --   for _, _client in pairs(clients) do
    --     if _client.name == "efm" then
    --       vim.lsp.stop_client(_client.id)
    --       break
    --     end
    --   end
    --   require("lspconfig")["efm"].setup({
    --     setting = {
    --       languages = {
    --         javascript = {},
    --         typescript = {},
    --         typescriptreact = {},
    --       },
    --     }
    --   })
    -- end, bufopts)
    -- if client == "efm" then
    -- print("registered keyb")
    -- end

    --vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "dp", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "dn", vim.diagnostic.goto_next, bufopts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, bufopts)

    vim.keymap.set("n", "gdc", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "H", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)

    -- supercharging with telescope
    vim.keymap.set("n", "<leader>d", builtin.diagnostics, bufopts)

    -- there's also incoming calls and outgoing calls if i like that
    vim.keymap.set("n", "<leader>rr", builtin.lsp_references, bufopts)
    vim.keymap.set("n", "<leader>ic", builtin.lsp_incoming_calls, bufopts)
    vim.keymap.set("n", "<leader>oc", builtin.lsp_outgoing_calls, bufopts)
    vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
    vim.keymap.set("n", "gtd", builtin.lsp_type_definitions, bufopts)
    vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
  end
end

vim.g.helpers = {
  lsp = {
    make_on_attach_callback = function(inlayhints, builtin)
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          inlayhints.on_attach(client, bufnr, false)
        end,
      })
      return function(client, bufnr)
        local register_keybindings = lsp_keybindings(builtin)
        register_keybindings(client, bufnr)
        --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        --vim.keymap.set('n', '<leader>wl', function()
        --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        --end, bufopts)

        -- disable LSP formatting
        --vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
      end
    end,
    make_capabilities = function(nvim_cmp_lsp)
      return nvim_cmp_lsp.default_capabilities()
    end
  }
}
