{ inputs, ... }: {
  imports = [ inputs.devenv.flakeModule ];
  systems = [ "x86_64-linux" ];
  # i don't like devenv, it needs to be run with --impure and it 
  # fucks up nix flake show; find alternative

  # perSystem = { pkgs, ... }: {
  #   config.devenv.shells.default = {
  #     # https://devenv.sh/reference/options/
  #     packages = [ pkgs.mitscheme ];

  #     enterShell = ''
  #       echo "welcome to the shell"
  #     '';
  #   };
  # };
}
