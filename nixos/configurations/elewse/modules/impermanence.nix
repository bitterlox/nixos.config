impermanenceModule:
{ config, lib, ... }: {
  imports = [ impermanenceModule ];
  config = {
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
    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        # wifi connections
        "/etc/NetworkManager/system-connections"
        # battery charge data
        "/var/lib/upower"
      ];
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
    };

    # manually create bind mounts using nixos filesystem facilities
    # so that we can mount these before agenix runs and needs ssh keys
    # to decrypt secrets
    fileSystems = let
      paths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    in builtins.listToAttrs (builtins.map (path:
      lib.attrsets.nameValuePair path {
        device = "/persist" + path;
        fsType = "none";
        neededForBoot = true;
        #depends = [ "/persist" ];
        options = [ "bind" "ro" ];
      }) paths);

    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';
  };
}
