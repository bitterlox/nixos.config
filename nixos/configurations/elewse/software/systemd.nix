{ pkgs, lib, ... }:
{
  # there is a bug about uncommitted efi variables, basically when i resume
  # from hibernate, i can't rebuild-switch anymore because restarting the service
  # systemd-hibernate-clear.service fails due to this efivar bug

  # fix was merged in systemd so just need to wait for a new systemd release
  # and it should be fixed
  # see: https://github.com/systemd/systemd/pull/35497

  # TODO: check back the file src/basic/efivars.c approx line 100 next tagged
  # release to see if it's merged and get it from upstream nixos
  # at which point remove this patch application
  systemd.package = pkgs.systemd.overrideAttrs (old: {
    patches = old.patches ++ [
      (pkgs.fetchurl {
        url = "https://patch-diff.githubusercontent.com/raw/systemd/systemd/pull/35497.patch";
        hash = "sha256-F8sDxHM88IlW5+cZXlEit0l/xLSGF8gFDCyNqqf5XE4=";
      })
    ];
  });
  # some info on sleep states
  # https://docs.kernel.org/admin-guide/pm/sleep-states.html
  systemd.sleep.extraConfig = ''
    # set delay to trigger hibernate when invoking suspend-then-hibernate
    HibernateDelaySec=2h
    # set time to wake up from sleep to check if we're past HibernateDelaySec
    SuspendEstimationSec=30m
  '';
}
