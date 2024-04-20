{ lib }:
let
  interface = {
    get = _store: key: _store.${key};
    set = _store: key: value:
      lib.attrsets.mergeAttrsList [ _store { ${key} = value; } ];
  };
in interface
