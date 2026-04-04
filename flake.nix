{
  description = "mizokami's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }:
    let
      # Common home-manager modules shared across platforms
      homeModules = [
        ./nix/modules/home
      ];

      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = homeModules ++ [
          { home.homeDirectory = "/home/mizokami"; }
        ];
        extraSpecialArgs = {
          dotfilesDir = ./.;
        };
      };
    in
    {
      # macOS: nix-darwin + home-manager
      darwinConfigurations."mizokami" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mizokami = { lib, ... }: {
              imports = [ ./nix/modules/home ];
              home.homeDirectory = lib.mkForce "/Users/mizokami";
            };
            home-manager.extraSpecialArgs = {
              dotfilesDir = ./.;
            };
          }
        ];
      };

      # Linux: standalone home-manager
      homeConfigurations."mizokami" = mkHome "x86_64-linux";
    };
}
