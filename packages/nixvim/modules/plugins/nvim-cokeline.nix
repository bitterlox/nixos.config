# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }:
let
  luaconfig = pkgs.writeTextFile {
    name = "nvim-cokeline.lua";
    text = ''
      local cokeline = require("cokeline")
      local get_hex = require("cokeline.hlgroups").get_hl_attr

      cokeline.setup({
        default_hl = {
          fg = function(buffer)
            return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg")
          end,
          bg = get_hex("ColorColumn", "bg"),
        },

        components = {
          {
            text = "｜",
            fg = function(buffer)
              return buffer.is_modified and yellow or green
            end,
          },
          {
            text = function(buffer)
              return buffer.devicon.icon .. " "
            end,
            fg = function(buffer)
              return buffer.devicon.color
            end,
          },
          {
            text = function(buffer)
              return buffer.index .. ": "
            end,
          },
          {
            text = function(buffer)
              return buffer.unique_prefix
            end,
            fg = get_hex("Comment", "fg"),
            style = "italic",
          },
          {
            text = function(buffer)
              return buffer.filename .. " "
            end,
            style = function(buffer)
              return buffer.is_focused and "bold" or nil
            end,
          },
          {
            text = " ",
          },
        },
      })
    '';
  };
in {

  extraPlugins = [{
    plugin = pkgs.vimPlugins.nvim-cokeline;
    config = "luafile ${luaconfig}";
  }];

  keymaps = [
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<Plug>(cokeline-focus-prev)";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<Tab>";
      action = "<Plug>(cokeline-focus-next)";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<Leader>p";
      action = "<Plug>(cokeline-switch-prev)";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<Leader>n";
      action = "<Plug>(cokeline-switch-next)";
      options.silent = true;
    }
  ];
  #for i = 1, 9 do
  #  vim.keymap.set("n", ("<F%s>"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), { silent = true })
  #  vim.keymap.set("n", ("<Leader>%s"):format(i), ("<Plug>(cokeline-switch-%s)"):format(i), { silent = true })
  #end

}
