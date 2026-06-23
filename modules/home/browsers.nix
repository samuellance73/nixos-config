{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
  ];

  programs.floorp = {
    enable = true;
  };

  stylix.targets.floorp.profileNames = [ "trueking" ];
}
