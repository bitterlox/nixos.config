{ helpers, ... }: {

  # configuring diagnostic stuff #
  # https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization #

  diagnostics = {
    virtual_text = false;
    signs = true;
    underline = true;
    update_in_insert = false;
    severity_sort = false;
  };

  opts.updatetime = 250;

  # enable diagnostic hover window #
  autoCmd = [{
    pattern = "*";
    event = [ "CursorHold" "CursorHoldI" ];
    command = "lua vim.diagnostic.open_float(nil, {focus=false})";
    # callback = helpers.mkRaw ''
    #   function ()
    #     vim.diagnostic.open_float(nil, {focus=false})
    #   end'';
  }];

}
