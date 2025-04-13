username: inputs: config:
{ ... }:
{
  home-manager.useGlobalPkgs = true;
  # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
  home-manager.users.angel = {
    imports =
      let
        m = config.flake.homeModules;
      in
      [
        m.fzf
        m.tmux
        m.bash
        (import ./home-manager username)
        inputs.mac-app-util.homeManagerModules.default
      ];
  };
}
