{ config, pkgs, ... }:

{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium-fhs;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "TrueKing";
      email = "samuellance73@gmail.com";
    };
  };

  home.packages = with pkgs; [
    nixd
    github-cli
    neovim
    fd
    lazygit
    tree-sitter
    luarocks
    python3
    uv
    gost
    nodejs_24
    devin-desktop
  ];
}
