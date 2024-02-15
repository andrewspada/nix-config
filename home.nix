{ config, pkgs, ... }:

{
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  # YOU DONT NEED TO CHANGE THIS ON UPGRADES.
  # IT IS HERE TO ENSURE COMPAT WITH STATE FILES.
  #
  # thanks for listening babe <3
  home.stateVersion = "23.11";

  dconf.settings = {
    "org/gnome/desktop/interface".clock-format = "12h";
  };
      
  programs = {
    git = {
      enable = true;
      userEmail = "spada.andrew.j@gmail.com";
      userName = "Andrew Spada";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

    firefox.enable = true;
  };
}