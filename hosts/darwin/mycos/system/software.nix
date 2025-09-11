# this is a nix-darwin module
{
  config,
  pkgs,
  lib,
  ...
}:
{
    environment.systemPackages = [
      pkgs.kitty
      pkgs.pass
      pkgs.gnupg
      pkgs.git
      pkgs.borgbackup
    ];
    programs.ssh.extraConfig = "include ${config.lockbox.sshHostsPath}";
    homebrew = {
      enable = true;
      casks = [
        "protonvpn"
        "proton-drive"
        "vlc"
        "steam"
        "obsidian"
        "wasabi-wallet"
        "macfuse"
        "vorta"
        "chromium"
        "librewolf"
        "ghostty"
        "trezor-suite"
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
}
