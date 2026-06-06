{
  description = "mizokami's dotfiles";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { nixpkgs, home-manager, nix-darwin, llm-agents, ... }:
    let
      username = "mizokami";

      # Create pkgs with overlays
      mkPkgs = system:
        import nixpkgs {
            inherit system;
            overlays = [
              llm-agents.overlays.default
            ];
        };

      mkLinuxHomeConfig = linuxSystem:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs linuxSystem;
          modules = [
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
            ./nix/modules/home
            ./nix/modules/linux
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
          {
            nixpkgs.pkgs = mkPkgs "aarch64-darwin";
          }
          ./nix/modules/darwin/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              imports = [
                ./nix/modules/home
                ./nix/modules/darwin
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
