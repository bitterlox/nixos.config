# this is a nixvim module
args@{ config, helpers, lib, options, pkgs, specialArgs }: {

  # lsp configuration #

  runtimeBinaries = [ pkgs.nixfmt-rfc-style ];

  plugins.lsp.servers.nixd.enable = true;
  plugins.lsp.servers.nixd.cmd = [ "nixd" "--semantic-tokens=true" ];
  plugins.lsp.servers.nixd.rootDir =
    "require('lspconfig.util').root_pattern('.nixd.json', 'flake.nix', '.git')";

  # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
  plugins.lsp.servers.nixd.settings = {
    nixd = {
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
  };
}
