{ config, pkgs,lib, inputs, ... }:

{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  # Add your user-specific packages here
  home.packages = with pkgs; [
    htop
    grim
    slurp
    kitty
    libnotify
    hyprpolkitagent
    hyprlock
    waybar
    bluez
    brightnessctl
    networkmanagerapplet
    fzf
    micro
    ncdu
    protonvpn-gui
    vscode-fhs
    hyprpolkitagent
    wl-clipboard
    pavucontrol
    hyprsunset
    jq               
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
     
  ];
  
  services.hyprpaper.enable = true; 
  services.dunst = {
  enable = true;
  };
  programs.yazi = {
  enable = true;
  };
  programs.rofi.enable = true;
  programs.home-manager.enable = true;
  
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "/persist/etc/nixos/dotfiles/waybar/mech";
  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/etc/nixos/dotfiles/hypr/hyprland.conf";
  xdg.configFile."Kvantum/kvantum.kvconfig".enable = false;
       
  # Match this to your system.stateVersion in configuration.nix
  home.persistence."/persist" = {
    directories = [
    ".local/share/containers"
    ".local/share/distrobox"
    ".local/share/keyrings"
    ".ssh"
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
