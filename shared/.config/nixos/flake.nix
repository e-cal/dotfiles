{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # WARNING: temp while zen not in nixpkgs
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    direnv-instant.url = "github:Mic92/direnv-instant";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          permittedInsecurePackages = [
            "electron-25.9.0"
            "qtwebkit-5.212.0-alpha4"
            "openssl-1.1.1w"
            "mbedtls-2.28.10"
          ];
        };
      };

      overlays = [
        (_: super: {
          neovim-custom = pkgs.wrapNeovimUnstable
            (super.neovim-unwrapped.overrideAttrs (oldAttrs: {
              buildInputs = oldAttrs.buildInputs ++ [ super.tree-sitter ];
            })) (pkgs.neovimUtils.makeNeovimConfig {
              extraLuaPackages = p: with p; [ p.magick ];
              extraPython3Packages = p:
                with p; [
                  pynvim
                  jupyter-client
                  ipython
                  nbformat
                  cairosvg
                ];
              extraPackages = p: with p; [ imageMagick ];
              withNodeJs = true;
              withRuby = true;
              withPython3 = true;
              customRC = "luafile ~/.config/nvim/init.lua";
            });

          pythonWithPkgs = super.python3.withPackages (ps:
            with ps; [
              requests
              setuptools
              wheel
              ipython
              jupyter
              catppuccin
              pygments
              pyqt6
              pip
              uv
            ]);

          flameshot-grim = super.flameshot.overrideAttrs (oldAttrs: {
            cmakeFlags = (oldAttrs.cmakeFlags or [ ])
              ++ [ "-DUSE_WAYLAND_GRIM=ON" ];
            buildInputs = (oldAttrs.buildInputs or [ ])
              ++ [ super.wayland super.wayland-protocols super.grim ];
          });

        })
      ];

      pkgs = import nixpkgs ({
        inherit system;
        inherit (nixpkgsConfig) config;
        inherit overlays;
      });

      unstable = import nixpkgs-unstable ({
        inherit system;
        inherit (nixpkgsConfig) config;
        inherit overlays;
      });

    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs unstable; };
        modules =
          [ ./configuration.nix inputs.home-manager.nixosModules.default ];
      };

    };
}
