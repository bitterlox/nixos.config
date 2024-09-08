{ pkgs, addon }:
let
  getLuaFilePathsFromDir = dir:
    let
      isLuaFile = (filename: pkgs.lib.strings.hasSuffix ".lua" filename);
      findLuaFilesInDir = dir:
        let filenames = (builtins.attrNames (builtins.readDir dir));
        in builtins.filter isLuaFile filenames;
    in (builtins.map (file: pkgs.lib.path.append dir "${file}") (findLuaFilesInDir dir));
in {
  editor-config = addon.makeLuaCfgAddon {
    config = getLuaFilePathsFromDir ../../../../lua/config/editor-config;
  };
  globals = addon.makeLuaCfgAddon {
    config = getLuaFilePathsFromDir ../../../../lua/globals;
  };
}

