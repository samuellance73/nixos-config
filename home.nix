{ config, pkgs,lib, inputs, ... }:

{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  # Add your user-specific packages here
  home.packages = with pkgs; [
    htop
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.gnome-bedtime
  ];
  programs.home-manager.enable = true;
   dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };

    # 2. Set Purple Accent Color (GNOME 47+)
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark"; # Recommended for purple theme
      accent-color = "purple";
    };


 };
   

     
       
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
    ];
  };
    
    programs.git = {
    enable = true;
    userName = "TrueKing"; # Change to your name
    userEmail = "samuellance73@gmail.com"; # Change to your email
    };
  home.stateVersion = "25.11";

     
}
