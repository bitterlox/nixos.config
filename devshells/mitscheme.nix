{ inputs, ... }: {
  imports = [ inputs.devenv.flakeModule ];
  systems = [ "x86_64-linux" ];
  perSystem = { pkgs, ... }: {
    config.devenv.shells.default = {
      # https://devenv.sh/reference/options/
      packages = [ pkgs.mitscheme ];

      enterShell = ''
        echo "welcome to the shell"
      '';
    };
  };
}
