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
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" "qtwebkit-5.212.0-alpha4" "openssl-1.1.1w" ];

  # Global
  environment.systemPackages = with pkgs; [
    # core
    unstable.neovim
    git
    wget
    tmux
    zsh
    stow
    zoxide

    # languages
    python3
    python311Packages.pip
    poetry
    python311Packages.ipython
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    gcc
    gnumake
    cmake
    lua
    go
    nodejs_21
    docker

    # formatters
    yapf
    shfmt
    nixfmt
    stylua
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
    unstable.github-cli
    podman
    htop
    openfortivpn # queens
    wkhtmltopdf-bin

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
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kitty
      firefox
      chromium
      spotify

      eww-wayland
      cinnamon.nemo
      albert
      hyprpicker
      unstable.flameshot

      vial
      unstable.keymapp
      unstable.wally-cli
      qmk

      thunderbird
      slack

      obsidian
      zotero
      anki
      zathura
      masterpdfeditor4

      vscode.fhs
      (ollama.override { acceleration = "cuda"; })
    ];
  };


  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "ecal" = import ./home.nix; };
  };

  # virtualisation.docker.enable = true;

  services.udev.packages = with pkgs; [ 
    unstable.zsa-udev-rules 
    vial
  ];

  # services.mullvad-vpn.enable = true;
  # services.postgresql.enable = true;

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
    ghostscript
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
    webkitgtk
    zlib
  ];
}
