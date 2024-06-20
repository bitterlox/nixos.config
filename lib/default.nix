# this is akin to a flake-parts top-level module
{ ... }: {
  flake.lib = {
    # see nixOS options, inhibitSleep
    defaultBorgOptions = { passphrasePath, sshKeyPath }: {
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${passphrasePath}";
      };
      environment = {
        BORG_RSH = ''
          ssh -o 'StrictHostKeyChecking=no' -o 'IdentitiesOnly=yes' -i ${sshKeyPath}
        '';
      };
      compression = "auto,zstd";
      #extraArgs = "--debug";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      # run service unit if system was shutdown and timer would've triggered it
      persistentTimer = true;
    };
  };
}
