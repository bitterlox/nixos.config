{ pkgs, lib, ... }:
# used this guide to figure out how to write udev rules
# - http://reactivated.net/writing_udev_rules.html
# commands used to debug this issue:
# udevadm control ( --property )
# - this shows like udev events as they come in
# udevadm control --log-priority debug
# - sets udev loglevel
# - with journalctl -u systemd-udevd.service
# dmesg -w
# - shows mouse connecting? -w is follow option
let
  LOCKFILE_PATH = "/tmp/add-magicmouse-lock";
  MODPROBE_OPTIONS =
    "scroll_acceleration=1 scroll_speed=20 emulate_3button=1 emulate_scroll_wheel=1";
  script-udev = pkgs.writeShellApplication {
    name = "magic-mouse-2-add.sh";
    runtimeInputs = [ pkgs.kmod ];
    # the first 'sleep 1' is so udev properly loads the battery from the mouse
    # otherwise it show battery capacity as 0 
    # btw the mouse battery can be found at
    # /sys/devices/virtual/misc/uhid/<id>/power_supply/hid-<mac-address>-battery/capacity
    text = ''
        FILE=${LOCKFILE_PATH}

        reload() {
          if [ ! -f "$FILE" ]; then
            touch $FILE

            sleep 1

            modprobe -r hid_magicmouse
            modprobe hid_magicmouse ${MODPROBE_OPTIONS}

            sleep 2
            rm -f "$FILE"

            fi
        }

      echo "reloading hid_magicmouse kmod"

      reload

      echo "reloaded hid_magicmouse kmod"
    '';
  };
in {

  # set my preferred options at boot
  boot.extraModprobeConfig = ''
    options hid_magicmouse ${MODPROBE_OPTIONS}
  '';

  # powerManagement.resumeCommands = ''
  #   modprobe -r hid_magicmouse && modprobe hid_magicmouse
  #   echo "restarted hid_magicmouse kernel module"
  # '';

  systemd.tmpfiles.settings = {
    "10-add-magicmouse"."${LOCKFILE_PATH}"."f" = {
      # keeping other fields (perms, user, etc) to defaults should be good
      # iirc this makes it so systemd never toucher this file and we manage it
      # manually
      age = "-";
    };
  };

  services.udev = {
    # http://reactivated.net/writing_udev_rules.html#sysfsmatch
    enable = true;
    # this works but maybe runs extra times, as we are targeting
    # bluetooth devices connecting
    extraRules = ''
      ACTION=="add", \
      KERNEL=="hci0:*", \
      SUBSYSTEM=="bluetooth", \
      SUBSYSTEMS=="usb", \
      DRIVERS=="btusb", \
      RUN+="${lib.getExe script-udev}"
    '';
    # this worked but not completely:
    # we targeted this attribute which is changed on every reconnect.
    # this causes an infinite loop because it also changes
    # when we reload the kmod
    # extraRules = ''
    #   ATTR{power/wakeup_last_time_ms}=="*", \
    #   SUBSYSTEMS=="hid", \
    #   DRIVERS=="magicmouse", \
    #   RUN+="${lib.getExe script-udev}"
    # '';
  };

}
