# this is a home-manager module
{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # tweak the PS1 depending if it's on linux or mac; in either case
    # i like the ones that turn red if we're root
    bashrcExtra = ''
      export PS1='\h:\w \u\$ '
    '';
    # set some aliases, feel free to add more or remove some
    # shellAliases = {
    #   k = "kubectl";
    #   urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    #   urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    # };
  };
}
