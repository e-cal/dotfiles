{ config, lib, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {
      config = config.nixpkgs.config;
    };
in {
  networking.hostName = "talos";

  # Global
  # environment.systemPackages = with pkgs; [ ];

  # fonts.packages = with pkgs; [ ];

  # users and user packages (gui)
  # users.users.ecal = {
  #   extraGroups = [];
  #   shell = pkgs.zsh;
  #   packages = with pkgs; [ ];
  # };

  # install dynamic libraries for unpackaged programs
  # https://nix.dev/guides/faq.html
  # programs.nix-ld.libraries = with pkgs; [ ];

  # environment.sessionVariables = {
  #    LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib";
  #  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

}
