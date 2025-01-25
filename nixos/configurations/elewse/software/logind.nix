{ ... }:
{
  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    # set action to take when all user sessions are idle
    IdleAction=lock
    # action to take when `systemctl sleep` is invoked
    SleepOperation=suspend-then-hibernate
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
