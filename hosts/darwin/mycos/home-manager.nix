# this is a nix-darwin module
username: homeModules: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Optionally, use home-manager.extraSpecialArgs to pass arguments to this
  home-manager.users.angel =
# this is a -darwin module
    { ... }:
    {
      imports =
        let
          m = homeModules;
        in
        [
          m.fzf
          m.bash
        ];
      config = {

        home.username = "${username}";
        home.homeDirectory = "/Users/${username}";
        home.stateVersion = "24.11";
      };
    };
}
