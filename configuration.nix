{ config, pkgs, inputs, ... }:

{
  # ==========================================
  # BOOTLOADER & KERNEL
  # ==========================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
  };
#Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
   # nerd-fonts.symbols-only
  ];

  # ==========================================
  # HARDWARE & OPTIMIZATIONS
  # ==========================================
  hardware.graphics.enable = true;
  zramSwap.enable = true;

  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth = {
     enable = true;
  };

  # ==========================================
  # FILE SYSTEMS & STORAGE
  # ==========================================
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  fileSystems = {
    "/persist".neededForBoot = true;
    "/var/log".neededForBoot = true;
  };

  # ==========================================
  # IMPERMANENCE
  # ==========================================
  # Note: Requires the impermanence NixOS module to be imported in your flake.
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

  # ==========================================
  # NETWORKING
  # ==========================================
  networking = {
    hostName = "latitude";
    networkmanager.enable = true;

    # Block distracting websites
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

  # ==========================================
  # TIMEZONE & LOCALE
  # ==========================================
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # ==========================================
  # DESKTOP ENVIRONMENT (GNOME)
  # ==========================================
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;
  };
  services.blueman.enable = true;
  programs.hyprland = {
    enable = true;
    # xwayland.enable = true; # Enabled by default, useful for older apps
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

  # ==========================================
  # USERS & AUTHENTICATION
  # ==========================================
  users.users = {
    root = {
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };

    trueking = {
      isNormalUser = true;
      description = "trueking";
      extraGroups =[ "networkmanager" "wheel" ];
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };
  };

  # ==========================================
  # VIRTUALISATION
  # ==========================================
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Create a `docker` alias for podman
    defaultNetwork.settings.dns_enabled = true; # Required for podman-compose
  };

  # ==========================================
  # PROGRAMS & SERVICES
  # ==========================================
  services.flatpak.enable = true;

  programs = {
    nh.enable = true;
    
    git.enable = true;
    nix-ld.enable = true;

    # GSConnect (KDE Connect implementation for GNOME)
    kdeconnect = {
      enable = true;
    };
  };

  # ==========================================
  # SYSTEM PACKAGES
  # ==========================================
  environment.systemPackages = with pkgs;[
    amneziawg-tools
    curl
    distrobox
    kitty
    yazi
    micro
    ncdu
    neovim
    protonvpn-gui
    steam-run
    vscode-fhs
    vim
    wget

    waybar
    dunst
    libnotify
    rofi
    wl-clipboard
    pavucontrol
    networkmanagerapplet
    
    
  ];

  # ==========================================
  # HOME MANAGER
  # ==========================================
  # Note: Requires home-manager NixOS module to be imported in your flake.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.trueking = import ./home.nix;
  };

  # ==========================================
  # NIX SETTINGS
  # ==========================================
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features =[ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # ==========================================
  # STATE VERSION
  # ==========================================
  system.stateVersion = "25.11";
}
