{ config, lib, pkgs, unstable, master, inputs, ... }: {
  networking.hostName = "nixtogo";

  # Global
  environment.systemPackages = with pkgs; [
    brillo
    acpi
    wtype
    keyd
    prismlauncher # minecraft
  ];

  # programs.steam.enable = true;

  services.keyd.enable = true;
  # absolute path means I need to build with --impure
  environment.etc."keyd/default.conf".source = /home/ecal/kbd/keyd.conf;

  # fonts.packages = with pkgs; [ ];

  # users and user packages (gui)
  users.users.ecal = {
    extraGroups = [ "keyd" ];
    #   shell = pkgs.zsh;
    #   packages = with pkgs; [ ];
  };

  # install dynamic libraries for unpackaged programs
  # https://nix.dev/guides/faq.html
  # programs.nix-ld.libraries = with pkgs; [ ];

  # environment.sessionVariables = {
  #    LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib";
  #  };
}
