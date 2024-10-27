# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  keymaps = [
    # leader mappings
    {
      mode = "n";
      key = "<leader>wq";
      action = helpers.mkRaw "vim.cmd.wq";
    }
    {
      mode = "n";
      key = "<leader>cc";
      action = helpers.mkRaw "vim.cmd.close";
    }

    {
      mode = "n";
      key = "<leader>nrw";
      action = helpers.mkRaw "vim.cmd.Ex";
    }

    # move visually highlighted text
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
    }
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
    }
    # todo: should add the equivalent for H & L mapping to < and >

    # when using J keep the cursor at the start of the line
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
    }

    # C_d and C_u (half page jumps) keep the cursor in the middle
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }

    # when jumping to search matches, keep cursor in the middle
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }

    # paste without losing paste buffer
    {
      mode = "x";
      key = "<leader>p";
      action = ''"_dP'';
    }
    {
      mode = "n";
      key = "<leader>y";
      action = ''"+y'';
    }

    # yank to system clipboard | not sure that i like it or that i works as intended
    #{ mode="n"; key="<leader>y"; action ="\"+y";}
    #{ mode="v"; key="<leader>y"; action ="\"+y";}
    #{ mode="n"; key="<leader>Y"; action ="\"+Y";}

    # never press capital Q?
    {
      mode = "n";
      key = "Q";
      action = "<nop>";
    }

    # tmux switch project
    # { mode="n"; key="<C-f>"; action ="<cmd> silent !tmux neww tmux-sessionizer<CR>";}

    # quickfix list mappings
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>cnext<CR>zz";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>cprev<CR>zz";
    }

    # location list mappings
    {
      mode = "n";
      key = "<leader>k";
      action = "<cmd>lprev<CR>zz";
    }
    {
      mode = "n";
      key = "<leader>j";
      action = "<cmd>cprev<CR>zz";
    }

    # search & replace for file under cursor
    {
      mode = "n";
      key = "<leader>s";
      action = helpers.mkRaw
        "[[:%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>]]";
    }
    # make file executable
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>!chmod +x %<CR>";
      options.silent = true;
    }

    # {
    #   mode = "n";
    #   key = "<leader>f";
    #   action = "<C_O>";
    # }

    # {
    #   mode = "n";
    #   key = "<leader>p";
    #   action = "<C_P>";
    # }

    # gl - > $
    # gh - > 0
  ];

}

