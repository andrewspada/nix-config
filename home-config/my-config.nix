{ config, pkgs, lib, ... }:

let
  cfg = config.my-config;
in {
  options.my-config = {
    useGnome = lib.mkOption {
      default = false;
      description = ''
        Whether to enable GNOME-specific settings.
      '';
      type = lib.types.bool;
    };

    installFirefox = lib.mkOption {
      default = true;
      description = ''
        Whether to install Firefox via nix.
      '';
      type = lib.types.bool;
    };
  };

  config = {
    home.packages = [
      pkgs.texlive.combined.scheme-full
      pkgs.transmission-gtk
      pkgs.discord
      pkgs.ffmpeg
      (pkgs.fenix.complete.withComponents [
        "rustc"
        "rust-src"
        "cargo"
        "rust-analyzer"
        "rustfmt"
        "clippy"
      ])
    ];
    # YOU DONT NEED TO CHANGE THIS ON UPGRADES.
    # IT IS HERE TO ENSURE COMPAT WITH STATE FILES.
    #
    # thanks for listening babe <3
    home.stateVersion = "23.11";

    dconf.settings = lib.mkIf cfg.useGnome {
      "org/gnome/desktop/interface".clock-format = "12h";
    };

    programs = {
      git = {
        enable = true;
        userEmail = "spada.andrew.j@gmail.com";
        userName = "Andrew Spada";
        ignores = [
          "*~"
          "#*#"
        ];
        extraConfig = {
          init.defaultBranch = "main";
        };
      };

      emacs = {
        enable = true;
        extraPackages = epkgs: [
          epkgs.auctex
          epkgs.company
          epkgs.eglot
          epkgs.exec-path-from-shell
          epkgs.haskell-mode
          epkgs.magit
          epkgs.markdown-mode
          epkgs.nix-mode
          epkgs.pdf-tools
          epkgs.rust-mode
          epkgs.ws-butler
        ];

        extraConfig = builtins.readFile ./emacs/init.el;

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

      firefox.enable = cfg.installFirefox;
    };
  };
}
