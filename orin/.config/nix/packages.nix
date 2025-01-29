let
  config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  pkgs = import <nixpkgs> {
    inherit config;
    overlays = [
      (self: super: {
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
            pip
            setuptools
            wheel
	          cython
            ipython
            jupyter
            (catppuccin.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ])
                ++ [ pygments ];
            }))
            pygments
	    # torch
          ]);
      })
    ];
  };

  unstable = import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-unstable.tar.gz) {
    inherit config;
  };
in
with pkgs;
[
  neovim-custom
  git
  wget
  tmux
  stow
  zoxide
  direnv

  eza
  bat
  fzf
  ripgrep
  jq
  jc
  zip
  unzip
  lazygit
  unstable.github-cli
  imagemagick
  luajitPackages.magick
  ffmpeg
  difftastic

  lolcat
  starship

  # pythonWithPkgs
  # unstable.uv
  # python312Packages.ipython
  # cudaPackages.cudatoolkit
  # cudaPackages.cudnn
  gcc
  cmake
  lua
  luajitPackages.luarocks
  nodejs_22
  tree-sitter
  go

  yapf
  shfmt
  nixfmt
  stylua
  nodePackages.prettier

  ollama

  chromium
  # rustdesk
]
