# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
  	 automatic = true;
	 dates = "Mon *-*-* 03:15:00";
  };
  

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "PDP-11";
 
  time.timeZone = "America/New_York";

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
  };

  environment.systemPackages = [
    pkgs.git # need this for updating from a flake!!!!
  ];

  nixpkgs.config.allowUnfree = true;

  # In particular, git needs to be installed for this to work
  system.autoUpgrade = {
    enable = true;
    flake = "github:andrewspada/nix-config";
    flags = [
      "--update-input" "nixpkgs"
      "--update-input" "home-manager"
      "--no-write-lock-file"
    ];
  };

  users = {
    mutableUsers = false;
    users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      hashedPasswordFile = "/etc/my-hashed-password";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.andrew = import ./home.nix;
  };

  hardware.onlykey.enable = true;
  
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

