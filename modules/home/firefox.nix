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

  commonSettings = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;
    "devtools.chrome.enabled" = true;
    "user.theme.catppuccin-mocha" = true;
    "browser.tabs.closeWindowWithLastTab" = false;
  };


  firefoxSettings = commonSettings // {
    "privacy.sanitize.sanitizeOnShutdown" = true;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = true; # Clears cookies AND LocalStorage (honors your whitelist)
    "privacy.clearOnShutdown_v2.cache" = true;             
    "privacy.clearOnShutdown_v2.formdata" = true;          


    "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true; 
    "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true; 
    "privacy.clearOnShutdown_v2.siteSettings" = false;                

    # DNS over HTTPS (Cloudflare)
    "network.trr.mode" = 2; 
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
    "network.trr.bootstrapAddress" = "1.1.1.1"; 
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
  ];


  firefoxExtensions = commonExtensions ++ (with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
  ]);
in
{
  stylix.targets.firefox.profileNames = [ "ephemeral" "persistent" ];

  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      DontCheckDefaultBrowser = true;

      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFeedbackCommands = true;
      DisableSystemAddonUpdate = true;

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

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "allowed";
          private_browsing = true; # Automatically grants the Private Windows permission
        };
      };
    };

    profiles = {
      ephemeral = {
        id = 0;
        name = "ephemeral";
        path = "ephemeral";
        isDefault = true;
        settings = firefoxSettings;
        bookmarks = { force = true; settings = import ../../bookmarks.nix; };
        extraConfig = betterfoxConfig;
        extensions.packages = firefoxExtensions;
      };

      persistent = {
        id = 1;
        name = "persistent";
        path = "persistent";
        isDefault = false;
        settings = firefoxSettings;
        bookmarks = { force = true; settings = import ../../bookmarks.nix; };
        extraConfig = betterfoxConfig;
        extensions.packages = firefoxExtensions;
      };
    };
  };


  # Apply FF-ULTIMA theme to Firefox profiles
  xdg.configFile."mozilla/firefox/ephemeral/chrome".source = ffultima-src;
  xdg.configFile."mozilla/firefox/persistent/chrome".source = ffultima-src;
}
