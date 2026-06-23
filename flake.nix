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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR"; 
  };

  # --- ADDED home-manager TO OUTPUTS ---
  outputs = { self, nixpkgs, disko, impermanence, home-manager, stylix, ... }@inputs: {
    # "latitude" is your hostname. You will use this in the install command.
    nixosConfigurations.latitude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules =[
        
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [ inputs.nur.overlays.default ];
        })

        disko.nixosModules.disko
        impermanence.nixosModules.impermanence

        stylix.nixosModules.stylix
        ./hosts/latitude

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.trueking = import ./home.nix;
        }

      ];
    };
  };
}
