# todo: maybe move this to inside addons
# this is a flake-parts module
{ inputs, lib, ... }:
let
  buildThemePackages = pkgs:
    let
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
  perSystem = { inputs', system, pkgs, ... }:
    let
      overlayVimPlugins = prev: final:
        final.lib.recursiveUpdate final {
          vimPlugins.customPlugins = {
            efmls-configs = import ./efmls-configs.nix {
              pkgs = final;
              src = inputs.efmls-configs;
            };
          };
          vimPlugins.customThemes = buildThemePackages pkgs;
          nodePackages.bash-language-server =
            import ./bash-language-server.nix { pkgs = final; };
        };
    in {
      config = {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ overlayVimPlugins ];
        };
      };
    };
  systems = [ "aarch64-darwin" "x86_64-linux" ];
}
