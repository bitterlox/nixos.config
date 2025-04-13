username: inputs: ownPackages:
{ ... }:
{

  imports = [
    (import ./system username inputs)
  ];

  environment.systemPackages =
    let
      p = ownPackages;
    in
    [
      p.nvim-full
    ];
}
