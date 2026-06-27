{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/nixos
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
  };

  programs.fuse.userAllowOther = true;
  services.tlp.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  services.tailscale.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;

  users.users = {
    root = {
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };

    trueking = {
      isNormalUser = true;
      description = "trueking";
      shell = pkgs.fish; 
      extraGroups = [ "networkmanager" "wheel" "input" "video" ];
      hashedPassword = "$y$j9T$FT36B0y7klaP4SEG3eAmL/$Q5BUfiiwJgJbQ.3S6nZCXBnPJVXSZw4VbT.lIqEFFg9";
    };
  };

  programs = {
    mosh.enable = true;
    nh.enable = true;
    git.enable = true;
    kdeconnect.enable = true;
    fish.enable = true;
  };

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
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

  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "librewolf-bin-${pkgs.librewolf-bin.version}"
    "librewolf-bin-unwrapped-${pkgs.librewolf-bin-unwrapped.version}"
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
