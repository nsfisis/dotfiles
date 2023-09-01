{ pkgs, ... }:

let
  isWayland = builtins.getEnv "XDG_SESSION_TYPE" == "wayland";
in
{
  home.username = "ken";
  home.homeDirectory = "/home/ken";

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
    pkgs.sqlite
    pkgs.tmux
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

  programs.tmux = {
    enable = true;

    sensibleOnTop = false;

    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = false;
    prefix = "C-t";
    terminal = "tmux-256color";

    extraConfig = (
      let
        commonConfig = builtins.readFile ./config/tmux/tmux.conf;
        extraConfig = if isWayland then
          ''
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
          ''
        else
          ''
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
          '';
      in
      commonConfig + extraConfig
    );
  };
}
