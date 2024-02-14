{
  description = "My NixOS configuration :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations.PDP-11 = nixpkgs.lib.nixosSystem {
      system = "x86_64";
      modules = [
        ./configuration.nix
	home-manager.nixosModules.home-manager
      ];
    };
  };
}