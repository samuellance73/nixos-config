{ config, pkgs, ... }:

{
  imports = [
    ./networking.nix
    ./virtualization.nix
    ./nix-ld.nix
    ./desktop.nix
  ];
}
