{

  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix/";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";    
    };
   };

  outputs = inputs@{ nixpkgs, home-manager,  ... }:
    let 
      system = "x86_64-linux";
      host = "spectre";
      username = "erich";
    in
   {
    nixosConfigurations = {
      
      "${host}" = nixpkgs.lib.nixosSystem {

        # Set all inputs parameters as special argument for all submodules,
        # so you can directly use all dependencies in inputs in submodules
        specialArgs = { 
          inherit system;
          inherit inputs; 
          inherit username;
          inherit host;
        };

        modules = [
          # Import the previous configuration.nix, so the old file stll takes effect
          ./hosts/${host}/config.nix
          inputs.stylix.nixosModules.stylix

          # Make home-manager a module of nixos
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} =  import ./hosts/${host}/home.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit host;
            };
          }
        ];
      };    
    };
  };
}
