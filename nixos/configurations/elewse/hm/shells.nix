{ ... }:
let open-di-tunnel-cmd = "ssh -NTf -L 1234:sietch:1234 sietch";
in {
  home.shellAliases = {
    open-di-tunnel = open-di-tunnel-cmd;
    close-di-tunnel = ''kill $(pgrep -f "${open-di-tunnel-cmd}")'';
  };
}
