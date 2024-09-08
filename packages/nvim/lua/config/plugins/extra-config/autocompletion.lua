  -- Set up nvim-cmp
local cmp = require'cmp'

local generate_keybindings = cmp.mapping.preset.insert({
    -- next item
    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    -- previous item
    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    -- scroll back docs
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    -- scroll forward docs
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- start completion
    ["<C-Space>"] = cmp.mapping.complete(),
    -- stop completion
    ["<C-e>"] = cmp.mapping.abort(),
    -- accept selected completion suggestion (also enter key works for this)
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  })

cmp.setup({
  snippet = {
    -- specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  experimental = {
      ghost_text = true,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = generate_keybindings,
-- more completion sources: https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'cmp-plugins' }
  }, {
    { name = 'buffer' },
  })
})
	-- Set configuration for specific filetype.
      --cmp.setup.filetype('gitcommit', {
      --  sources = cmp.config.sources({
      --    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --  }, {
      --    { name = 'buffer' },
      --  })
--})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
