# this is a nixvim module
args@{
  config,
  helpers,
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
      action = helpers.mkRaw ''
        function()
          require('neotest').run.run()
        end
      '';
    }
    ## tf - run test in file
    {
      mode = "n";
      key = "<leader>tf";
      action = helpers.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.expand('%:p'))
        end
      '';
    }
    ## td - run tests in directory
    {
      mode = "n";
      key = "<leader>td";
      action = helpers.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.expand('%:p:h'))
        end
      '';
    }
    ## tp - test whole project
    {
      mode = "n";
      key = "<leader>ta";
      action = helpers.mkRaw ''
        function()
          require('neotest').run.run(vim.fn.getcwd())
        end
      '';
    }
    ## tl - run whatever was ran last
    {
      mode = "n";
      key = "<leader>tl";
      action = helpers.mkRaw ''
        function()
          require('neotest').run.run_last()
        end
      '';
    }
    ## tq - stop test
    {
      mode = "n";
      key = "<leader>tq";
      action = helpers.mkRaw ''
        function()
          require('neotest').run.stop()
        end
      '';
    }
    ## tp - (single) test output
    {
      mode = "n";
      key = "<leader>tp";
      action = helpers.mkRaw ''
        function()
          require('neotest').output.open({ enter = true })
        end
      '';
    }
    ## to - test output panel
    {
      mode = "n";
      key = "<leader>to";
      action = helpers.mkRaw ''
        function()
          require('neotest').output_panel.open()
        end
      '';
    }
    ## ts - summary
    {
      mode = "n";
      key = "<leader>ts";
      action = helpers.mkRaw ''
        function()
          require('neotest').summary.open()
        end
      '';
    }
  ];
}
