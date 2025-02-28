{ config, lib, pkgs, unstable, master, inputs, ... }: 
let
  vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    src = builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
      sha256 = "1wmj43i63vdi0zcdj5kq4ndx0y27khn5m7i64rd36r71qd2sxwzh";
    };
    version = "latest";
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 pkgs.neovim ];
  });
in
{
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
      packages = with pkgs; [ 

      vscode-insiders.fhs
    ];
  };


  # install dynamic libraries for unpackaged programs
  # https://nix.dev/guides/faq.html
  # programs.nix-ld.libraries = with pkgs; [ ];

  # environment.sessionVariables = {
  #    LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib";
  #  };
}
