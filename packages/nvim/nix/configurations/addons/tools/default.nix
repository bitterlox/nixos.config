{ pkgs, addon }:
# might want to move tools under own subdir and provide here
# lsps bundled w/ respective tools 
let lsps = import ./lsps { inherit pkgs addon; };
in {
  # lsps
  inherit lsps;

  # linters
  yamllint = addon.makeToolAddon { pkg = pkgs.yamllint; };
  jsonlint = addon.makeToolAddon { pkg = pkgs.nodePackages.jsonlint; };
  markdownlint-cli =
    addon.makeToolAddon { pkg = pkgs.nodePackages.markdownlint-cli; };

  # formatters
  shellharden = addon.makeToolAddon { pkg = pkgs.shellharden; };
  stylua = addon.makeToolAddon { pkg = pkgs.stylua; };
  nixfmt = addon.makeToolAddon { pkg = pkgs.nixfmt; };

  # misc
  go = addon.makeToolAddon { pkg = pkgs.go; };
  ripgrep = addon.makeToolAddon { pkg = pkgs.ripgrep; };
  fd = addon.makeToolAddon { pkg = pkgs.fd; };
}
