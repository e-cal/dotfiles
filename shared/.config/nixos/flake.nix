{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, ... }@inputs:
    let
      system = "x86_64-linux";

      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          permittedInsecurePackages =
            [ "electron-25.9.0" "qtwebkit-5.212.0-alpha4" "openssl-1.1.1w" ];
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

      master = import nixpkgs-master ({
        inherit system;
        inherit (nixpkgsConfig) config;
        inherit overlays;
      });
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs pkgs unstable master; };
        modules =
          [ ./configuration.nix inputs.home-manager.nixosModules.default ];
      };

    };
}
