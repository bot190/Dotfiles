{
  description = "bot190's system flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    # home-manager, used for managing user configuration
    agent-of-empires.url = "github:agent-of-empires/agent-of-empires";
    llm-agents.url = "github:numtide/llm-agents.nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    # Walker Launcher
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      agent-of-empires,
      llm-agents,
      walker,
      ...
    }@inputs:
    let
      linux_system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        ingvar = nixpkgs.lib.nixosSystem {
          modules = [
            ./ingvar/configuration.nix
            sops-nix.nixosModules.sops
            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Preserve files that predate Home Manager when first taking
              # ownership of them (notably the existing Niri configuration).
              home-manager.backupFileExtension = "hm-backup";
              home-manager.extraSpecialArgs = {
                inherit agent-of-empires llm-agents walker;
              };

              home-manager.users.ben = import ./ingvar/home.nix;
            }
          ];
        };
      };
    };
}
