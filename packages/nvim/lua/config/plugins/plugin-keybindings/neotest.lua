local neotest = require("neotest")

  vim.keymap.set("n", "<leader>tt", function()
    neotest.run.run()
  end)
  -- tf - run test file
  vim.keymap.set("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%:p"))
  end)
  -- td - run tests in directory
  vim.keymap.set("n", "<leader>td", function()
    neotest.run.run(vim.fn.expand("%:p:h"))
  end)
  -- tp - test whole project
  vim.keymap.set("n", "<leader>tp", function()
    neotest.run.run(vim.fn.getcwd())
  end)
  -- tl - run whatever was ran last
  vim.keymap.set("n", "<leader>tl", function()
    neotest.run.run_last()
  end)
  -- tq - stop test
  vim.keymap.set("n", "<leader>tq", function()
    neotest.run.stop()
  end)

  -- to - (single) test output
  --vim.keymap.set("n", "<leader>tp", function()
  --  neotest.output.open({ enter = true })
  --end)
  -- to - test output panel
  vim.keymap.set("n", "<leader>to", function()
    neotest.output_panel.open()
  end)
  -- ts - summary
  vim.keymap.set("n", "<leader>ts", function()
    neotest.summary.open()
  end)
