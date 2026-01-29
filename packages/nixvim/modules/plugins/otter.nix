# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  plugins.otter.enable = true;
  plugins.otter.settings = {
    buffers.set_filetype = true;
    lsp.diagnostic_update_events = [
      "BufWritePost"
      "InsertLeave"
      "TextChanged"
    ];
    verbose = {
      no_code_found = true;
    };
  };

  plugins.otter.autoActivate = false;

  keymaps = [
    # leader mappings
    {
      mode = "n";
      key = "<leader>oo";
      action = lib.nixvim.mkRaw ''
        function ()
          local function has_otter_lsp()
            for _, client in ipairs(vim.lsp.get_clients({bufnr = 0})) do
              if client.name:match("^otter%-ls") then
                return true, client.name
              end
            end
            return false, nil
          end
          local active, name = has_otter_lsp()
          if active then
            require('otter').deactivate();
            print("deactivated otter-ls");
          else
            require('otter').activate();
            print("activated otter-ls");
          end
        end
      '';
    }
  ];

}
