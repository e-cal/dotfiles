{ config, pkgs, ... }:

{
  home.username = "ecal";
  home.homeDirectory = "/home/ecal";

  # Install packages through home-manager
  home.packages = with pkgs; [
    gtk3
    gtk4
    gnome-themes-extra

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Blue-dark";
      package = pkgs.catppuccin-gtk;
    };
    # cursorTheme = {
    #   name = "Catppuccin-Mocha-Dark-Cursors";
    #   package = pkgs.catppuccin-cursors.mochaDark;
    # };
  };
  xdg.configFile = {
    "gtk-4.0/assets".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };

  home.pointerCursor = let
    getFrom = url: hash: name: {
      gtk.enable = true;
      x11.enable = true;
      name = name;
      size = 24;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${
          pkgs.fetchzip {
            url = url;
            hash = hash;
          }
        } $out/share/icons/${name}
      '';
    };
  in getFrom
  # "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
  "https://github.com/catppuccin/cursors/releases/download/v0.3.1/catppuccin-mocha-dark-cursors.zip"
  "sha256-u2AaEXkiN0ACgGvYRjkkpsjByguhQehBoaxtIN1W2gg=" "Catppuccin-Mocha-Dark-Cursors";

  # Manage dotfiles
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
