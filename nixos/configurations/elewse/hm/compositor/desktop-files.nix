{ lib, config, options, pkgs, ... }:
let makeApp = { name, ... }@argSet: { type = "Application"; } // argSet;
in {
  imports = [ ];
  xdg.desktopEntries = {
    firefox = makeApp {
      name = "Firefox";
      genericName = "Web Browser";
      exec = "firefox %U";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
    };
    obsidian = makeApp {
      name = "Obsidian";
      genericName = "Text Editor";
      exec = "obsidian";
      terminal = false;
    };
    kitty = makeApp {
      name = "Kitty";
      genericName = "Terminal Emulator";
      exec = "kitty";
      terminal = false;
    };
  };
}
