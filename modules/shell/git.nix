{ config, options, lib, pkgs, ... }:

with lib;

{
  options.modules.shell.git = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.shell.git.enable {
    my = {
      packages = with pkgs; [
        git-lfs
        gitAndTools.hub
        gitAndTools.diff-so-fancy
      ];
      zsh.rc = lib.readFile <config/git/aliases.zsh>;
      home.xdg.configFile = {
        "git/config".source = <config/git/config>;
        "git/ignore".source = <config/git/ignore>;
      };
    };
  };
}
