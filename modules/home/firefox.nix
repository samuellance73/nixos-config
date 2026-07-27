{
  config,
  pkgs,
  lib,
  ...
}:

let
  ffultima-src = builtins.fetchTarball {
    url = "https://github.com/soulhotel/FF-ULTIMA/archive/refs/tags/v4.3.tar.gz";
    sha256 = "0cpwxr70xfd43pf08jqsm8jbni71gjg393qczcmd35ccwnpj3kfa";
  };

  # Fetch Betterfox user.js
  betterfox-js = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/150.0/user.js";
    sha256 = "1bgwdzr8g0fdw9p2zw34scinj5684ag13kjr7di4b48lags5ccp8";
  };

  betterfoxConfig = builtins.readFile betterfox-js;
  ffultimaConfig = builtins.readFile "${ffultima-src}/user.js";

  # Helper to format Nix attrsets as user_pref lines for user.js
  mkUserJs = prefs: lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: value:
      let
        valStr =
          if builtins.isBool value then (if value then "true" else "false")
          else if builtins.isInt value then builtins.toString value
          else if builtins.isString value then ''"${value}"''
          else throw "Unsupported type for preference: ${name}";
      in
        "user_pref(\"${name}\", ${valStr});"
    ) prefs
  );

  ephemeralSettings = {
    # UI/UX
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "sidebar.verticalTabs" = false;
    "devtools.chrome.enabled" = true;
    "user.theme.catppuccin-mocha" = true;
    "browser.tabs.closeWindowWithLastTab" = false;
    "privacy.trackingprotection.allow_list.baseline.enabled" = true;

    # DNS over HTTPS (Cloudflare)
    "network.trr.mode" = 2;
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
    "network.trr.bootstrapAddress" = "1.1.1.1";

    # Privacy - clear on shutdown
    "privacy.sanitize.sanitizeOnShutdown" = true;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
    "privacy.clearOnShutdown_v2.cache" = true;
    "privacy.clearOnShutdown_v2.formdata" = true;
    "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
    "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
    "privacy.clearOnShutdown_v2.siteSettings" = false;
    "ultima.sidebery.autohide" = false;
    "ultima.tabs.tabbar.disabled" = true;

    "widget.use-xdg-desktop-portal.file-picker" = 1;

    "browser.cache.memory.capacity" = 1048576;
    "browser.cache.memory.max_entry_size" = 51200;

    "browser.newtabpage.pinned" = builtins.toJSON [
      {
        title = "NixOS Search";
        url = "https://search.nixos.org";
      }
      {
        title = "GitHub";
        url = "https://github.com";
      }
      {
        title = "Reddit";
        url = "https://reddit.com";
      }
      {
        title = "YouTube";
        url = "https://youtube.com";
      }
    ];
  };

  persistentSettings = ephemeralSettings // {
    # Don't clear on shutdown
    
    "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;

    # Restore session tabs on startup
    "browser.startup.page" = 3;
  };

  commonExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
    single-file
    translate-web-pages
  ];

  firefoxExtensions = commonExtensions ++ (with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
  ]);

  commonContainers = {
    sanctuary = {
      id = 1;
      name = "Sanctuary";
      color = "blue";
      icon = "circle";
    };
    forge = {
      id = 2;
      name = "Forge";
      color = "orange";
      icon = "briefcase";
    };
    bazaar = {
      id = 3;
      name = "Bazaar";
      color = "green";
      icon = "cart";
    };
    nexus = {
      id = 4;
      name = "Nexus";
      color = "pink";
      icon = "fingerprint";
    };
    vault = {
      id = 5;
      name = "Vault";
      color = "purple";
      icon = "dollar";
    };
  };
in
{
  stylix.targets.firefox.profileNames = [ "ephemeral" "persistent" ];

  programs.firefox = {
    enable = true;

    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      # Core
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSystemAddonUpdate = true;
      DontCheckDefaultBrowser = true;

      # Privacy & Security
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;

      # UI/UX
      DisableFeedbackCommands = true;

      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      # User Messaging
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        Locked = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      Cookies = {
        Allow = [
          "https://github.com"
          "https://accounts.google.com"
        ];
        Behavior = "reject-tracker-and-partition-foreign";
        Locked = true;
      };

      # Home Page
      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredStories = false;
        Snippets = false;
        Weather = false;
      };

      SearchEngines = {
        PreventInstalls = false;
        Remove = [
          "Bing"
          "Amazon.com"
          "eBay"
          "Twitter"
          "Perplexity"
        ];
      };
    };

    profiles = {
      ephemeral = {
        id = 0;
        name = "ephemeral";
        path = "ephemeral";
        isDefault = true;
        settings = ephemeralSettings;
        bookmarks = { force = true; settings = import ../../bookmarks.nix; };
        extraConfig = betterfoxConfig + "\n" + ffultimaConfig + "\n" + (mkUserJs ephemeralSettings);
        extensions.packages = firefoxExtensions;
        containersForce = true;
        containers = commonContainers;
      };

      persistent = {
        id = 1;
        name = "persistent";
        path = "persistent";
        isDefault = false;
        settings = persistentSettings;
        bookmarks = { force = true; settings = import ../../bookmarks.nix; };
        extraConfig = betterfoxConfig + "\n" + ffultimaConfig + "\n" + (mkUserJs persistentSettings);
        extensions.packages = firefoxExtensions;
        containersForce = true;
        containers = commonContainers;
      };
    };
  };

  # Apply FF-ULTIMA theme to Firefox profiles
  xdg.configFile."mozilla/firefox/ephemeral/chrome".source = ffultima-src;
  xdg.configFile."mozilla/firefox/persistent/chrome".source = ffultima-src;
}