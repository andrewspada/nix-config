{
  description = "My NixOS configuration :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, mac-app-util }: {
    nixosConfigurations.PDP-11 = nixpkgs.lib.nixosSystem {
      system = "x86_64";
      modules = [
        ./nixos-config/configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
    darwinConfigurations.Andrews-MacBook-Pro = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin-config/configuration.nix
        home-manager.darwinModules.home-manager
        mac-app-util.darwinModules.default
        {
          home-manager.users.andrew.imports = [ mac-app-util.homeManagerModules.default ];
        }
      ];
    };
  };
}