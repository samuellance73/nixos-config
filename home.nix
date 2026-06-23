{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./modules/home
  ];

  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  programs.home-manager.enable = true;

  home.stateVersion = "26.11";
}