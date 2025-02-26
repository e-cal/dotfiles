{ config, lib, pkgs, unstable, master, inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.default ./cachix.nix ];

  # Global
  environment.systemPackages = with pkgs; [
    # core
    neovim-custom
    git
    wget
    tmux
    zsh
    stow
    zoxide
    (nnn.override { withNerdIcons = true; })
    direnv
    networkmanagerapplet

    # languages
    pythonWithPkgs
    unstable.uv
    poetry
    python312Packages.ipython
    python312Packages.jupytext
    python312Packages.pylatexenc
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    gcc
    gnumake
    cmake
    emscripten
    clang
    clang-tools
    lua
    luajitPackages.luarocks
    go
    nodejs_22
    bun
    tree-sitter
    bazel

    # formatters
    yapf
    shfmt
    nixfmt-classic
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
    feh
    wev
    kdenlive

    # tools
    nix-index
    cachix
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
    nvtopPackages.full
    openfortivpn # queens
    wkhtmltopdf-bin
    appimage-run
    usbutils
    imagemagick
    luajitPackages.magick
    ffmpeg
    unstable.rbw
    pinentry-tty
    ydotool
    difftastic

    # aesthetics
    lolcat
    starship
    hyprpaper
    hyprcursor
    catppuccin-cursors.mochaDark

    # libs
    stdenv.cc.cc.lib
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "JetBrainsMono" "FantasqueSansMono" "FiraCode" ];
    })
    material-icons
    noto-fonts
    dejavu_fonts
    liberation_ttf
  ];

  # users and user packages (gui)
  users.users.ecal = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "plugdev" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kitty
      unstable.ghostty
      firefox
      geckodriver
      (chromium.override {
        enableWideVine = true;
        commandLineArgs = [
          "--enable-features=VaapiVideoDecodeLinuxGL"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      })
      spotify
      youtube-music

      eww
      nemo
      albert
      hyprpicker
      flameshot-grim
      unstable.satty

      vial
      unstable.keymapp
      unstable.wally-cli
      qmk
      solaar

      thunderbird
      slack
      zoom

      obsidian
      zotero_7
      anki
      zathura
      calibre
      masterpdfeditor4
      libreoffice-fresh
      quarto
      qalculate-gtk
      gnuplot
      gromit-mpx

      obs-studio
      gimp
      vlc

      vscode.fhs
      vscode-insiders.fhs
      unstable.zed-editor
      (ollama.override { acceleration = "cuda"; })
      master.claude-code

      prismlauncher
    ];
  };
  programs.chromium.extraOpts = { "SyncDisabled" = false; };

  programs.weylus = {
    enable = true;
    openFirewall = true;
    users = [ "ecal" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "ecal" = import ./home.nix; };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    # enableNvidia = true;
    rootless = {
      enable = true;
      setSocketVariable = false;
      daemon.settings = {
        runtimes = {
          nvidia = {
            path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
          };
        };
      };
    };
  };
  users.extraGroups.docker.members = [ "ecal" ];

  services.udev.packages = with pkgs; [ unstable.zsa-udev-rules vial ];
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
    mediastreamer-openh264
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
