# this service starts a program in a tmux session
# todo:
# - make it so it can run both as root and as user (add option to toggle this)
# # future improvements:
# - make it run a script;

# bash one-liner to test this way for the command in the session to quit
# before killing it
# bash -c '(trap "echo -e \"\nReceived Ctrl+C. Waiting \$n seconds before exiting...\"; sleep \$n; echo \"Exiting now.\"; exit 0" INT; n=${1:-5}; echo "Program running. Press Ctrl+C to trigger $n second delayed exit."; while true; do echo -n "."; sleep 1; done)' _ 10
{
  pkgs,
  lib,
  config,
  ...
}:
let
  bash = lib.getExe pkgs.bashInteractive;
  # if we use system tmux config it complains about the line which sets shell to $SHELL
  # but the send-keys still work. Keep as is for now, can disable config if needed
  #  -f /dev/null makes it run without config
  # tmux = "${lib.getExe pkgs.tmux} -f /dev/null"
  # default tmux socket is in /tmp when running as root
  # and in /run/user/<uid>/tmux-<uid>/default when a user
  tmux = "${lib.getExe pkgs.tmux} -S /run/user/$(id -u)/tmux-$(id -u)/default";
  pgrep = "${pkgs.busybox}/bin/pgrep";
  xargs = "${pkgs.busybox}/bin/xargs";
  types = lib.types;
  mkService = name: startCmd: stopSignal: {
    environment = {
    };
    description = "A daemon running ${name} in a tmux session";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = ''
        ${bash} -c "${tmux} new-session -d -s ${name} && ${tmux} send-keys -t ${name} '${startCmd}' && ${tmux} send-keys C-m"
      '';
      ExecStop = [
        "${bash} -c '${tmux} send-keys -t ${name} ${stopSignal}'"
        ''
          ${bash} -c 'while ${tmux} list-panes -t ${name} -F "#{pane_pid}" | ${xargs} -I{} ${pgrep} -P {} >/dev/null; do \
          sleep 0.5; \
          done && \
          ${tmux} kill-session -t ${name}'
        ''
      ];

      # Set a reasonable maximum timeout as fallback
      TimeoutStopSec = 30;

      Restart = "on-failure";
      RestartSec = 5;
    };
  };
in
{
  options.tmux-services = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          startCmd = lib.mkOption { type = types.str; };
          stopSignal = lib.mkOption {
            type = types.enum [
              "C-c"
              "C-d"
            ];
          };
        };
      }
    );
    default = { };
  };
  config = {
    tmux-services.foo = {
      startCmd = "ping www.google.com";
      stopSignal = "C-c";
    };
    systemd.user.services = lib.attrsets.mapAttrs (
      name: value: mkService name value.startCmd value.stopSignal
    ) config.tmux-services;
  };
}
