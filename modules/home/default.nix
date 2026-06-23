{ config, pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./terminal.nix
    ./dev.nix
    ./desktop.nix
    ./persistence.nix
  ];
}
