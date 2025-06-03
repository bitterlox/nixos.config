# this is a nixvim module
args@{
  config,
  helpers,
  lib,
  options,
  pkgs,
  self,
  ...
}:
{

  # lsp configuration #

  extraPackages = [ pkgs.nixfmt-rfc-style ];

  plugins.lsp.servers.nixd.enable = true;
  plugins.lsp.servers.nixd.cmd = [
    "nixd"
  ];
  plugins.lsp.servers.nixd.rootMarkers = [
    "require('lspconfig.util').root_pattern('.nixd.json', 'flake.nix', '.git')"
  ];

  plugins.lsp.servers.nixd.onAttach.function = # lua
    ''
      local flakePath = os.getenv("FLAKE_PATH");
      if flakePath ~= nil then
        print("found FLAKE_PATH env var: " .. flakePath)
      end
    '';

  # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
  plugins.lsp.servers.nixd.settings =
    let
      flake = ''(builtins.getFlake "${self}")'';
      system = ''''${builtins.currentSystem}'';
    in
    {
      #"nixpkgs" = {
      #  # For flake.
      #  # "expr": "import (builtins.getFlake \"/home/lyc/workspace/CS/OS/NixOS/flakes\").inputs.nixpkgs { }   "

      #  # This expression will be interpreted as "nixpkgs" toplevel
      #  # Nixd provides package, lib completion/information from it.
      #  #/
      #  # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
      #  #/                Package documentation, versions, are evaluated by-need.
      #  "expr" = "import <nixpkgs> { }";
      #};
      "formatting" = {
        # Which command you would like to do formatting
        "command" = [ "nixfmt" ];
      };
      # Tell the language server your desired option set, for completion
      # This is lazily evaluated.
      # there should be a way to get it to use the current flake's inputs but it looks
      # like (at least to me ) that it's not evaluating cwd's flake
      # see: https://kokada.dev/blog/make-nixd-module-completion-to-work-anywhere-with-flakes/
      # update: thx to this it works
      # https://github.com/nix-community/nixvim/issues/2290#issuecomment-2445114532
      # https://github.com/MattSturgeon/nix-config/blob/5dd1b19bc69fa33bfc950c10083490187c3d58a2/nvim/config/lsp.nix#L24-L48
      nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
      options = rec {
        flake-parts.expr = "${flake}.debug.options";
        nixos.expr = "${flake}.nixosConfigurations.elewse.options";
        # home manager doesn't work need to pull it out into a flake output to pass it here
        home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
        nixvim.expr = "${flake}.packages.${system}.nvim-full.options";
      };
      diagnostic = {
        # Suppress noisy warnings
        suppress = [
          "sema-escaping-with"
          "var-bind-to-this"
        ];
      };
      # "options" = {
      #   # Map of eval information
      #   # If this is omitted, default search path (<nixpkgs>) will be used.
      #   "nixos" = {
      #     # This name "nixos" could be arbitrary.
      #     # The expression to eval, interpret it as option declarations.
      #     "expr" = ''
      #       (builtins.getFlake "/home/lyc/flakes").nixosConfigurations.adrastea.options'';
      #   };

      #   # By default there is no home-manager options completion, thus you can add this entry.
      #   "home-manager" = {
      #     "expr" = ''
      #       (builtins.getFlake "/home/lyc/flakes").homeConfigurations."lyc@adrastea".options'';
      #   };
      # };
      # Control the diagnostic system
      # "diagnostic" = { "suppress" = [ "sema-extra-with" ]; };
    };

}
