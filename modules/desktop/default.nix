{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    redshift
    xclip
    xdotool
    ffmpeg
    # mpv       # video player
    # feh       # image viewer

    # Useful apps
    # evince    # pdf reader
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;
      libinput.disableWhileTyping = true;
      libinput.enable = true;
    };

    redshift = (if config.time.timeZone == "America/Toronto" then {
      enable = true;
      latitude = "43.70011";
      longitude = "-79.4163";
    } else if config.time.timeZone == "Europe/Vienna" then {
      enable = true;
      latitude = "55.88";
      longitude = "12.5";
    } else {});
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      ubuntu_font_family
      dejavu_fonts
      fira-code
      fira-code-symbols
      symbola
      noto-fonts
      noto-fonts-cjk
      font-awesome-ttf
    ];

    fontconfig.defaultFonts = {
      sansSerif = ["Ubuntu"];
      monospace = ["Fira Code"];
    };
  };
}
