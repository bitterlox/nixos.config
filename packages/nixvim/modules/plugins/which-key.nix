args@{
  config,
  helpers,
  lib,
  options,
  specialArgs,
}:
{
  plugins.which-key.enable = true;
  keymaps = [
    {
      mode = [
        "v"
        "i"
      ];
      key = "<leader>?";
      action = ''
        function()
          require("which-key").show({ global = false })
        end,
      '';
      options.desc = "Buffer Local Keymaps (which-key)";
    }
  ];
}
