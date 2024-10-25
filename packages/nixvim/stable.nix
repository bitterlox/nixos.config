# this is a flake-parts module
top@{ inputs, lib, ... }: {
  perSystem = { inputs', config, system, pkgs, ... }:
    let
      packages = {
        nixvim-stable =
          top.inputs.nixvim-stable.legacyPackages.${system}.makeNixvimWithModule {
            pkgs = import top.inputs.nixpkgs-stable { inherit system; };
            module = { extraConfigLua = "print('hi')"; };
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
