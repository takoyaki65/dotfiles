{
  description = "mizokami's dotfiles";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nixpkgs-25.11-darwin";
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
