# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  plugins.neotest.enable = true;

  # had this lua code in the old config, not sure what it was for
  # local neotest_ns = vim.api.nvim_create_namespace("neotest")
  # vim.diagnostic.config({
  #   virtual_text = {
  #     format = function(diagnostic)
  #       local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
  #       return message
  #     end,
  #   },
  # }, neotest_ns)

  keymaps = [
    ## tt - run nearest test
    {
      mode = "n";
      key = "<leader>tt";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.run()
        end
      '';
    }
    ## tf - run test in file
    {
      mode = "n";
      key = "<leader>tf";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.expand('%:p'))
        end
      '';
    }
    ## td - run tests in directory
    {
      mode = "n";
      key = "<leader>td";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.expand('%:p:h'))
        end
      '';
    }
    ## tp - test whole project
    {
      mode = "n";
      key = "<leader>ta";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.getcwd())
        end
      '';
    }
    ## tl - run whatever was ran last
    {
      mode = "n";
      key = "<leader>tl";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.run_last()
        end
      '';
    }
    ## tq - stop test
    {
      mode = "n";
      key = "<leader>tq";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').run.stop()
        end
      '';
    }
    ## tp - (single) test output
    {
      mode = "n";
      key = "<leader>tp";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').output.open({ enter = true })
        end
      '';
    }
    ## to - test output panel
    {
      mode = "n";
      key = "<leader>to";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').output_panel.open()
        end
      '';
    }
    ## ts - summary
    {
      mode = "n";
      key = "<leader>ts";
      action = lib.nixvim.mkRaw ''
        function()
          require('neotest').summary.open()
        end
      '';
    }
  ];
}
