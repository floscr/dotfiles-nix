{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (lib.mkIf (config.programs.gnupg.agent.enable) pinentry_emacs)

    editorconfig-core-c
    (ripgrep.override {withPCRE2 = true;})
    # Doom Emacs + dependencies
    emacs
    sqlite                          # :tools (lookup +docsets)
    texlive.combined.scheme-medium  # :lang org -- for latex previews
    ccls                            # :lang (cc +lsp)
    nodePackages.javascript-typescript-langserver # :lang (javascript +lsp)
    gnutls # :tools irc
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];

  # services.emacs.enable = true;
  # services.emacs.install = true;

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  home-manager.users.floscr.xdg.configFile = {
    "zsh/rc.d/aliases.emacs.zsh".source = <config/emacs/aliases.zsh>;
    "zsh/rc.d/env.emacs.zsh".source = <config/emacs/env.zsh>;
  };
}
