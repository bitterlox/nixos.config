{ pkgs, lib, config, ... }:
let
  languagePacks = [ "it" "en-GB" ];
  pkgVersion = config.programs.firefox.package.version;

  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  imports = [ ];
  programs.firefox = {
    enable = true;

    # ---- POLICIES ----
    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = false;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar =
        "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
      RequestedLocales= ["en-GB" "it"];
      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      ExtensionSettings = {
        "*".installation_mode =
          "blocked"; # blocks all addons except the ones specified below

        "browserpass@maximbaz.com" = {
          # if developer would public xpis to github i'd pull from there
          install_url =
            "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
          installation_mode = "force_installed";
        };
        #        # uBlock Origin:
        #        "uBlock0@raymondhill.net" = {
        #          install_url =
        #            "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #          installation_mode = "force_installed";
        #        };
        #        # Privacy Badger:
        #        "jid1-MnnxcxisBPnSXQ@jetpack" = {
        #          install_url =
        #            "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        #          installation_mode = "force_installed";
        #        };
        #        # 1Password:
        #        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
        #          install_url =
        #            "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        #          installation_mode = "force_installed";
        #        };
      } // builtins.listToAttrs (builtins.map (lang:
        lib.attrsets.nameValuePair "langpack-${lang}@firefox.mozilla.org" {
          installation_mode = "normal_installed";
          install_url =
            "https://releases.mozilla.org/pub/firefox/releases/${pkgVersion}/linux-x86_64/xpi/${lang}.xpi";
        }) languagePacks);

      # ---- PREFERENCES ----
      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lock-true;
        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" =
          lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
          lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" =
          lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" =
          lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" =
          lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };
}
