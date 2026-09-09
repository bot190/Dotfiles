rec {
  description = "bot190's system flake";

  nixConfig = {
    extra-substituters = [
      "https://agent-of-empires.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "agent-of-empires.cachix.org-1:Z+VwTlT8GT7giWN9HhJ+Am0DPGfbFVlafcQioBqJ6wY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # home-manager, used for managing user configuration
    agent-of-empires.url = "github:agent-of-empires/agent-of-empires";
    llm-agents.url = "github:numtide/llm-agents.nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      agent-of-empires,
      llm-agents,
      ...
    }:
    let
      linux_system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        ingvar = nixpkgs.lib.nixosSystem {
          modules = [
            ./ingvar/configuration.nix
            {
              nix.settings = nixConfig;
              nixpkgs.config.allowUnfreePredicate =
                pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "1password"
                  "1password-cli"
                  "vscode"
                  "obsidian"
                ];
            }
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Preserve files that predate Home Manager when first taking
              # ownership of them (notably the existing Niri configuration).
              home-manager.backupFileExtension = "hm-backup";
              home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
              home-manager.extraSpecialArgs = {
                inherit agent-of-empires llm-agents;
              };

              home-manager.users.ben = import ./ingvar/home.nix;
            }
          ];
        };
      };

      homeConfigurations = {
        ben = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linux_system};
          extraSpecialArgs = {
            nixpkgsConfig = {
              allowUnfree = true;
            };
            inherit agent-of-empires llm-agents;
          };
          modules = [
            sops-nix.homeManagerModules.sops
            ./shared/terminal.nix
            {
              home.username = "ben";
              home.homeDirectory = "/home/ben";
              home.stateVersion = "25.05";
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };
    };
}
