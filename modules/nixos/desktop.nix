{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Display Manager and Windowing
  services.displayManager.gdm.enable = true;
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Sound/Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # File Manager (Thunar) and support services
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports for local network transfers
  };
}
