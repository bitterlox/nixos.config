# this is a flake-parts module
top@{ inputs, lib, ... }: {
  perSystem = { inputs', inputs, config, system, pkgs, ... }:
    let
      packages = {
        nixvim-stable =
          top.inputs.nixvim-stable.legacyPackages.${system}.makeNixvimWithModule {
            # pkgs = import inputs'.nixpkgs-stable {};
            module = { extraConfigLua = "print('hi')"; };
          };
        nixvim-unstable =
          top.inputs.nixvim-unstable.legacyPackages.${system}.makeNixvimWithModule {
            # pkgs = inputs'.nixpkgs;
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
      changeBinName = package:
        pkgs.writeShellScriptBin "nixvim" "exec -a $0 ${lib.getExe package} $@";
    in {
      config = {
        # packages = packages;
        packages = lib.debug.traceVal
          (builtins.mapAttrs (name: value: value) packages);
        # packages = packages // { default = packages.nixvim-stable; };
        apps = let attrs = packagesToApps packages;
        in attrs // { default = attrs.nixvim-stable; };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
