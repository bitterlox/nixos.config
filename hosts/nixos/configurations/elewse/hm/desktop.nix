angelBaseModule: impermanenceHmModule:
{
  lib,
  config,
  options,
  pkgs,
  osConfig,
  ...
}:
let
  overrides = {
    nerdfonts = pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "SourceCodePro"
        "Hasklig"
        "NerdFontsSymbolsOnly"
      ];
    };
    popcorntime = pkgs.popcorntime.overrideDerivation (previousAttrs: {
      # PROBLEM: this derivation is defined using a recursive attrSet so
      # overrides don't propagate
      #
      # SOLUTIONS
      # can use lib.strings.splitString to split on newlines;
      # then remove the last line:
      # add my line using the proper desktopItem
      # concat all strings with newlines
      #
      # OR
      #
      # make overlay just copying the thing from nixpkgs but using the new feature
      # from stdenv.mkDerivation that allows finalAttrs so you can reference stuff
      # then override that
      # make PR to nixpkgs to upstream this change
      desktopItem = previousAttrs.desktopItem.override {
        exec = "${previousAttrs.pname} --enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    });
  };
in
{
  imports = [
    angelBaseModule
    impermanenceHmModule
    ./hardware
    ./software
  ];
  config = {
    home.packages =
      let
        overriden = with overrides; [
          nerdfonts
          popcorntime
        ];
        #overriden = with overrides; [ nerdfonts ];
        vanilla = with pkgs; [
          wl-clipboard
          shotman
          libnotify
          obsidian
          hyprpicker
          pavucontrol
          protonmail-desktop
          protonvpn-gui
        ];
      in
      overriden ++ vanilla;
    #home.extraOutputsToInstall = [ "share" ];

    fonts.fontconfig.enable = true;

    # kde themes #
    gtk.enable = true;

    gtk.iconTheme.package = pkgs.whitesur-icon-theme;
    # options:
    # WhiteSur WhiteSur-dark WhiteSur-light
    gtk.iconTheme.name = "WhiteSur-dark";
    gtk.theme.package = pkgs.whitesur-gtk-theme;
    # variants:
    # WhiteSur-Dark WhiteSur-Dark-hdpi WhiteSur-Dark-solid
    # WhiteSur-Dark-xhdpi WhiteSur-Light WhiteSur-Light-hdpi
    # WhiteSur-Light-solid WhiteSur-Light-xhdpi
    gtk.theme.name = "WhiteSur-Dark-solid";

    # gtk.iconTheme.package = pkgs.rose-pine-icon-theme;
    # # If you prefer other icons variant, replace the "rose-pine-icons"
    # #  with "rose-pine-moon-icons" or "rose-pine-dawn-icons"
    # gtk.iconTheme.name = "rose-pine-moon-icons";
    # gtk.theme.package = pkgs.rose-pine-gtk-theme;
    # # If your prefer other themes variant, replace the "rose-pine-gtk"
    # # with "rose-pine-moon-gtk" or "rose-pine-dawn-gtk"
    # gtk.theme.name = "rose-pine-moon-gtk";

    # gtk.iconTheme.package = pkgs.kanagawa-icon-theme;
    # gtk.iconTheme.name = "Kanagawa";
    # gtk.theme.package = pkgs.kanagawa-gtk-theme;
    # gtk.theme.name = "Kanagawa-BL";

    ## PROGRAMS ##
    programs.kitty = {
      enable = true;
      keybindings = { };
      # can't set float values yet, need next stable release
      settings = { background_opacity = 0.65; };
    };

    programs.rio = {
      enable = true;
      # Configuration written to {file}$XDG_CONFIG_HOME/rio/config.toml. See
      # https://raphamorim.io/rio/docs/#configuration-file for options.
      # settings = {};
    };

    programs.password-store.enable = true;
    programs.password-store.settings = {
      PASSWORD_STORE_DIR = "/home/angel/.password-store";
    };

    programs.gpg.enable = true;

    programs.ssh.enable = true;
    programs.ssh.matchBlocks = {
      "*" = {
        serverAliveInterval = 120;
        identityFile = osConfig.lockbox.sshKeyPath;
      };
      "github.com" = {
        identityFile = osConfig.lockbox.sshKeyPath;
      };
    };
    programs.ssh.includes = [ osConfig.lockbox.sshHostsPath ];

    ## SERVICES ##
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    services.mako.enable = true;
    services.cliphist.enable = true;

    # this at least allows HM to create all dirs and files but fails
    # because it says it can't find /persist/home/angel
    # so the other one binds but does not activate, this one activates
    # but doesn't bind
    # home.persistence."/persist/home/angel" = {
    #   directories = [
    #     # handled by hm
    #     # ".bash_profile"
    #     # ".bashrc"

    #     # these are caches, delete
    #     # ".cache"
    #     # ".compose-cache"

    #     # nuke for now, keep only .config/obsidian
    #     # ".config"
    #     ".config/obsidian"

    #     # keep all of these
    #     "Desktop"
    #     "Documents"
    #     "Downloads"
    #     ".gnupg"

    #     # handled by hm
    #     # ".gtkrc-2.0"
    #     # seems mostly cache-like stuff, maybe can try to persist
    #     # tofi and nvim stuff if they do wierd stuff
    #     # ".local"

    #     # keep all of these
    #     ".mozilla"
    #     "Music"

    #     # delete, handled by nix / hm
    #     # ".nix-defexpr"
    #     # ".nix-profile"

    #     # keep all of these
    #     ".nvim"
    #     ".password-store"
    #     "Pictures"

    #     # this is needed by gnome keyring, delete for now
    #     # ".pki"

    #     # handled by hm
    #     # ".profile"

    #     # keep all of these
    #     "Public"

    #     # handled by hm
    #     # ".ssh"
    #     "Templates"
    #     "Videos"
    #   ];
    #   files = [ ".bash_history" ".ssh/known_hosts" ];
    #   allowOther = true;
    # };

    # todo: rclone
    # https://rclone.org/docs/#config-config-file
    # set up config with cli and then replace with declarative version
    # set up a systemd user service to mount the drive at login
    # https://rclone.org/protondrive/

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";
  };
}
