{ config, pkgs,lib, inputs, ... }:

{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  # Add your user-specific packages here
  home.packages = with pkgs; [
    htop

  ];
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
    
  wayland.windowManager.hyprland = {
    enable = true;
    # Stylix will automatically inject colors and hyprpaper config here!
    
    extraConfig = ''
      ################
      ### MONITORS ###
      ################
      monitor=,preferred,auto,1

      ###################
      ### MY PROGRAMS ###
      ###################
      $terminal = kitty
      $fileManager = kitty -e yazi
      $menu = rofi -show drun

      #################
      ### AUTOSTART ###
      #################
      exec-once = waybar & nm-applet & systemctl --user start hyprpolkitagent & dunst 
      exec-once = blueman-applet 
      # ^^^ REMOVED hyprpaper FROM HERE ^^^

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24

      general {
          gaps_in = 5
          gaps_out = 20
          border_size = 2

          # ^^^ REMOVED HARDCODED COLORS HERE SO STYLIX CAN THEME THEM ^^^

          resize_on_border = false
          allow_tearing = false
          layout = dwindle
      }

      decoration {
          rounding = 10
          rounding_power = 2
          active_opacity = 1.0
          inactive_opacity = 1.0
          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }
          blur {
              enabled = true
              size = 3
              passes = 1
              vibrancy = 0.1696
          }
      }

      animations {
          enabled = yes
          bezier = easeOutQuint,   0.23, 1,    0.32, 1
          bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
          bezier = linear,         0,    0,    1,    1
          bezier = almostLinear,   0.5,  0.5,  0.75, 1
          bezier = quick,          0.15, 0,    0.1,  1
          animation = global,        1,     10,    default
          animation = border,        1,     5.39,  easeOutQuint
          animation = windows,       1,     4.79,  easeOutQuint
          animation = windowsIn,     1,     4.1,   easeOutQuint, popin 87%
          animation = windowsOut,    1,     1.49,  linear,       popin 87%
          animation = fadeIn,        1,     1.73,  almostLinear
          animation = fadeOut,       1,     1.46,  almostLinear
          animation = fade,          1,     3.03,  quick
          animation = layers,        1,     3.81,  easeOutQuint
          animation = layersIn,      1,     4,     easeOutQuint, fade
          animation = layersOut,     1,     1.5,   linear,       fade
          animation = fadeLayersIn,  1,     1.79,  almostLinear
          animation = fadeLayersOut, 1,     1.39,  almostLinear
          animation = workspaces,    1,     1.94,  almostLinear, fade
          animation = workspacesIn,  1,     1.21,  almostLinear, fade
          animation = workspacesOut, 1,     1.94,  almostLinear, fade
          animation = zoomFactor,    1,     7,     quick
      }

      dwindle {
          pseudotile = true 
          preserve_split = true 
      }

      master {
          new_status = master
      }

      misc {
          force_default_wallpaper = 0 # <--- CHANGED TO 0
          disable_hyprland_logo = true # <--- CHANGED TO TRUE
      }

      input {
          kb_layout = us
          follow_mouse = 1
          sensitivity = 0 
          touchpad {
              natural_scroll = false
          }
          kb_options = caps:swapescape
      }

      gesture = 3, horizontal, workspace

      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }

      $mainMod = SUPER 

      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo, 
      bind = $mainMod, J, layoutmsg, togglesplit 
      bind = $mainMod, B, exec, flatpak run app.zen_browser.zen
      bind = $mainMod, F, fullscreen, 0
      bind = $mainMod, L, exec, hyprlock

      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      bind = $mainMod, S, togglespecialworkspace, magic
      bind = $mainMod SHIFT, S, movetoworkspace, special:magic

      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous

     # Ignore maximize requests from all apps
      windowrule {
          name = suppress-maximize
          match:class = .*
          suppress_event = maximize
      }
      
      # Fix some dragging issues with XWayland
      windowrule {
          name = fix-xwayland
          match:class = ^$
          match:title = ^$
          match:xwayland = 1
          float = 1
          no_focus = 1
      }
      
      # Hyprland-run windowrule
      windowrule {
          name = move-hyprland-run
          match:class = hyprland-run
          move = 20 monitor_h-120
          float = 1
      
      }
    '';
  };
  
    programs.git = {
    enable = true;
    userName = "TrueKing"; # Change to your name
    userEmail = "samuellance73@gmail.com"; # Change to your email
    };
  home.stateVersion = "25.11";

     
}
