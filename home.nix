{ config, pkgs,lib, inputs, ... }:

{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  # Add your user-specific packages here
  home.packages = with pkgs; [
    htop
    kitty
    libnotify
     
  ];
  services.dunst = {
  enable = true;
  };
  programs.yazi = {
  enable = true;
  };
    programs.rofi.enable = true;
  programs.home-manager.enable = true;
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 0;
        modules-left = [ "hyprland/workspaces" "custom/weather" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "network" "backlight" "battery" "tray" "clock" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };

        "hyprland/window" = {
          format = " 󰣆  {title}";
          max-length = 40;
        };

        "tray" = {
          icon-size = 18;
          spacing = 10;
        };

        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "󰃭  {:%A, %B %d, %Y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        "backlight" = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          min-length = 6;
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          tooltip = false;
          format-muted = " Muted";
          on-click = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };

        "network" = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀  {ipaddr}/{cidr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{essid} - {ifname} via {gwaddr}";
          on-click = "nm-connection-editor";
        };
      };
    };

    # This is where we use Stylix colors in your CSS
    style = ''
      * {
          border: none;
          border-radius: 0;
          /* Stylix will handle the font automatically, but we can specify it here too */
          font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: transparent;
          color: @base05; /* Stylix Text Color */
      }

      #workspaces, #window, #clock, #pulseaudio, #network, #backlight, #battery, #tray {
          background: @base00; /* Stylix Background Color */
          padding: 0px 15px;
          margin: 5px 3px;
          border-radius: 15px;
          border: 1px solid @base02; /* Stylix Muted Border */
      }

      #workspaces button {
          padding: 0 5px;
          color: @base0D; /* Stylix Blue */
      }

      #workspaces button.active {
          color: @base0E; /* Stylix Purple/Pink */
      }

      #workspaces button.urgent {
          color: @base08; /* Stylix Red */
      }

      #window { color: @base05; }
      #clock { color: @base09; }      /* Stylix Orange */
      #pulseaudio { color: @base0A; } /* Stylix Yellow */
      #network { color: @base0B; }    /* Stylix Green */
      #backlight { color: @base0C; }  /* Stylix Cyan */
      #battery { color: @base0D; }    /* Stylix Blue */

      #battery.charging { color: @base0B; }
      #battery.warning:not(.charging) { color: @base09; }
      #battery.critical:not(.charging) {
          color: @base08;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      @keyframes blink {
          to {
              background-color: @base08;
              color: @base00;
          }
      }
    '';
  };

  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "/persist/etc/nixos/dotfiles/hyprland.conf";

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
