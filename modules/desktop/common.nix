{ config, lib, pkgs, ... }:

{
  my.packages = with pkgs; [
    feh
    ffmpeg
    imagemagickBig
    unstable.dragon-drop
    xcape
    xclip
    xdotool
  ];

  ## Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  ## X
  services.xserver = {
    enable = true;

    displayManager.lightdm.greeters.mini.user = config.my.username;
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeters.mini.enable = true;

    displayManager.sessionCommands = let
      udiskie = "${pkgs.udiskie}/bin/udiskie";
      xset = "${pkgs.xorg.xset}/bin/xset";
      xinput = "${pkgs.xlibs.xinput}/bin/xinput";
    in ''
      echo "Setup: Disabling power management signaling..."
      ${xset} -dpms

      systemctl --user restart setup-keyboard.service &
      systemctl --user restart setup-monitor.service &

      echo "Starting udiskie..."
      ${udiskie} --tray &

      echo "Setup: Customizing trackpad sensitivity..."
      ${xinput} set-prop 13 317 0.7  # Speed
      ${xinput} set-prop 13 318 3, 3 # Sensitivity
    '';
  };

  ## Fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      my.inriaFont
      ubuntu_font_family
      ibm-plex

      # Unicode and Symbols
      font-awesome-ttf
      noto-fonts
      noto-fonts-cjk
      symbola
    ];
    fontconfig.defaultFonts = {
      sansSerif = ["Ubuntu"];
      monospace = ["Fira Code"];
    };
  };

  my.bindings = [
    {
      binding = "super + Return";
      command = "termite";
      description = "New Terminal";
    }
    {
      binding = "super + t";
      command = "toggle-polybar";
      description = "Toggle Polybar";
    }
    {
      binding = "XF86Bluetooth";
      command = "bluetooth-toggle";
      description = "Toggle buetooth";
    }
    {
      binding = "super + shift + x";
      command = "org-capture-frame";
      description = "Emacs Org Capture";
    }
    {
      binding = "super + Escape";
      command = "pkill -USR1 -x sxhkd";
      description = "Reload Shortcuts";
    }
    {
      binding = "super + XF86MonBrightnessDown";
      command = "light -S 0.01";
      description = "Screen brightness: Minimum";
    }
    {
      binding = "super + XF86MonBrightnessUp";
      command = "light -S 100";
      description = "Screen brightness: Maximum";
    }
    {
      binding = "XF86MonBrightnessUp";
      command = "light -A 5";
      description = "Screen brightness: -5%";
    }
    {
      binding = "{ XF86AudioLowerVolume, super + alt + j }";
      command = "amixer -q set Master 10%- unmute";
      description = "Volume: -10%";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      binding = "{ XF86AudioRaiseVolume, super + alt + k }";
      command = "amixer -q set Master 10%+ unmute";
      description = "Volume: +10%";
    }
    {
      binding = "{ XF86AudioPlay, super + alt + p }";
      command = "playerctl play-pause";
      description = "Toggle Play Pause";
    }
    {
      binding = "XF86MonBrightnessDown";
      command = "light -U 5";
      description = "Screen brightness: Decrease 5%";
    }
    {
      command = "nautilus ~/Downloads";
      description = "Nautilus: Downloads";
    }
    {
      command = "nautilus ~/Desktop";
      description = "Nautilus: Desktop";
    }
    {
      command = "nautilus ~/Media/Pictures/Screenshots";
      description = "Nautilus: Screenshots";
    }
    {
      command = "nautilus ~/Downloads";
      description = "Nautilus: Downloads";
    }
  ];

  ### Mimeapps
  my.home.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/bmp" = [ "feh.desktop" ];
      "image/gif" = [ "chromium.desktop" ];
      "image/jpeg" = [ "feh.desktop" ];
      "image/jpg" = [ "feh.desktop" ];
      "image/pjpeg" = [ "feh.desktop" ];
      "image/png" = [ "feh.desktop" ];
      "image/tiff" = [ "feh.desktop" ];
      "image/webp" = [ "feh.desktop" ];
      "image/x-bmp" = [ "feh.desktop" ];
      "image/x-pcx" = [ "feh.desktop" ];
      "image/x-png" = [ "feh.desktop" ];
      "image/x-portable-anymap" = [ "feh.desktop" ];
      "image/x-portable-bitmap" = [ "feh.desktop" ];
      "image/x-portable-graymap" = [ "feh.desktop" ];
      "image/x-portable-pixmap" = [ "feh.desktop" ];
      "image/x-tga" = [ "feh.desktop" ];
      "image/x-xbitmap" = [ "feh.desktop" ];
    };
  };

}
