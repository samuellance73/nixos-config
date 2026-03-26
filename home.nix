{ config, pkgs,lib, inputs, ... }:

{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  # Add your user-specific packages here
  home.packages = with pkgs; [
    htop

  ];
  programs.home-manager.enable = true;


  xdg.configFile."Kvantum/kvantum.kvconfig".enable = false;
       
  # Match this to your system.stateVersion in configuration.nix
  home.persistence."/persist" = {
    directories = [
    ".local/share/containers"
    ".local/share/distrobox"
    ".local/share/keyrings"
    ".ssh"
    ".config/hypr"
    ".config/waybar" 
    "Safe"
    ".var/app/app.zen_browser.zen"
    ".nixos-config"
    ];
  };
    
    programs.git = {
    enable = true;
    userName = "TrueKing"; # Change to your name
    userEmail = "samuellance73@gmail.com"; # Change to your email
    };
  home.stateVersion = "25.11";

     
}
