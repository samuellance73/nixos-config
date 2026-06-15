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

  # 1. List of all image MIME types
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

  # 2. List of all text and text-like MIME types
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

  # 3. Simple helper to generate associations
  associate = app: mimes: lib.genAttrs mimes (name: [ app ]);

  # Shared settings across both profiles
  librewolfSettings = {
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
    "webgl.disabled" = false;
    "librewolf.webgl.prompt" = false;

    #BETTERFOX FASTFOX
    "nglayout.initialpaint.delay" = 5;
    "nglayout.initialpaint.delay_in_oopif" = 5;
    "gfx.content.skia-font-cache-size" = 32;
    "content.notify.ontimer" = true;
    "content.notify.interval" = 100000;
    "content.max.tokenizing.time" = 1000000;
    "content.interrupt.parsing" = true;
    "content.switch.threshold" = 300000;
    "content.maxtextrun" = 8191;
    "browser.newtab.preload" = true;
    "dom.ipc.processPriorityManager.backgroundUsesEcoQoS" = false;
    "browser.sessionstore.restore_on_demand" = true;
    "browser.sessionstore.restore_pinned_tabs_on_demand" = true;
    "browser.sessionstore.restore_tabs_lazily" = true;
    "browser.startup.preXulSkeletonUI" = false;
    "dom.iframe_lazy_loading.enabled" = true;
    "dom.enable_web_task_scheduling" = true;

    # SECTION: GFX RENDERING TWEAKS
    "gfx.webrender.all" = true;
    "gfx.canvas.accelerated" = true;
    "layers.gpu-process.enabled" = true;
    "media.hardware-video-decoding.enabled" = true;
    
    # SECTION: DISK CACHE
    "browser.cache.disk.smart_size.enabled" = false;
    "browser.cache.disk.capacity" = 512000;
    "browser.cache.disk.max_entry_size" = 51200;
    "network.http.rcwn.enabled" = false;
    "network.http.rcwn.small_resource_size_kb" = 256;
    "browser.cache.disk.metadata_memory_limit" = 16384;
    "browser.cache.disk.preload_chunk_count" = 4;
    "browser.cache.frecency_half_life_hours" = 6;
    "browser.cache.disk.max_chunks_memory_usage" = 40960;
    "browser.cache.disk.max_priority_chunks_memory_usage" = 40960;
    "browser.cache.check_doc_frequency" = 3;
    "browser.cache.disk.free_space_soft_limit" = 10240;
    "browser.cache.disk.free_space_hard_limit" = 2048;
    "browser.cache.jsbc_compression_level" = 3;
    "dom.script_loader.bytecode_cache.enabled" = true;
    "dom.script_loader.bytecode_cache.strategy" = 0;
    
    # SECTION: MEMORY CACHE
    "browser.cache.memory.capacity" = 131072;
    "browser.cache.memory.max_entry_size" = 20480;
    "browser.sessionhistory.max_total_viewers" = 4;
    "browser.sessionstore.max_tabs_undo" = 10;
    "dom.storage.default_quota" = 20480;
    "dom.storage.shadow_writes" = true;

    # SECTION: MEDIA CACHE
    "media.cache_size" = 512000;
    "media.memory_caches_combined_limit_kb" = 1048576;
    "media.memory_caches_combined_limit_pc_sysmem" = 5;
    "media.mediasource.enabled" = true;
    "media.cache_readahead_limit" = 600;
    "media.cache_resume_threshold" = 300;

    # SECTION: IMAGE CACHE
    "image.cache.size" = 10485760;
    "image.mem.decode_bytes_at_a_time" = 65536;
    "image.mem.shared.unmap.min_expiration_ms" = 120000;

    # SECTION: NETWORK
    "network.buffer.cache.size" = 65535;
    "network.buffer.cache.count" = 48;
    "network.http.max-connections" = 1800;
    "network.http.max-persistent-connections-per-server" = 10;
    "network.http.max-urgent-start-excessive-connections-per-host" = 5;
    "network.http.max-persistent-connections-per-proxy" = 48;
    "network.http.request.max-start-delay" = 5;
    "network.websocket.max-connections" = 200;
    "network.http.pacing.requests.enabled" = false;
    "network.http.pacing.requests.min-parallelism" = 10;
    "network.http.pacing.requests.burst" = 32;
    "network.dnsCacheEntries" = 10000;
    "network.dnsCacheExpiration" = 3600;
    "network.dnsCacheExpirationGracePeriod" = 120;
    "network.dns.max_high_priority_threads" = 40;
    "network.dns.max_any_priority_threads" = 24;
    "network.ssl_tokens_cache_capacity" = 10240;

    # SECTION: TAB UNLOAD
    "browser.tabs.unloadOnLowMemory" = true;
    "browser.low_commit_space_threshold_mb" = 3276; # 4GB threshold
    "browser.tabs.min_inactive_duration_before_unload" = 300000;

    # SECTION: PROCESS COUNT
    "dom.ipc.processCount" = 8;
    "dom.ipc.processCount.webIsolated" = 1;
    "dom.ipc.processPrelaunch.fission.number" = 1;
    "fission.webContentIsolationStrategy" = 1;
    "browser.preferences.defaultPerformanceSettings.enabled" = true;

    "apz.overscroll.enabled" = true;
    "general.smoothScroll" = true;
    "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
    "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
    "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
    "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = "2";
    "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
    "general.smoothScroll.currentVelocityWeighting" = "1";
    "general.smoothScroll.stopDecelerationWeighting" = "1";
    "mousewheel.default.delta_multiplier_y" = 300;

    "devtools.chrome.enabled" = true;
  };

  librewolfExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
    vimium-c
    bitwarden
    darkreader
    temporary-containers
    violentmonkey
    buster-captcha-solver
    sponsorblock
    dearrow
    multi-account-containers
    sidebery
    foxyproxy-standard
    bypass-paywalls-clean
  ];
in
{
  home.username = "trueking";
  home.homeDirectory = "/home/trueking";

  home.packages = with pkgs; [
    htop grim slurp libnotify hyprpolkitagent hyprlock
    waybar bluez brightnessctl networkmanagerapplet micro
    ncdu proton-vpn gnome-clocks pavucontrol
    hyprsunset jq nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono wl-clipboard nixd
    epiphany bat ripgrep antigravity-fhs ffmpeg
    github-cli neovim fd lazygit trash-cli tree-sitter luarocks
    python3 mission-center chisel uv gost code-cursor-fhs obsidian easyeffects opencode windsurf nodejs_24
    calibre qview 
  ];

  # 4. Clean, declarative MIME type mapping
  xdg.mimeApps = {
    enable = true;
    defaultApplications = 
      (associate "com.interversehq.qView.desktop" imageMimes) //
      (associate "codium.desktop" textMimes) // {

  };
  };

  xdg.terminal-exec = {
  enable = true;
  settings = {
    default = [ "com.mitchellh.ghostty.desktop" ];
  };
};

programs.floorp = {
    enable = true;
};

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.ghostty = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs; # This tells Home Manager to use Codium
  };

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
  programs.zellij = {
    enable = true;
  };

  services.playerctld.enable = true;

  programs.librewolf = {
    enable = true;
    
    profiles.ephemeral = {
      id = 0;
      name = "ephemeral";
      path = "ephemeral";
      isDefault = true;
      settings = librewolfSettings;
      extensions.packages = librewolfExtensions;
    };

    profiles.persistent = {
      id = 1;
      name = "persistent";
      path = "persistent";
      isDefault = false;
      settings = librewolfSettings;
      extensions.packages = librewolfExtensions;
    };
  };

  # Theme files are mapped back to the default/legacy path (~/.librewolf)
  home.file.".librewolf/ephemeral/chrome".source = ffultima-src;
  home.file.".librewolf/persistent/chrome".source = ffultima-src;

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
      ".ssh"
      "Safe"
      ".var/app/app.zen_browser.zen"
      ".config/Antigravity"
      ".local/share/Trash"
      ".librewolf/persistent" # Switched back to the default/legacy path format
    ];
  };

  programs.git = {
    enable = true;
    userName = "TrueKing";
    userEmail = "samuellance73@gmail.com";
  };

  home.stateVersion = "26.11";
}