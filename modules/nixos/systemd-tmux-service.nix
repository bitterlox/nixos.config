# this service starts a program in a tmux session
#
# STATUS
# won't do more work on this for now.
# there is a race condition between the tmux server and the
# child processes that i can't stamp out.

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
  # this script tests that the service actually waits for the process inside the
  # tmux to quit before shutting everything down
  # testScript = pkgs.writeShellApplication {
  #   name = "test-service";
  #   text = ''
  #     bash -c '(trap "echo -e \"\nReceived Ctrl+C. Waiting \$n seconds before exiting...\"; sleep \$n; echo \"Exiting now.\"; exit 0" INT; n=''${1:-5}; echo "Program running. Press Ctrl+C to trigger $n second delayed exit."; while true; do echo -n "."; sleep 1; done)' _ 10
  #   '';
  # };
  tmuxServiceName = "systemd-tmux";
  bash = lib.getExe pkgs.bashInteractive;
  systemd-run = "${config.systemd.package}/bin/systemd-run";
  # if we use system tmux config it complains about the line which sets shell to $SHELL
  # but the send-keys still work. Keep as is for now, can disable config if needed
  #  -f /dev/null makes it run without config
  # tmux = "${lib.getExe pkgs.tmux} -f /dev/null"
  tmux = lib.getExe pkgs.tmux;
  pgrep = "${pkgs.busybox}/bin/pgrep";
  echo = "${pkgs.busybox}/bin/echo";
  ls = "${pkgs.busybox}/bin/ls";
  xargs = "${pkgs.busybox}/bin/xargs";
  types = lib.types;
  mkTmuxService = isSystemService: nestedServices: {
    description = "Tmux Server that runs systemd services";
    after = [ "default.target" ];

    environment = {
      # %U expands to user's uid
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#Specifiers
      XDG_RUNTIME_DIR = if isSystemService then "/tmp" else "/run/user/%U";
      TMUX_TMPDIR = if isSystemService then "/tmp" else "/run/user/%U";
    };
    serviceConfig = {
      Type = "forking";
      ExecStart = "${tmux} start-server";
      ExecStop = "${tmux} kill-server";
      Restart = "on-failure";
      RemainAfterExit = true;
    };

    # cleanly run stop commands before shutdown
    before = [
      "shutdown.target"
      "reboot.target"
      "halt.target"
    ] ++ (builtins.map (name: "${name}.service") nestedServices);

    conflicts = [
      "shutdown.target"
      "reboot.target"
      "halt.target"
    ];

    wantedBy = [ "default.target" ];
  };
  mkService = isSystemService: name: startCmd: stopSignal: {
    description = "A daemon running ${name} in a tmux session";
    after = [
      "${tmuxServiceName}.service"
      (if isSystemService then "network.target" else "default.target")
    ];

    bindsTo = [
      "${tmuxServiceName}.service"
    ];

    # cleanly run stop commands before shutdown
    before = [
      "shutdown.target"
      "reboot.target"
      "halt.target"
    ];
    conflicts = [
      "shutdown.target"
      "reboot.target"
      "halt.target"
    ];

    environment = {
      # default tmux socket is in /tmp when running as root
      # and in /run/user/<uid>/tmux-<uid>/default when a user
      # %U expands to user's uid
      # https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#Specifiers
      XDG_RUNTIME_DIR = if isSystemService then "/tmp" else "/run/user/%U";
      TMUX_TMPDIR = if isSystemService then "/tmp" else "/run/user/%U";
    };

    serviceConfig = {
      Type = "forking";
      # Create directory with correct permissions
      # RuntimeDirectory = "tmux-%U";
      # RuntimeDirectoryMode = "0700";
      ExecStart = ''
        ${bash} -c "\
        echo $TMUX_TMPDIR && \
        ${tmux} new-session -d -s ${name} && \
        ${tmux} start-server && \
        ${tmux} send-keys -t ${name} \
        '${systemd-run} --user --scope --unit=tmux-urbit ${startCmd}' && \
        ${tmux} send-keys C-m"
      '';
      ExecStop = [
        "${echo} 'before foo kill'"
        "${ls} -lah /run/user/1000"
        "${pgrep} tmux"
        # the problem is that the child tmux process gets killed right away on
        # shutdown so we can't perform a clean shutdown of the urbit
        # when we get to this line it's already been killed
        "${bash} -c '${tmux} send-keys -t ${name} ${stopSignal}'"
        "${echo} 'foo killed ok'"
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

      # prevent systemd from killing chil processes
      # KillMode = "process";
    };
    wantedBy = if isSystemService then [ "multi-user.target" ] else [ "default.target" ];
  };
  mkRootService = mkService true;
  mkUserService = mkService false;
  optionType = types.submodule {
    options = {
      startCmd = lib.mkOption { type = types.str; };
      stopSignal = lib.mkOption {
        type = types.enum [
          "C-c"
          "C-d"
        ];
      };
    };
  };
in
{
  options.tmux-services.root = lib.mkOption {
    type = types.attrsOf optionType;
    default = { };
    description = "Create a new tmux service that runs under root";
  };
  options.tmux-services.user = lib.mkOption {
    type = types.attrsOf optionType;
    default = { };
    description = "Create a new tmux service that runs under user(s?)";
  };
  # todo: write a separate service for tmux and bind it to the urbit one
  config =
    let
      rootServiceNames = (builtins.attrNames config.tmux-services.root);
      userServiceNames = (builtins.attrNames config.tmux-services.user);
      haveRootServices = (builtins.length rootServiceNames) > 0;
      haveUserServices = (builtins.length userServiceNames) > 0;
    in
    {
      systemd.services = lib.mkIf haveRootServices (
        {
          "${tmuxServiceName}" = mkTmuxService true rootServiceNames;
        }
        // (lib.attrsets.mapAttrs (
          name: { startCmd, stopSignal, ... }: mkRootService name startCmd stopSignal
        ) config.tmux-services.root)
      );
      systemd.user.services = lib.traceVal lib.mkIf haveUserServices (
        {
          "${tmuxServiceName}" = mkTmuxService false userServiceNames;
        }
        // (lib.attrsets.mapAttrs (
          name: { startCmd, stopSignal, ... }: mkUserService name startCmd stopSignal
        ) config.tmux-services.user)
      );

    };
}
