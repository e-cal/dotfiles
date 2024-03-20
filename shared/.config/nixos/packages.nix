{ config, lib, pkgs, inputs, ... }:
let
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/nixos-unstable") {
      config = config.nixpkgs.config;
    };
in {
  imports = [ inputs.home-manager.nixosModules.default ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  # Global
  environment.systemPackages = with pkgs; [
    # core
    unstable.neovim
    git
    wget
    tmux
    zsh
    stow

    # languages
    python3
    python311Packages.pip
    python311Packages.ipython
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    gcc
    gnumake
    cmake
    lua
    go
    nodejs_21

    # formatters
    yapf
    shfmt
    nixfmt
    nodePackages.prettier

    # services
    socat
    dbus
    ntp
    alsa-utils
    pulseaudio
    pamixer
    pavucontrol
    playerctl
    libnotify
    dunst
    wl-clipboard
    pipewire
    wireplumber
    grim
    slurp
    swappy

    # tools
    nix-index
    eza
    bat
    fzf
    ripgrep
    jq
    jc
    zip
    unzip
    lazygit
    rclone
    github-cli
    podman
    htop
    openfortivpn # queens

    # aesthetics
    starship
    hyprpaper
    lolcat
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    material-icons
  ];

  # users and user packages (gui)
  users.users.ecal = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kitty
      firefox
      opera
      eww-wayland
      cinnamon.nemo
      albert
      unstable.flameshot
      hyprpicker
      zathura
      (ollama.override { acceleration = "cuda"; })

      spotify
      thunderbird
      slack
      anki
      obsidian
      vial
      vscode.fhs
      masterpdfeditor4
    ];
  };

  programs.steam = {
    enable = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "ecal" = import ./home.nix; };
  };

  services.udev.packages = with pkgs; [ vial ];

  # install dynamic libraries for unpackaged programs
  # https://nix.dev/guides/faq.html
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libgcc.lib
    libGL
    libappindicator-gtk3
    libdrm
    libglvnd
    libnotify
    libpulseaudio
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    systemd
    vulkan-loader
    zlib
  ];
}
