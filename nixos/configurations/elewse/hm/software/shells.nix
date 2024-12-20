{ pkgs, lib, ... }:
let
  open-di-tunnel-cmd = "ssh -NTf -L 1234:sietch:1234 sietch";
  scripts = (import ./scripts { inherit pkgs; });
in
{

  # like this tho it's not being sourced automatically
  programs.bash = {
    initExtra = ''
      # include .profile if it exists
      [[ -f ~/.home.env ]] && . ~/.home.env
    '';
  };

  home.shellAliases = {
    open-di-tunnel = open-di-tunnel-cmd;
    close-di-tunnel = ''kill $(pgrep -f "${open-di-tunnel-cmd}")'';
    sessionizer = "${lib.getExe scripts.tmux-sessionizer}";
  };
}
