{ config, pkgs, ... }:

{
  imports = [ ../. ]; # Load framework for themes

  # theme.wallpaper = ./wallpaper.png;

  environment.systemPackages = with pkgs; [ arc-theme ];

  # Has to be enabled for gnome applications settings to work
  services.dbus.packages = with pkgs; [ gnome3.dconf ];

  services.xserver.displayManager = {
    lightdm = {
      greeters.mini.extraConfig = ''
        text-color = ${config.theme.colors.bmag}
        password-background-color = ${config.theme.colors.black2}
        window-color = ${config.theme.colors.black2}
        border-color = ${config.theme.colors.black2}
      '';
    };
    sessionCommands = ''
      xsetroot -solid "${config.theme.colors.black2}"
    '';
  };

  my.home = {
    dconf.settings = {
      dconf.enable = true;
      "org/gnome/nautilus/preferences" = {
        sort-directories-first = true;
      };
    };

    xdg.configFile = {
      "icons" = {
        source = ./icons;
        recursive = true;
      };
      "xtheme/90-theme".source = ./Xresources;
      "gtk-3.0/gtk.css".source = ./gtk.css;

      # GTK
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=Arc-Dark
        gtk-icon-theme-name=Arc-Dark
        gtk-fallback-icon-theme=gnome
        gtk-application-prefer-dark-theme=true
        gtk-cursor-theme-name=McMojave
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintfull
        gtk-xft-rgba=none
      '';

      # GTK2 global theme (widget and icon theme)
      "gtk-2.0/gtkrc".text = ''
        gtk-theme-name="Arc-Dark"
        gtk-icon-theme-name="adwaita"
        gtk-font-name="Sans 10"
      '';

      # QT4/5 global theme
      "Trolltech.conf".text = ''
        [Qt]
        style=Arc-Dark
      '';
    };
  };
}
