# this is akin to a flake-parts top-level module
{
  imports = [
    ./configurations/chani
    ./configurations/sietch
    ./configurations/elewse
    ./shared-modules
  ];
}
