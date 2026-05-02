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
    proton-vpn
    vscode-fhs
    
    pavucontrol
    hyprsunset
    jq
    neovim               
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    zoxide 
    wl-clipboard
    nixd
    epiphany
    bat
    ripgrep
    antigravity-fhs
    ffmpeg
    zed-editor-fhs
    github-cli
  ];
  services.playerctld.enable = true;


  programs.librewolf={
    enable=true;

    policies = {

    };

    profiles.default = {
     extensions.packages = with pkgs.nur.repos.rycee.firefox-addons;[
        vimium-c
        bitwarden
        darkreader
        temporary-containers
      ];

    settings = {

      
      "privacy.resistFingerprinting" = false;

      "privacy.fingerprintingProtection" = true;

      "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";

      "layout.css.prefers-color-scheme.content-override" = 0;
      
      
      };

    };
  };


  services.cliphist.enable = true;
  services.hyprpaper.enable = true; 
 services.swaync = {
  enable = true;
  # settings = { ... }; # Optional: JSON config here
  # style = '' ... '';  # Optional: CSS styling here
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
    ];
  };
    
 
  
    programs.git = {
    enable = true;
    settings = {
      user = {
        name = "TrueKing";
        email = "samuellance73@gmail.com";
      };
    };
    };
  home.stateVersion = "25.11";

     
}
