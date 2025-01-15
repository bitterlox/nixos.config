args@{
  config,
  helpers,
  lib,
  options,
  specialArgs,
}:
{
  plugins.codecompanion.enable = true;

  plugins.codecompanion.settings = {
    strategies = {
      chat = {
        adapter = "anthropic";
      };
      inline = {
        adapter = "anthropic";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<C-a>";
      action = "<cmd>CodeCompanionActions<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<LocalLeader>a";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<LocalLeader>a";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "v";
      key = "ga";
      action = "<cmd>CodeCompanionChat Add<cr>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  extraConfigLua = ''
    vim.cmd([[cab cc CodeCompanion]])
  '';
}
