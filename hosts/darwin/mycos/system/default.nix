# this is a nix-darwin module
username: inputs:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
    (import ./secrets.nix inputs.secrets-flake inputs.agenix.darwinModules.default)
    ./software.nix
  ];
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
    # got some error message while rebuilding
    system.primaryUser = "angel";
    system.stateVersion = 6;
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
    # copied from:
    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    system.defaults.CustomUserPreferences = {
      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
      };
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.screencapture" = {
        location = "~/Pictures";
        type = "png";
      };
      # "com.apple.Safari" = {
      #   # Privacy: don’t send search queries to Apple
      #   UniversalSearchEnabled = false;
      #   SuppressSearchSuggestions = true;
      #   # Press Tab to highlight each item on a web page
      #   WebKitTabToLinksPreferenceKey = true;
      #   ShowFullURLInSmartSearchField = true;
      #   # Prevent Safari from opening ‘safe’ files automatically after downloading
      #   AutoOpenSafeDownloads = false;
      #   ShowFavoritesBar = false;
      #   IncludeInternalDebugMenu = true;
      #   IncludeDevelopMenu = true;
      #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
      #   WebContinuousSpellCheckingEnabled = true;
      #   WebAutomaticSpellingCorrectionEnabled = false;
      #   AutoFillFromAddressBook = false;
      #   AutoFillCreditCardData = false;
      #   AutoFillMiscellaneousForms = false;
      #   WarnAboutFraudulentWebsites = true;
      #   WebKitJavaEnabled = false;
      #   WebKitJavaScriptCanOpenWindowsAutomatically = false;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
      #   "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
      # };
      # "com.apple.mail" = {
      #   # Disable inline attachments (just show the icons)
      #   DisableInlineAttachmentViewing = true;
      # };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
    };
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
