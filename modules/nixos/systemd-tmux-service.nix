# this service starts a program in a tmux session
# todo:
# - pull this out into options for configurability
# - make it so the command to run is configurable / a script
# - make the signal sent configurable

# bash one-liner to test this way for the command in the session to quit
# before killing it
# bash -c '(trap "echo -e \"\nReceived Ctrl+C. Waiting \$n seconds before exiting...\"; sleep \$n; echo \"Exiting now.\"; exit 0" INT; n=${1:-5}; echo "Program running. Press Ctrl+C to trigger $n second delayed exit."; while true; do echo -n "."; sleep 1; done)' _ 10
{ pkgs, lib, ... }:
let
  bash = lib.getExe pkgs.bashInteractive;
  tmux = "${lib.getExe pkgs.tmux} -f /dev/null";
  pgrep = "${pkgs.busybox}/bin/pgrep";
  xargs = "${pkgs.busybox}/bin/xargs";
  serviceName = "my-service";
in
{
  systemd.services.${serviceName} = {
    description = "A daemon running ${serviceName} in a tmux session";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = ''
        ${bash} -c  "${tmux} new-session -d -s ${serviceName} && ${tmux} send-keys -t ${serviceName} 'ping www.google.com' && ${tmux} send-keys C-m"
      '';
      ExecStop = [
        "${bash} -c '${tmux} send-keys -t ${serviceName} C-c'"
        ''
          ${bash} -c 'while ${tmux} list-panes -t ${serviceName} -F "#{pane_pid}" | ${xargs} -I{} ${pgrep} -P {} >/dev/null; do \
            sleep 0.5; \
              done && \
              ${tmux} kill-session -t ${serviceName}'
        ''
      ];

      # Set a reasonable maximum timeout as fallback
      TimeoutStopSec = 30;

      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
