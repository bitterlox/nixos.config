# this nixos module defines behaviour that should trigger when we close
# the laptop lid and are connected to an external display
{ pkgs, lib, ... }:
let
  LOCKFILE_PATH = "/tmp/lidswitch-lock";
  script = pkgs.writeScript "ctrl-fprintd-lid-switch" ''
    lock=${LOCKFILE_PATH}

    if grep -Fq closed /proc/acpi/button/lid/LID0/state &&
       grep -Fxq connected /sys/class/drm/card1-eDP-1/status
    then
      touch "$lock"
      systemctl stop fprintd
      systemctl disable fprintd
    elif [ -f "$lock" ]
    then
      systemctl enable fprintd
      systemctl start fprintd
      rm "$lock"
    fi
  '';
  runScript = "${lib.getExe pkgs.bash} ${script}";
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
      action = runScript;
    };
  };
  # getting readonly filesystem error, fix is here
  # https://discourse.nixos.org/t/temporarily-disabling-a-systemd-service/26225/13
  # explore udev bvs acpid
  systemd.services."lid-monitor-lock-check" = {
    after = [ "suspend.target" ];
    wantedBy = [ "multi-user.target" "suspend.target" ];
    serviceConfig = { ExecStart = runScript; };
    unitConfig = {
      Description = "runs script for lapotop lid/fprintd on reboot";
    };
  };
}

