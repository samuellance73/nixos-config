{
  description = "Trueking's NixOS Impermanence + Disko System";

  inputs = {
    # Using NixOS unstable for the latest packages and Wayland updates
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:nix-community/stylix";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    impermanence.url = "github:nix-community/impermanence";

    # --- ADDED HOME MANAGER ---
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # --- ADDED home-manager TO OUTPUTS ---
  outputs = { self, nixpkgs, disko, impermanence, home-manager, stylix, ... }@inputs: {
    # "latitude" is your hostname. You will use this in the install command.
    nixosConfigurations.latitude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules =[
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        
        # --- ADDED HOME MANAGER MODULE ---
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        ./disko.nix
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
