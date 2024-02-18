{ config, pkgs, ... }:

{
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";
  home.packages = [
    pkgs.transmission-gtk
  ];
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

    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.magit
	      epkgs.nix-mode
        epkgs.ws-butler
      ];

      # Seems to be fixed in 24.05, no longer needed by then
      overrides = self: super: {
        # Taken from https://github.com/magit/magit/issues/5011#issuecomment-1838598138
        seq = self.callPackage ({ elpaBuild, fetchurl, lib }:
          elpaBuild rec {
            pname = "seq";
            ename = "seq";
            version = "2.24";
            src = fetchurl {
              url = "https://elpa.gnu.org/packages/seq-2.24.tar";
              sha256 = "1w2cysad3qwnzdabhq9xipbslsjm528fcxkwnslhlkh8v07karml";
            };
            packageRequires = [];
            meta = {
              homepage = "https://elpa.gnu.org/packages/seq.html";
              license = lib.licenses.free;
            };
            # tests take a _long_ time to byte-compile, skip them
            postInstall = ''rm -r $out/share/emacs/site-lisp/elpa/${pname}-${version}/tests'';
          }) {};
      };
    };

    firefox.enable = true;
  };
}
