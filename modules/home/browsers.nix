{ config, pkgs, ... }:

{
  imports = [
    ./firefox.nix
  ];

  programs.floorp = {
    enable = true;
  };

  programs.zen-browser = {
    enable = true;

    profiles.control = {
      id = 0;
      name = "trueking";
      isDefault = true;

      settings = {
        "browser.cache.memory.capacity" = 1048576;
        "browser.cache.memory.max_entry_size" = 51200;
        "network.http.max-connections" = 1800;
      };
    };

    policies = {
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      DisableFirefoxStudies = true;

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };

        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };

  stylix.targets.floorp.profileNames = [ "trueking" ];
}
