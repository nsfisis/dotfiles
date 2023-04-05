{ config, pkgs, ... }:
{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.packages = [
    # pkgs.alacritty
    pkgs.bat
    pkgs.cmake
    pkgs.curl
    pkgs.deno
    pkgs.fd
    pkgs.fzf
    # pkgs.gcc
    pkgs.git
    pkgs.go
    pkgs.jq
    # pkgs.neovim
    pkgs.newsboat
    pkgs.pandoc
    pkgs.python311
    pkgs.ripgrep
    pkgs.ruby_3_1
    # pkgs.tmux
    pkgs.tokei
    pkgs.tree
    pkgs.zig
    # pkgs.zsh
  ];

  home.file = {
    # "hoge".source = dotfiles/piyo;
  };

  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
