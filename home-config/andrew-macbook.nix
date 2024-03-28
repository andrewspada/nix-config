{ config, ... }:

{
  imports = [ ./my-config.nix ];
  my-config.installFirefox = false;

  # workaround, because GUI applications do not seem to have the right
  # PATH set when launched from the launcher.
  programs.emacs.extraConfig = ''
    (setenv "PATH" "${config.home.homeDirectory}/.ghcup/bin:${config.home.homeDirectory}/.cabal/bin:${config.home.homeDirectory}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin")
  '';
}
