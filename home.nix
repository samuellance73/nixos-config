{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  ffultima-src = builtins.fetchTarball {
    url = "https://github.com/soulhotel/FF-ULTIMA/archive/refs/tags/v4.3.tar.gz";
    sha256 = "0cpwxr70xfd43pf08jqsm8jbni71gjg393qczcmd35ccwnpj3kfa";
  };
in
{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  home.packages = with pkgs; [
    htop grim slurp kitty libnotify hyprpolkitagent hyprlock
    waybar bluez brightnessctl networkmanagerapplet micro
    ncdu proton-vpn vscode-fhs gnome-clocks pavucontrol
    hyprsunset jq neovim nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono wl-clipboard nixd
    epiphany bat ripgrep antigravity-fhs ffmpeg
    zed-editor-fhs github-cli
  ];
  programs.mpv = {
  enable = true;
  };
  programs.yt-dlp = {
  enable = true;
  };
  programs.fzf = {
  enable = true;
  };
programs.fish = {
  enable = true;
};
programs.zoxide = {
  enable = true;
  enableBashIntegration = true;
    enableFishIntegration = true;
};

  services.playerctld.enable = true;

  programs.librewolf = {
    enable = true;
    profiles.default = {

      id = 0;
      name = "default";
      isDefault = true;



      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "layers.acceleration.force-enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
        "layout.css.prefers-color-scheme.content-override" = 0;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "user.theme.catppuccin-mocha" = true;
      #  "ultima.sidebar.autohide" = true;
      #  "ultima.navbar.autohide" = true;
      };



      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        vimium-c
        bitwarden
        darkreader
        temporary-containers
        violentmonkey
        buster-captcha-solver
        bypass-paywalls-clean
        sponsorblock
        dearrow
        multi-account-containers
        sidebery
      ];
    };

    profiles.real = {
      id = 1;
      name = "real";

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        vimium-c
        bitwarden
        darkreader
        temporary-containers
        violentmonkey
        buster-captcha-solver
        bypass-paywalls-clean
        sponsorblock
        dearrow
        multi-account-containers
        sidebery
      ];

      settings = {
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
        "layout.css.prefers-color-scheme.content-override" = 0;
      };
    };
  };

  # 4. Link the theme files (using the correct variable name)
  home.file.".librewolf/default/chrome".source = ffultima-src;
  services.cliphist.enable = true;
  services.hyprpaper.enable = true;

  services.swaync = {
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

  home.persistence."/persist" = {
    directories = [
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/keyrings"
      ".librewolf/real"
      ".ssh"
      "Safe"
      ".var/app/app.zen_browser.zen"
    ];
  };

  programs.git = {
    enable = true;
    userName = "TrueKing";
    userEmail = "samuellance73@gmail.com";
  }; # Fixed missing braces here

  home.stateVersion = "24.11"; # Fixed version number
}