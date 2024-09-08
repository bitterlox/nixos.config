{ pkgs, addon }: {
  completion = import ./autocompletion { inherit pkgs addon; };
  essentials = import ./essentials { inherit pkgs addon; };
}
