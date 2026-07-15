{ config, pkgs, lib, ... }:

let
  imageMimes = [
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/webp"
    "image/bmp"
    "image/tiff"
    "image/svg+xml"
    "image/heic"
    "image/x-tga"
  ];

  textMimes = [
    "text/plain"
    "text/html"
    "text/markdown"
    "text/css"
    "text/javascript"
    "text/x-python"
    "text/x-shellscript"
    "application/json"
    "application/xml"
    "application/javascript"
    "application/x-yaml"
    "application/toml"
  ];

  associate = app: mimes: lib.genAttrs mimes (name: [ app ]);
in
{
  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor = {
      enable = true;
      size = 24;
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = "24";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true; # Suppresses GTK/QT warning messages in Wayland
      addons = with pkgs; [
        fcitx5-chinese-addons # Contains the Pinyin IME for Simplified Chinese
        fcitx5-gtk            # Input support for GTK-based applications
      ];
    };
  };

  home.packages = with pkgs; [
    htop grim slurp libnotify hyprpolkitagent hyprlock
    waybar bluez brightnessctl networkmanagerapplet micro
    ncdu proton-vpn gnome-clocks pavucontrol
    hyprsunset jq nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono wl-clipboard
    epiphany bat ripgrep antigravity-fhs ffmpeg
    trash-cli mission-center chisel code-cursor-fhs obsidian easyeffects opencode
    calibre qview anki vlc localsend
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      (associate "com.interversehq.qView.desktop" imageMimes) //
      (associate "codium.desktop" textMimes);
  };

  programs.mpv = {
    enable = true;
  };

  programs.yt-dlp = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = [
      "--home=/home/trueking/Safe/Obsidian Vault/.configsync"
    ];
  };

  services.playerctld.enable = true;
  services.cliphist.enable = true;
  services.hyprpaper.enable = true;
  services.swaync.enable = true;
  programs.rofi.enable = true;

  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "/persist/etc/nixos/dotfiles/waybar/velvet";
  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/etc/nixos/dotfiles/hypr/hyprland.conf";
  xdg.configFile."Kvantum/kvantum.kvconfig".enable = false;
}
