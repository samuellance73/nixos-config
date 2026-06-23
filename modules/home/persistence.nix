{ config, ... }:

{
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
      ".config/mozilla/firefox/persistent"
    ];
  };
}
