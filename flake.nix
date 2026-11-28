{
  description = "mizokami's dotfiles";

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

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep System Manager's upstream Nixpkgs pin to reuse Numtide's cached builds.
    system-manager.url = "github:numtide/system-manager";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    { nixpkgs, home-manager, home-manager-unstable, nix-darwin, system-manager, llm-agents, ... }:
    let
      username = "mizokami";

      # Create pkgs
      mkPkgs = system: import nixpkgs { inherit system; };

      mkLinuxSystemConfig = linuxSystem:
        system-manager.lib.makeSystemConfig {
          specialArgs = { inherit username; };
          modules = [
            ./nix/modules/system/linux.nix
            home-manager-unstable.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = linuxSystem;

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username} = {
                  _module.args.pkgs = home-manager-unstable.inputs.nixpkgs.legacyPackages.${linuxSystem};
                  imports = [
                    ./nix/modules/home
                    ./nix/modules/home/linux.nix
                  ];
                };
                extraSpecialArgs = {
                  llmAgents = llm-agents.packages.${linuxSystem};
                };
              };
            }
          ];
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
          ./nix/modules/system/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              imports = [
                ./nix/modules/home
                ./nix/modules/home/darwin
              ];
            };
            home-manager.extraSpecialArgs = {
              llmAgents = llm-agents.packages."aarch64-darwin";
            };
          }
        ];
      };

      # Linux: system-manager + home-manager
      systemConfigs = {
        ${username} = mkLinuxSystemConfig "x86_64-linux";
        "${username}-aarch64" = mkLinuxSystemConfig "aarch64-linux";
      };

      # Bootstrap system-manager from the version pinned by flake.lock.
      packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (linuxSystem: {
        system-manager = system-manager.packages.${linuxSystem}.default;
      });
    };
}
