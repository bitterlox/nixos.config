# this is a nixvim module
args@{
  config,
  lib,
  options,
  pkgs,
  specialArgs,
  ...
}:
let
  grammars = config.plugins.treesitter.package.passthru.builtGrammars;
in
{
  imports = [
    ./options.nix
    ./modules/editor-config
    ./modules/plugins/_essentials.nix
  ];

  plugins.ledger.enable = true;
  plugins.treesitter.grammarPackages = lib.mkForce (
    with grammars;
    [
      bash
      toml
      json
      ledger
      markdown
      nix
      yaml
      csv
      python
    ]
  );

  # this was a solution to me needing stuff like rg and other executables
  # to be in nvim's path
  # package = let
  #   neovim = options.package.default;
  #   wrapNeovim = runtimeBinaries:
  #     pkgs.symlinkJoin {
  #       inherit (neovim) name meta lua;
  #       paths = [ neovim ];
  #       nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  #       # this needs to be postBuild, i tried postInstall and it wasn't working
  #       postBuild = ''
  #         mv $out/bin/nvim $out/bin/nvim-nobins
  #         makeWrapper $out/bin/nvim-nobins \
  #           $out/bin/nvim \
  #           --prefix PATH ":" ${lib.makeBinPath config.runtimeBinaries}
  #       '';
  #     };
  # in if (builtins.length config.runtimeBinaries) > 0 then
  #   wrapNeovim config.runtimeBinaries
  # else
  #   neovim;

}
