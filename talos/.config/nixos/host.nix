{ config, lib, pkgs, unstable, master, inputs, ... }: {
  networking.hostName = "talos";

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

  services.udev.extraRules = ''
    # Intel iGPU symlink
    KERNEL=="card*", \
    KERNELS=="0000:00:02.0", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/igpu"

    # NVIDIA RTX A2000 symlink
    KERNEL=="card*", \
    KERNELS=="0000:01:00.0", \
    SUBSYSTEM=="drm", \
    SUBSYSTEMS=="pci", \
    SYMLINK+="dri/a2000"
  '';
}
