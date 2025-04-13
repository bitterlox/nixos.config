{ pkgs, lib, ... }:
let
  bash = lib.getExe pkgs.bash;
  tmux = lib.getExe pkgs.tmux;
  serviceName = "my-service";
in
{
  systemd.services.${serviceName}.description = "A daemon running ${serviceName} in a tmux session";
  systemd.services.${serviceName}.after = [ "network.target" ];
  systemd.services.${serviceName}.serviceConfig = {
    Type = "forking";
    ExecStop = ''
      ${bash} -c '${tmux} send-keys -t ${serviceName} C-c && \
        while tmux list-panes -t ${serviceName} -F "#{pane_pid}" | xargs -I{} pgrep -P {} >/dev/null; do \
          sleep 1; \
        done && \
        /usr/bin/tmux kill-session -t ${serviceName}'
    '';

    # Set a reasonable maximum timeout as fallback
    TimeoutStopSec = 30;

    Restart = "on-failure";
    RestartSec = 5;
  };
  systemd.services.${serviceName}.wantedBy = [ "multi-user.target" ];

}
