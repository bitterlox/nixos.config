# this is a flake-parts module
top@{ inputs, lib, ... }: {
  # TODO: handle runtime tool dependencies as follows:
  # - define a custom option, `runtimeBinaries` of type list of pkgs
  #   to which we'll add pkgs in our files
  #
  # - here at the top level copy the wrapping code from the other nvim derivation
  #   and mash them all into a single PATH, using the config.package option
  #
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      packages = {
        nixvim-unstable =
          top.inputs.nixvim-unstable.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = import top.inputs.nixpkgs { inherit system; };
            module = { ... }: {
              imports =
                [ ./modules/editor-config ./modules/plugins-essentials.nix ];
            };
          };
      };
      packagesToApps = packages:
        lib.attrsets.listToAttrs (builtins.map ({ name, value }: {
          inherit name;
          value = {
            type = "app";
            program = (lib.getExe value);
          };
        }) (lib.attrsets.attrsToList packages));
    in {
      config = {
        # packages = packages;
        packages = packages;
        # packages = packages // { default = packages.nixvim-stable; };
        apps = let attrs = packagesToApps packages; in attrs;
        # in attrs // { default = attrs.nixvim-stable; };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
