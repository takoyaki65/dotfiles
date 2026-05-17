{
  description = "mizokami's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nix-darwin, ... }:
    let
      username = "mizokami";

      mkLinuxHomeConfig = linuxSystem:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          modules = [
            ./nix/modules/home
            ./nix/modules/linux
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ];
          extraSpecialArgs = {
            dotfilesDir = ./.;
          };
        };
    in
    {
      # macOS: nix-darwin + home-manager
      darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/modules/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              imports = [
                ./nix/modules/home
                ./nix/modules/darwin/packages.nix
              ];
            };
            home-manager.extraSpecialArgs = {
              dotfilesDir = ./.;
            };
          }
        ];
      };

      # Linux: standalone home-manager
      homeConfigurations = {
        ${username} = mkLinuxHomeConfig "x86_64-linux";
        "${username}-aarch64" = mkLinuxHomeConfig "aarch64-linux";
      };
    };
}
