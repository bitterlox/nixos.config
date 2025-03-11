# this is a nix-darwin module
username: packages: inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.agenix.darwinModules.default
    inputs.mac-app-util.darwinModules.default
    (import ./secrets.nix inputs.secrets-flake)
  ];
  options = {
    lockbox = lib.mkOption {
      type = with lib.types; attrsOf (either str (attrsOf str));
      default = { };
      example = {
        mysecret = "superSecretPassword";
      };
      description = lib.mdDoc "An attrset of secrets and less secret values";
    };
  };
  # control user w/ nix-darwin, fix for default shell option not sticking
  # https://github.com/LnL7/nix-darwin/issues/1237#issuecomment-2562230471
  config = {
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
        pkgs.git
        pkgs.borgbackup
      ];
    system.defaults = {
      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
        NSAutomaticPeriodSubstitutionEnabled = false;
      };
      dock = {
        wvous-tl-corner = 13;
        wvous-tr-corner = 10;
      };
    };
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };
    programs.ssh.extraConfig = "include ${config.lockbox.sshHostsPath}";
    nix = {
      package = pkgs.nix;

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
        "wasabi-wallet"
        "macfuse"
        "vorta"
        "chromium"
        "firefox"
      ];
      brews = [ "cocoapods" ];
      masApps = {
        drafts = 1435957248;
        todoist = 585829637;
        xcode = 497799835;
        numbers = 409203825;
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
  };
}
