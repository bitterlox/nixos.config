# this is a nixvim module
args@{ config, lib, ... }:
{
  imports = [
  ];
  config = {
    plugins.treesitter.grammarPackages = config.plugins.treesitter.package.passthru.allGrammars;
  };
}
