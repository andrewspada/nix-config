{ config, ... }:

{
  imports = [ ./my-config.nix ];
  my-config.installFirefox = false;

  # workaround, because GUI applications do not seem to have the right
  # PATH set when launched from the launcher.
  programs.emacs.extraConfig = ''
    (exec-path-from-shell-initialize)
  '';
}
