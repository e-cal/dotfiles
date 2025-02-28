{ config, lib, pkgs, unstable, master, inputs, ... }: {
  networking.hostName = "talos";

  environment.systemPackages = with pkgs;
    [
      (ollama.override { acceleration = "cuda"; })
      # other
    ];

  users.users.ecal = {
    # extraGroups = [];
    #   shell = pkgs.zsh;
    packages = with pkgs; [
      obs-studio
      gimp
      # kdenlive
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ "ecal" ];
  };
}
