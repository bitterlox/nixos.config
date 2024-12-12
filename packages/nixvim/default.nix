# - here at the top level copy the wrapping code from the other nvim derivation
#   and mash them all into a single PATH, using the config.package option
#
# this is a flake-parts module
top@{ inputs, lib, ... }: {
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      packages-unstable = {
        nvim-full =
          top.inputs.nixvim-unstable.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = import top.inputs.nixpkgs { inherit system; };
            module = ./unstable-full.nix;
          };
        nvim-light =
          top.inputs.nixvim-unstable.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = import top.inputs.nixpkgs { inherit system; };
            module = ./unstable-light.nix;
          };
      };
      # packages-stable = {
      #   nixvim-stable =
      #     top.inputs.nixvim-stable.legacyPackages.${system}.makeNixvimWithModule {
      #       pkgs = import top.inputs.nixpkgs-stable { inherit system; };
      #       module = { extraConfigLua = "print('hi')"; };
      #     };
      # };
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
        packages = packages-unstable;
        # packages = packages // { default = packages.nixvim-stable; };
        apps = let attrs = packagesToApps packages-unstable; in attrs;
        # in attrs // { default = attrs.nixvim-stable; };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
