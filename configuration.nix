{ config, pkgs, inputs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  hardware.graphics.enable = true;
  zramSwap.enable = true;

  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth = {
     enable = true;
  };
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  fileSystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  programs.fuse.userAllowOther = true;

  environment.persistence."/persist" = {
    hideMounts = true;
    directories =[
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/containers"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  networking = {
    hostName = "latitude";
    networkmanager.enable = true;

    hosts = {
      "0.0.0.0" =[
        "www.arras.io"
        "arras.io"
        "www.arrax.io"
        "arrax.io"
        "www.evowars.io"
        "evowars.io"
        "www.gats.io"
        "gats.io"
        "www.buildroyale.io"
        "buildroyale.io"
        "wyoutube.com"
        "www.wyoutube.com"
      ];
    };
  };


  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";


  stylix = {
    enable = true;
    image = ./wallpapers/city-horizon.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    
  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
    


  
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  services.blueman.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  users.users = {
    root = {
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };

    trueking = {
      isNormalUser = true;
      description = "trueking";
      extraGroups =[ "networkmanager" "wheel" "input" "video" ];
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  services.flatpak.enable = true;

  programs = {
    nh.enable = true;
    git.enable = true;
    nix-ld.enable = true;

    kdeconnect = {
      enable = true;
    };
  };


  environment.systemPackages = with pkgs;[
    curl
    distrobox
    steam-run
    vim
    wget
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.trueking = import ./home.nix;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features =[ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  system.stateVersion = "25.11";
}
