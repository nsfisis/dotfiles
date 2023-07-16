{ config, pkgs, ... }:

let
  isWayland = builtins.getEnv "XDG_SESSION_TYPE" == "wayland";
in
{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  home.packages = [
    # pkgs.alacritty
    pkgs.bat
    pkgs.cmake
    pkgs.curl
    pkgs.deno
    pkgs.fd
    pkgs.fzf
    pkgs.gcc
    pkgs.git
    pkgs.go
    pkgs.gopls
    pkgs.jq
    # pkgs.neovim
    pkgs.newsboat
    pkgs.nodejs_18
    pkgs.pandoc
    pkgs.python311
    pkgs.ripgrep
    pkgs.ruby_3_1
    # pkgs.tmux
    pkgs.tokei
    pkgs.tree
    pkgs.zig
    # pkgs.zsh

    pkgs.nodePackages.typescript-language-server
  ] ++ pkgs.lib.optional isWayland pkgs.wl-clipboard;

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
