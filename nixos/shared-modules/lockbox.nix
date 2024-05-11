{ lib, ... }: {
  options = {
    lockbox = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      example = { mysecret = "superSecretPassword"; };
      description = lib.mdDoc "An attrset of secrets and less secret values";
    };
  };
}
