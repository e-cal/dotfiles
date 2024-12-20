{ config, lib, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {
      config = config.nixpkgs.config;
    };
in {
  networking.hostName = "talos";

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };


}
