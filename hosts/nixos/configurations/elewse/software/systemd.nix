{ pkgs, lib, ... }:
{
  # some info on sleep states
  # https://docs.kernel.org/admin-guide/pm/sleep-states.html
  systemd.sleep.extraConfig = ''
    # set delay to trigger hibernate when invoking suspend-then-hibernate
    HibernateDelaySec=2h
    # set time to wake up from sleep to check if we're past HibernateDelaySec
    SuspendEstimationSec=30m
  '';
}
