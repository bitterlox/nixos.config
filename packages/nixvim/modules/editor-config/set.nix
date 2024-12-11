# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  # set curson in insert mode
  # guicursor = "";

  opts.nu = true;
  opts.relativenumber = true;

  # indentation #
  # https://vim.fandom.com/wiki/Indenting_source_code
  opts.expandtab = true;
  opts.softtabstop = 2;
  opts.shiftwidth = 2;
  opts.smartindent = true;

  # folding #
  opts.foldmethod = "indent";
  opts.foldlevel = 1;

  # disable line wrapping
  opts.wrap = false;

  # disable swapfile, enable undo file
  opts.swapfile = false;
  opts.backup = false;
  opts.undodir = helpers.mkRaw ''os.getenv("HOME") .. "/.nvim/undodir"'';
  opts.undofile = true;

  opts.hlsearch = false;
  opts.incsearch = false;

  opts.termguicolors = true;

  opts.scrolloff = 8;
  opts.signcolumn = "yes";
  opts.isfname = "@-@";

  opts.colorcolumn = "80";

  globals.mapleader = " ";

}
