{ pkgs, specialArgs, ... }:
let
  username = specialArgs.env.username;
  homeDirectory = specialArgs.env.homeDirectory;
  clipboardCopyCommand = specialArgs.env.gui.clipboard.copyCommand;
  requiresWlClipboard = clipboardCopyCommand == "wl-copy";
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.11";

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
    pkgs.neovim
    pkgs.nodejs_18
    pkgs.pandoc
    pkgs.php
    pkgs.python311
    pkgs.ripgrep
    pkgs.ruby_3_1
    pkgs.sqlite
    pkgs.tokei
    pkgs.tree
    pkgs.zig

    pkgs.nodePackages.typescript-language-server
  ] ++ pkgs.lib.optional requiresWlClipboard pkgs.wl-clipboard;

  home.file = {
    # "hoge".source = dotfiles/piyo;
  };

  home.sessionVariables = rec {
    # XDG Base Directories
    # See: https://wiki.archlinux.org/title/XDG_Base_Directory
    XDG_CONFIG_HOME = "${homeDirectory}/.config";
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
    # XDG Base Directories: Node.js
    NODE_REPL_HISTORY = "${XDG_CACHE_HOME}/node_repl_history";
    # XDG Base Directories: SQLite
    SQLITE_HISTORY = "${XDG_CACHE_HOME}/sqlite_history";

    # Local
    LANG = "en_US.UTF-8";
    LC_ALL = "";
    # Locale: Less
    LESSCHARSET = "utf-8";
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

    extraConfig =
      let
        commonConfig = builtins.readFile ./config/tmux/tmux.conf;
        extraConfig = if clipboardCopyCommand != null then
          ''
            bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${clipboardCopyCommand}"
          ''
        else
          "";
      in
      commonConfig + extraConfig;
  };

  programs.zsh = {
    enable = true;

    envExtra = ''
      export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
    '';

    initExtra = builtins.readFile ../.zshrc;
  };
}
