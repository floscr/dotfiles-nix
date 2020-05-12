{ config, options, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./termite.nix
  ];

  options.modules.desktop.term = {
    default = mkOption {
      type = types.str;
      default = "xterm";
    };
  };

  config = {
    services.xserver.desktopManager.xterm.enable =
      config.modules.desktop.term.default == "xterm";

    my.env.TERMINAL = config.modules.editors.default;
  };
}
