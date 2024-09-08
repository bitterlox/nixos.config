# todo:
# - figure out how testing is done in nix
# - add tests for this
{ pkgs }: # if we pass flake-part's top-level arg lib this doesn't work wtf???
let
  # todo: pull out functionality under single fn
  lib = pkgs.lib;
  checkPkgOrPkgs = pkg:
    let
      doChecks = lib.lists.foldl' lib.trivial.and true;
      flattened = pkgs.lib.lists.flatten pkg;
    in if (doChecks (builtins.map lib.attrsets.isDerivation flattened)) then
      flattened
    else
      lib.trivial.throwIf true
      "pkg is not derivation nor a list of derivations";

  checkCfgs = pathOrPaths:
    let
      doChecks = lib.lists.foldl' lib.trivial.and true;
      flattened = pkgs.lib.lists.flatten pathOrPaths;
    in if (doChecks (builtins.map lib.path.hasStorePathPrefix flattened)) then
      flattened
    else
      lib.trivial.throwIf true
      "cfgs is not store path nor a list of store paths";

  constructors = {
    makeToolAddon = { pkg, config ? [ ] }:
      let
        pkgs = checkPkgOrPkgs pkg;
        cfgs = checkCfgs config;
      in {
        kind = "tool";
        packages = pkgs;
        luaConfigs = cfgs;
      };
    makePluginAddon = { pkg, config ? [ ] }:
      let
        pkgs = checkPkgOrPkgs pkg;
        cfgs = checkCfgs config;
      in {
        kind = "plugin";
        packages = pkgs;
        luaConfigs = cfgs;
      };
    makeLuaCfgAddon = { config }:
      let cfgs = checkCfgs config;
      in {
        kind = "config";
        packages = [ ]; # not sure if this fits in our system
        # this should fail if something that's not a list is passed
        luaConfigs = cfgs;
      };
  };

  selectors = let
    getAddonKind = addon:
      if (builtins.isAttrs addon) then
        (if (addon ? kind) then
          addon.kind
        else
          lib.trivial.throwIf true "attrSet '${
            builtins.toString addon
          }' doesn't have a 'kind' attribute")
      else
        lib.trivial.throwIf true
        "argument '${builtins.toString addon}' is not attribute set";
  in {
    getTools = addon@{ packages, ... }:
      if (getAddonKind addon) == "tool" then packages else null;
    getPlugins = addon@{ packages, ... }:
      if (getAddonKind addon) == "plugin" then addon.packages else null;
    getLuaCfgs = addon: addon.luaConfigs;
    inherit getAddonKind;
  };
  # todo: make this better / prettier
  mergeAddons = addon1: addon2:
    let
      kind1 = (selectors.getAddonKind addon1);
      kind2 = (selectors.getAddonKind addon2);
      selectorSet = {
        "tool" = selectors.getTools;
        "plugin" = selectors.getPlugins;
        "luaConfigs" = selectors.getLuaCfgs;
      };
      constructorsSet = {
        "tool" = cfgs: pkgs:
          constructors.makeToolAddon {
            pkg = pkgs;
            config = cfgs;
          };
        "plugin" = cfgs: pkgs:
          constructors.makePluginAddon {
            pkg = pkgs;
            config = cfgs;
          };
        "luaConfigs" = cfgs: pkgs:
          constructors.makeLuaCfgAddon { config = cfgs; };
      };
    in if (kind1 == kind2) then
      let
        pkgs = builtins.map selectorSet.${kind1} [ addon1 addon2 ];
        cfgs = builtins.map selectors.getLuaCfgs [ addon1 addon2 ];
      in constructorsSet.${kind1} cfgs pkgs
    else
      lib.trivial.throwIf true "can't merge addons not of the same kind" { };

in constructors // selectors // { inherit mergeAddons; }
