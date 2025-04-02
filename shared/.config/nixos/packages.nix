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
    (nnn.override { withNerdIcons = true; })
    ranger
    direnv

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
    sshfs

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
    cacert

    # aesthetics
    lolcat
    starship
    hyprpaper
    hyprcursor
    catppuccin-cursors.mochaDark

    (makeDesktopItem {
      name = "nvim-ghostty";
      exec = "ghostty -e nvim %F";
      icon = "nvim";
      desktopName = "nvim";
      genericName = "Launches Neovim in Ghostty";
      categories = [ "Utility" "TextEditor" ];
    })
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
      # tmp
      inputs.zen-browser.packages.${pkgs.system}.default

      unstable.claude-code
      code-cursor

      eww
      nemo
      albert
      hyprpicker
      flameshot-grim
      unstable.satty

      # vial
      unstable.keymapp
      unstable.wally-cli
      qmk
      solaar

      thunderbird
      slack
      # zoom

      obsidian
      zotero_7
      anki
      zathura
      masterpdfeditor4
      quarto
      qalculate-gtk
      gnuplot
      gromit-mpx
      vlc

      blender

    ];
  };

  # services.mullvad-vpn.enable = true;
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
