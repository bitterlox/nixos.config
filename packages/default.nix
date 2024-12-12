# this is akin to a flake-parts top-level module
{ self, pkgs, inputs, config, lib, ... }: {
  #imports = [{
  #  _module.args = {
  #    sharedModules = [{ nixpkgs.overlays = [ overlay-nvim ]; }];
  #  };
  #}];
  imports = [ ./nixvim ];
  perSystem = { inputs', system, pkgs, ... }:
    let
      themePackages = let
        suffix = "-theme";
        hasSuffix = (a: _: lib.strings.hasSuffix suffix a);
        buildPlugin = name: src:
          pkgs.vimUtils.buildVimPlugin { inherit name src; };
        removeSuffix = attrName: (lib.strings.removeSuffix suffix attrName);
        filtered = lib.attrsets.filterAttrs hasSuffix inputs;
      in lib.attrsets.mapAttrs' (n: v:
        let newAttrName = (removeSuffix n);
        in lib.attrsets.nameValuePair newAttrName (buildPlugin newAttrName v))
      filtered;
    in {
      packages = {
        # neovim-full = inputs'.my-nvim.packages.nvim-full;
        # neovim-light = inputs'.my-nvim.packages.nvim-light;
        efmls-configs = pkgs.vimUtils.buildVimPlugin {
          name = "efmls-configs-nvim";
          src = inputs.efmls-configs;
        };
      } // (with pkgs; {
        firefly-iii-data-importer =
          (callPackage ./firefly-iii-data-importer.nix { });
        bash-language-server = (callPackage ./bash-language-server.nix { });
      }) // themePackages;
    };
  systems = [ "x86_64-linux" "aarch64-darwin" ];
}
# TODO:
# the /packages top level dir will define packages and install them in appr-
# opriate places; example: bring in all the code from nvim-config-flake,
# install it appropriately under overlays (so that it may be easily used by
# system configurations) and under apps so that i can use it with nix-run
# at that point I might need to change the repo name since it won't be
# just nixos anymore
