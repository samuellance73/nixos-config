{ config, pkgs, inputs, ... }:

{
  boot = {
    kernelParams = [  ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs;[
      intel-media-driver # The modern video decoding driver for Intel Iris Xe
      libvdpau-va-gl
    ];
  };
  zramSwap.enable = true;
  services.thermald.enable = true;
  services.fwupd.enable = true;
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
  services.tlp = {
    enable = true;
  };
  services.cloudflare-warp.enable = true;


  programs.virt-manager.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables; 
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };




  environment.persistence."/persist" = {
    hideMounts = true;
    directories =[
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/containers"
      "/var/lib/waydroid/images"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  networking = {
    networkmanager.enable = true;
    firewall.trustedInterfaces = [ "waydroid0" ];
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
	      "www.shellshock.io"
	      "shellshock.io"
      ];
    };
  };


  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  services.tailscale.enable = true;

  stylix = {
    enable = true;
    image = ./wallpapers/city-horizon.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets.kmscon.enable = false;
    
  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  }; 

  
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  
  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
  };

  services.blueman.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.fish.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk # Required for file picking and as a fallback
    ];
    config.common.default = "*"; # Essential for newer portal versions
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
      shell = pkgs.fish; 
      extraGroups =[ "networkmanager" "wheel" "input" "video" ];
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };
  };





  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  
programs.mosh.enable = true;
  services.flatpak.enable = true;
 services.zapret = {
    enable = true;
    
     params =[
/*
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
      "--dpi-desync-fake-tls=0x00000000"
      "--dpi-desync-fake-tls=!"
      "--dpi-desync-fake-tls-mod=rnd,rndsni,dupsid"

*/
      "--dpi-desync=split2"           
      "--dpi-desync-split-pos=midsld" 
      "--dpi-desync-fooling=md5sig"
      "--hostcase"     
 

];
  
  };

/*
    networking.nameservers = [
    "1.1.1.1"

   "8.8.8.8#dns.google" 
    "8.8.4.4#dns.google" 
    ];*/

services.cloudflared = {
  enable = true;
};
networking.hostName = "latitude";
networking.nameservers =[ "127.0.0.1"];
networking.networkmanager.dns = "none";

  # 3. Enable and configure the DNS over HTTPS proxy
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      # Require DNS requests to be encrypted and verified
      require_dnssec = true;
      require_nolog = true; # Only use servers that don't log your history
      
      server_names =[ "cloudflare" "google" ];
      

    };
  };
  
networking.firewall.checkReversePath = "loose";



/*
    services.resolved = {
    enable = true;
    };*/
  programs = {
    nh.enable = true;
    git.enable = true;
    nix-ld.enable = true;
  nix-ld.libraries = with pkgs; [
    # --- Your existing libraries ---
    stdenv.cc.cc.lib       
    zlib
    fuse3                  
    icu
    nss
    openssl
    curl
    expat
    nspr
    atk
    at-spi2-atk
    libdrm
    mesa
    alsa-lib
    dbus
    libxkbcommon
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libglvnd

    # --- ADD THESE FOR GEPH ---
    glib                # Fixes the libgio-2.0.so.0 error
    gtk3                # Required for the windowing system
    webkitgtk_4_1       # Required for the Geph GUI (Wry WebView)
    pango               # Text rendering
    cairo               # Graphics rendering
    gdk-pixbuf          # Image loading
    libsoup_3           # Network support for the WebView
    libsecret           # Often needed for credential storage
  ];
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
    tree
    killall
    file
    
    ripgrep
    
    fzf
    btop
    eza
    tmux
    file-roller # The GUI archive manager
    p7zip       # Support for .7z
    unzip       # Support for .zip
    zip
    rar         # Support for .rar

    gcc

    gnumake

];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.trueking = import ./home.nix;
  };

  nixpkgs.config.allowUnfree = true;

nix = {
  settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
};

# Optimise storage by hard-linking duplicate files
nix.settings.auto-optimise-store = true;

  system.stateVersion = "25.11";
}
