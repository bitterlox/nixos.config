{ pkgs, lib, ... }:
let
  LOCKFILE_PATH = "/tmp/add-magicmouse-lock";
  MODPROBE_OPTIONS =
    "scroll_acceleration=1 scroll_speed=20 emulate_3button=1 emulate_scroll_wheel=1";
  script-udev = pkgs.writeShellApplication {
    name = "magic-mouse-2-add.sh";
    runtimeInputs = [ pkgs.kmod ];
    text = ''
          FILE=${LOCKFILE_PATH}

          reload() {
            if [ ! -f "$FILE" ]; then
              touch $FILE

                modprobe -r hid_magicmouse
                sleep 2
                modprobe hid-generic
                modprobe hid_magicmouse ${MODPROBE_OPTIONS}

                sleep 2
                rm -f "$FILE"

                fi
          }

        reload &
    '';
  };
  script-systemd = pkgs.writeShellApplication {
    name = "magic-mouse-2-add.sh";
    runtimeInputs = [ pkgs.kmod ];
    text = ''
      modprobe -r hid_magimagic-mouse-2-add.shcmouse && modprobe hid_magicmouse
      echo "restarted hid_magicmouse kernel module"
    '';
  };

in {

  # this configures the kernel module for apple magicmouse
  # FIXME: whenever it sleeps or smth and then starts back up scroll doesnt work
  boot.extraModprobeConfig = ''
    options hid_magicmouse ${MODPROBE_OPTIONS}
  '';

  # powerManagement.resumeCommands = ''
  #   modprobe -r hid_magicmouse && modprobe hid_magicmouse
  #   echo "restarted hid_magicmouse kernel module"
  # '';

  # systemd.services.restart-magicmouse-kmod = {
  #   description = "Service description here";
  #   # wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" "post-resume.target" ];
  #   wantedBy = [
  #     "suspend.target"
  #     "hibernate.target"
  #     "hybrid-sleep.target"
  #     "suspend-then-hibernate.target"
  #   ];
  #   after = [
  #     "suspend.target"
  #     "hibernate.target"
  #     "hybrid-sleep.target"
  #     "suspend-then-hibernate.target"
  #   ];
  #   script = (lib.getExe script-systemd);
  #   serviceConfig.Type = "oneshot";
  # };

  systemd.tmpfiles.settings = {
    "10-add-magicmouse"."${LOCKFILE_PATH}"."f" = {
      # keeping other fields (perms, user, etc) to defaults should be good
      # iirc this makes it so systemd never toucher this file and we manage it
      # manually
      age = "-";
    };
  };

  # services.udev = {
  #   enable = true;
  #   extraRules = ''
  #     SUBSYSTEM=="input", \
  #     KERNEL=="mouse*", \
  #     DRIVER=="", \
  #     SUBSYSTEMS=="hid", \
  #     KERNELS=="0005:004C:0269*", \
  #     DRIVERS=="hid-generic|magicmouse", \
  #     ACTION=="add", \
  #     SYMLINK+="input/magicmouse-%k", \
  #     RUN+="${lib.getExe script-udev}"
  #   '';
  # };

}
