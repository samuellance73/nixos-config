# Shared Firefox-derived policies for all Mozilla-based browsers.

{


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
      "https://claude.ai"
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
}