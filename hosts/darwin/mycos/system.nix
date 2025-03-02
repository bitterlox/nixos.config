# this is a nix-darwin module
username: packages: inputs:
{ pkgs, ... }:
{
  # control user w/ nix-darwin, fix for default shell option not sticking
  # https://github.com/LnL7/nix-darwin/issues/1237#issuecomment-2562230471
  users.knownUsers = [ username ];
  users.users.${username} = {
    uid = 501;
    name = "${username}";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.bashInteractive;
  };
  system.stateVersion = 6;
  environment.systemPackages =
    let
      p = packages;
    in
    [
      p.nvim-full
      pkgs.kitty
      pkgs.pass
      pkgs.gnupg
    ];
  system.defaults = {
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 1;
      NSAutomaticPeriodSubstitutionEnabled = false;
    };
  };
  nix = {
    package = pkgs.nix;
    configureBuildUsers = true;

    settings = {
      trusted-users = [
        "@admin"
        "${username}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  homebrew = {
    enable = true;
    casks = [
      "protonvpn"
      "proton-drive"
      "kitty"
      "vlc"
      "steam"
      "obsidian"
    ];
    masApps = {
      drafts = 1435957248;
      todoist = 585829637;
    };
    whalebrews = [ ];
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
  };
  nix-homebrew = {
    user = username;
    enable = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
  };
}
