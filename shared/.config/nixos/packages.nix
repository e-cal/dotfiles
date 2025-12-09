{ config, lib, pkgs, unstable, inputs, ... }: {
  imports = [ inputs.home-manager.nixosModules.default ./cachix.nix ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "ecal" = import ./home.nix; };
  };

  environment.systemPackages = with pkgs; [
    neovim-custom
    git
    wget
    tmux
    zsh
    stow
    zoxide
    # (nnn.override { withNerdIcons = true; })
    ranger
    yazi
    direnv
    nix-direnv
    inputs.direnv-instant.packages.${pkgs.system}.default

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
    btop
    bottom
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
    sshfs
    lsof
    brotli
    xorg.xrandr

    # formatters
    yapf
    shfmt
    nixfmt-classic
    stylua
    nodePackages.prettier

    # languages
    pythonWithPkgs
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
    stdenv.cc.cc.lib
    texpresso
    ueberzugpp
    pandoc
    texlive.combined.scheme-medium

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
    feh
    wev
    cacert
    geeqie
    uxplay

    # aesthetics
    clolcat
    starship
    hyprpaper
    hyprcursor
    hyprsunset
    catppuccin-cursors.mochaDark
  ];
  services.avahi = {
    enable = true;
    nssmdns = true; # printing
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };
  services.dbus.enable = true;
  networking.firewall.enable = lib.mkForce false;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    material-icons
    noto-fonts
    dejavu_fonts
    liberation_ttf
  ];

  users.users.ecal = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "plugdev" "docker" "ydotool" ];
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
      # tmp
      inputs.zen-browser.packages.${pkgs.system}.default
      nur.repos.Ev357.helium

      code-cursor

      eww
      nemo
      unstable.albert
      unstable.quickshell
      hyprpicker
      flameshot-grim
      unstable.satty
      hyprshot

      # vial
      unstable.keymapp
      unstable.wally-cli
      qmk
      solaar

      thunderbird
      slack
      # zoom
      spotify

      obsidian
      zotero_7
      anki
      zathura
      sioyek
      masterpdfeditor4
      quarto
      qalculate-gtk
      gnuplot
      gromit-mpx
      vlc

      blender

    ];
  };

  services.mullvad-vpn.enable = true;
  # services.postgresql.enable = true;

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

  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" # Default CA bundle
  ];

  # install dynamic libraries for unpackaged programs
  # https://nix.dev/guides/faq.html
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    brotli
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
