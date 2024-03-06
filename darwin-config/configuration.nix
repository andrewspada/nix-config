{ config, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;

  users.users.andrew.home = "/Users/andrew";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.andrew = import ../home-config/andrew-macbook.nix;
  };
}