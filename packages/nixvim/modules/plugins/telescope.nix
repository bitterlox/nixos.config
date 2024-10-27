arg@{ config, helpers, lib, options, pkgs, specialArgs }: {

  # TODO: enable native sorter to improve performance
  # maybe missing leader d keymap to lsp stuff

  runtimeBinaries = [ pkgs.ripgrep pkgs.fd ];

  plugins.telescope.enable = true;

  # plugins.telescope.settings.defaults.vimgrep_arguments =
  #   helpers.listToUnkeyedAttrs [
  #     "${lib.getExe pkgs.ripgrep}"
  #     "--color=never"
  #     "--no-heading"
  #     "--with-filename"
  #     "--line-number"
  #     "--column"
  #     "--smart-case"
  #   ];

  plugins.telescope.settings.pickers = {
    find_files.theme = "dropdown";
    git_files.theme = "dropdown";
    grep_string.theme = "dropdown";
    live_grep.theme = "dropdown";
    keymaps.theme = "dropdown";
    diagnostics.theme = "dropdown";
    lsp_references.theme = "dropdown";
    lsp_incoming_calls.theme = "dropdown";
    lsp_outgoing_calls.theme = "dropdown";
    lsp_definitions.theme = "dropdown";
    lsp_type_definitions.theme = "dropdown";
    lsp_implementations.theme = "dropdown";
  };

  plugins.telescope.keymaps = {
    "<leader>pf" = {
      mode = "n";
      action = "find_files";
    };
    "<leader>gf" = {
      mode = "n";
      action = "git_files";
    };
    "<leader>fg" = {
      mode = "n";
      action = ''grep_string({ search = vim.fn.input(" grep > ") })'';
    };
    "<leader>lg" = {
      mode = "n";
      action = "live_grep";
    };
    "<leader>kb" = {
      mode = "n";
      action = "keymaps";
    };
  };

}
