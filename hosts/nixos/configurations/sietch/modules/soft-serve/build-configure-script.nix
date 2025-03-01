{ pkgs, ssh-private-key-path, soft-serve-config }:
let
  lib = pkgs.lib;
  openssh = pkgs.openssh;

  ssh-command = ''
    ${openssh}/bin/ssh \
    -i ${ssh-private-key-path} \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o LogLevel=QUIET \
    -p ${(builtins.toString soft-serve-config.ports.ssh)} \
    localhost'';

  # not going to work i think, it would be pretty normal for it to work that
  # when you run an ssh command and it returns the sql op is done;
  padding = "sleep 0.01";

  postStartSettings = ''
    ${ssh-command} settings allow-keyless false
    ${ssh-command} settings anon-access no-access'';

  deleteUsers =
    "${ssh-command} users list | sed 's/admin//g' | xargs -I {} ${ssh-command} users delete {}; ${padding};";

  makeAddNewUsersCmd = user: publicKey:
    "${ssh-command} users create ${user} -a '-k \"${publicKey}\"'"; # had to escape two double quotes here

  addNewUsers = let
    createUserCommands = builtins.attrValues
      (builtins.mapAttrs (username: pubkey: makeAddNewUsersCmd username pubkey)
        soft-serve-config.adminPublicKeys);
    padded = pkgs.lib.lists.flatten
      (builtins.map (e: [ e padding ]) createUserCommands);
  in (lib.strings.concatStringsSep "\n" padded);

in ''
  sleep 0.05
  echo "running post-start"
  ${postStartSettings}
  echo "applied server settings"
  sleep 0.01
  ${deleteUsers}
  echo "deleted old users"
  ${addNewUsers}
  echo "created new users as per config"
''
