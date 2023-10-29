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

  postStartSettings = ''
    ${ssh-command} settings allow-keyless false
    ${ssh-command} settings anon-access no-access'';

  deleteUsers =
    "${ssh-command} users list | sed 's/admin//g' | xargs -I {} ${ssh-command} users delete {}";

  makeAddNewUsersCmd = user: publicKey:
    "${ssh-command} users create ${user} -a '-k \"${publicKey}\"'"; # had to escape two double quotes here

  addNewUsers = let
    createUserCommands = builtins.attrValues
      (builtins.mapAttrs (username: pubkey: makeAddNewUsersCmd username pubkey)
        soft-serve-config.adminPublicKeys);
  in (lib.strings.concatStringsSep "\n" createUserCommands);

  postStartCommands = "${deleteUsers}";

in ''
  sleep 0.05
  ${postStartSettings}
  ${postStartCommands}
  ${addNewUsers}
''
