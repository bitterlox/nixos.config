# this is a home-manager module
{ pkgs, lib, ... }:
{
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  # starship - an customizable prompt for any shell
  # https://starship.rs/config/
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = "❄️ ";
      };
      direnv = {
        disabled = false;
        format = "[$symbol$loaded $allowed]($style) ";
        allowed_msg = "✓";
        not_allowed_msg = "·";
        denied_msg = "✗";
        loaded_msg = "●";
        unloaded_msg = "○";
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # tweak the PS1 depending if it's on linux or mac; in either case
    # i like the ones that turn red if we're root
    #bashrcExtra = ''
    #  _direnv_prompt() {
    #    local YEL=$'\[\e[1;33m\]'
    #    local RED=$'\[\e[1;31m\]'
    #    local RST=$'\[\e[0m\]'

    #    if [[ -n "''${DIRENV_DIR-}" ]]; then
    #      local d="''${DIRENV_DIR%/}"; local base="''${d##*/}"
    #      local name="''${PROJECT:-''$base}"; [[ -z "''$name" ]] && name="''${PWD##*/}"
    #      printf '%s[%s]%s ' "''$YEL" "''$name" "''$RST"
    #      return
    #    fi

    #    if command -v direnv >/dev/null 2>&1 && command -v ${lib.getExe pkgs.jq} >/dev/null 2>&1; then
    #      local json; json="''$(direnv status --json 2>/dev/null)" || return
    #      local allowed; allowed="''$(${lib.getExe pkgs.jq} -r '.state.rc.allowed // empty' <<<"''$json")"
    #      local found;   found="''$(${lib.getExe pkgs.jq} -r '.state.rc.found   // empty' <<<"''$json")"
    #      if [[ -n "''$found" && "''$allowed" != "true" ]]; then
    #        local dir="''${found%/}"; local base="''${dir##*/}"
    #        local name="''${PROJECT:-''$base}"
    #        printf '%s[!%s]%s ' "''$RED" "''$name" "''$RST"
    #      fi
    #    fi
    #  }
    #  export PS1='$(_direnv_prompt)\h:\w \u\$ '
    #'';

    # this file contains shell vars used in varoious spots in the system config
    initExtra = ''
      # include .profile if it exists
      [[ -f ~/.home.env ]] && . ~/.home.env
    '';

    # set some aliases, feel free to add more or remove some
    # shellAliases = {
    #   k = "kubectl";
    #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    # };
  };
}
