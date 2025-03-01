impermanenceModule:
{ config, lib, pkgs, ... }: {
  imports = [ impermanenceModule ];
  config = {
    # snapshot persist before shutting down
    systemd.services.snapshot-persist = {
      before = [ "halt.target" "shutdown.target" "reboot.target" ];
      unitConfig = {
        Description = "Service that snapshots /persist before shutdown";
        DefaultDependencies = "no";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        ${config.systemd.package.util-linux}/bin/mount -o subvol=/ /dev/lvg/root /mnt

        if [ -e /mnt/persist-bak ]; then
          echo "deleting old /persist backup"
          ${pkgs.btrfs-progs}/bin/btrfs subvolume delete /mnt/persist-bak
        fi

        echo "backing up current /persist"
        ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot -r /mnt/persist/ /mnt/persist-bak

        # unmount and continue shutdown
        ${config.systemd.package.util-linux}/bin/umount /mnt
      '';
      wantedBy = [ "halt.target" "shutdown.target" "reboot.target" ];
    };
    # wipe file system on boot
    boot.initrd = {
      enable = true;
      supportedFilesystems = [ "btrfs" ];

      systemd.enable = true;
      systemd.services.restore-root = {
        description = "Rollback btrfs rootfs";
        wantedBy = [ "initrd.target" ];
        requires = [
          "dev-lvg-root.device" # see man 5 systemd.device
        ];
        after = [
          "dev-lvg-root.device"
          # for luks
          "systemd-cryptsetup@${config.networking.hostName}.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt

          # We first mount the btrfs root to /mnt
          # so we can manipulate btrfs subvolumes.
          mount -o subvol=/ /dev/lvg/root /mnt

          # While we're tempted to just delete /root and create
          # a new snapshot from /root-blank, /root is already
          # populated at this point with a number of subvolumes,
          # which makes `btrfs subvolume delete` fail.
          # So, we remove them first.
          #
          # /root contains subvolumes:
          # - /root/var/lib/portables
          # - /root/var/lib/machines
          #
          # I suspect these are related to systemd-nspawn, but
          # since I don't use it I'm not 100% sure.
          # Anyhow, deleting these subvolumes hasn't resulted
          # in any issues so far, except for fairly
          # benign-looking errors from systemd-tmpfiles.
          btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          # Once we're done rolling back to a blank snapshot,
          # we can unmount /mnt and continue on the boot process.
          umount /mnt
        '';
      };
    };
    # configure impermanence
    # there's a bug which is not allowing me to impermanate /home
    # https://github.com/nix-community/home-manager/issues/5421
    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        # this is important to have deterministic UIDs/GIDs
        # https://github.com/nix-community/impermanence/issues/178
        "/var/lib/nixos"
        # wifi connections
        "/etc/NetworkManager/system-connections"
        # bluetooth connections
        "/var/lib/bluetooth"
        # battery charge data
        "/var/lib/upower"
        # fingerprint sensor data
        "/var/lib/fprint"
      ];
      #      ++ [
      #        # handled by hm
      #        # ".bash_profile"
      #        # ".bashrc"
      #
      #        # these are caches, delete
      #        # ".cache"
      #        # ".compose-cache"
      #
      #        # nuke for now, keep only .config/obsidian
      #        # ".config"
      #        "/home/angel/.config/obsidian"
      #
      #        # keep all of these
      #        "/home/angel/Desktop"
      #        "/home/angel/Documents"
      #        "/home/angel/Downloads"
      #        "/home/angel/.gnupg"
      #
      #        # handled by hm
      #        # ".gtkrc-2.0"
      #        # seems mostly cache-like stuff, maybe can try to persist
      #        # tofi and nvim stuff if they do wierd stuff
      #        # ".local"
      #
      #        # keep all of these
      #        "/home/angel/.mozilla"
      #        "/home/angel/Music"
      #
      #        # delete, handled by nix / hm
      #        # ".nix-defexpr"
      #        # ".nix-profile"
      #
      #        # keep all of these
      #        "/home/angel/.nvim"
      #        "/home/angel/.password-store"
      #        "/home/angel/Pictures"
      #
      #        # this is needed by gnome keyring, delete for now
      #        # ".pki"
      #
      #        # handled by hm
      #        # ".profile"
      #
      #        # keep all of these
      #        "/home/angel/Public"
      #
      #        # handled by hm
      #        # ".ssh"
      #        "/home/angel/Templates"
      #        "/home/angel/Videos"
      #      ];
      files = [
        # this because someone said it's important?
        "/etc/machine-id"
        # etc shadow is created before we have a chance to bind-mount it
        #"/etc/shadow"
        # this because i forget commands
        "/root/.bash_history"
        # this to avoid mashing y every time i switch config
        "/root/.local/share/nix/trusted-settings.json"
        # this to avoid re-confirming every time i ssh to my servers
        "/root/.ssh/known_hosts"

      ];
      #      ++ [ "/home/angel/.bash_history" "/home/angel/.ssh/known_hosts" ];
    };

    # manually create bind mounts using nixos filesystem facilities
    # so that we can mount these before agenix runs and needs ssh keys
    # to decrypt secrets
    fileSystems = let
      paths = [
        # ssh host keys
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          extraOptions = [ "ro" ];
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key.pub";
          extraOptions = [ "ro" ];
        }
        {
          path = "/etc/ssh/ssh_host_rsa_key";
          extraOptions = [ "ro" ];
        }
        {
          path = "/etc/ssh/ssh_host_rsa_key.pub";
          extraOptions = [ "ro" ];
        }
        # secure boot keys
        {
          path = "/etc/secureboot";
          extraOptions = [ "rw" ];
        }
      ];
    in builtins.listToAttrs (builtins.map ({ path, extraOptions }:
      lib.attrsets.nameValuePair path {
        device = "/persist" + path;
        fsType = "none";
        neededForBoot = true;
        #depends = [ "/persist" ];
        options = [ "bind" ] ++ extraOptions;
      }) paths);

    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';
  };
}
