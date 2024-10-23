# currently the only functionality here is masking the fprintd service when
# the laptop lid is closed; since we can't use the systemctl command to mask
# we're making a symlink to the systemd transient directory wich is basically
# the same thing
{ pkgs, lib, ... }:
let
  LOCKFILE_PATH = "/tmp/lidswitch-lock";
  script = pkgs.writeShellApplication {
    name = "disable-fprintd";
    runtimeInputs = with pkgs; [ gnugrep systemd coreutils ];
    text = ''
      lock=${LOCKFILE_PATH}
      # when this is = to "masked-runtime" it means it's disabled
      # we exit with 0 because this script is prefixed with set -e
      # and it would exit
      status=$(systemctl is-enabled fprintd.service; exit 0)

      if grep -Fq closed /proc/acpi/button/lid/LID0/state &&
         grep -Fxq connected /sys/class/drm/card1-eDP-1/status
      then
      # second condition handles the following case: on reboot fprintd is
      # started automatically and and the transient symlink probably removed
        echo "lid closed and monitor connected, attempting to disable fprintd."
        if [ ! -f $lock ] || { [ -f "$lock" ] && [ "$status" != "masked-runtime" ]; }; then
          # confirm last addition
          if { [ -f "$lock" ] && [ "$status" != "masked-runtime" ]; }; then
            echo "stale lockfile";
          fi
          touch "$lock"
          systemctl stop fprintd
          ln -s /dev/null /run/systemd/transient/fprintd.service
          systemctl daemon-reload
          echo "disabled fprintd"
        else
          echo "lockfile already present, doing nothing."
        fi
      elif [ -f "$lock" ];
      then
        echo "lid open or monitor disconnected, enabling fprintd."
        rm -f /run/systemd/transient/fprintd.service
        rm "$lock"
        systemctl daemon-reload
        echo "enabled fprintd."
      else
        echo "lid closed, lockfile present, exiting"
      fi
    '';
  };
in {
  # add tmpfile rule for lockfile
  # the bang and age = 0 should yield that this lockfile is removed
  # every reboot
  systemd.tmpfiles.settings = {
    "10-lidswitch"."${LOCKFILE_PATH}"."f" = {
      # keeping other fields (perms, user, etc) to defaults should be good
      age = "-";
    };
  };

  services.acpid = {
    enable = true;
    # thx https://unix.stackexchange.com/questions/678609/
    handlers."fprint-lid" = {
      event = "button/lid.*";
      action = lib.getExe script;
    };
  };
  # getting readonly filesystem error, fix is here
  # https://discourse.nixos.org/t/temporarily-disabling-a-systemd-service/26225/13
  # explore udev bvs acpid
  systemd.services."lid-monitor-lock-check" = {
    after = [ "suspend.target" ];
    wantedBy = [ "multi-user.target" "suspend.target" ];
    serviceConfig = { ExecStart = lib.getExe script; };
    unitConfig = {
      Description =
        "disables/enables fprintd depending on laptop lid/external monitor";
    };
  };
}

