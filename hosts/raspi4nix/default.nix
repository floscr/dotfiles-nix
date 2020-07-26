{ config, lib, pkgs, ... }:

## Rasberry Pi 4

{
  imports = [
    ../personal.nix   # common settings
    ./hardware-configuration.nix
  ];

  modules = {
    editors = {
      default = "nvim";
      vim.enable = true;
    };

    shell = {
      git.enable = true;
      gnupg.enable = true;
      zsh.enable = true;
    };

    media = {
      youtube-dl.enable = true;
    };
  };

  time.timeZone = "Europe/Vienna";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Networking
  networking.networkmanager.enable = true;
}
