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

  news.display = "silent";

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
    pkgs.hyperfine
    pkgs.jq
    pkgs.neovim
    pkgs.nodejs_18
    pkgs.pandoc
    pkgs.pwgen
    pkgs.python311
    pkgs.ripgrep
    pkgs.ruby_3_1
    pkgs.rustup
    pkgs.sqlite
    pkgs.tokei
    pkgs.tree
    pkgs.vim
    pkgs.zig

    (pkgs.php83.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [
        ffi
      ]));
      extraConfig = ''
        ffi.enable=true
      '';
    })

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

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      format = "[$directory$git_branch$git_commit$git_status$git_state](bold fg:75)$fill$cmd_duration$time$line_break$character";
      continuation_prompt = "[❯](fg:63)[❯](fg:62)[❯](fg:61) ";
      character = {
        success_symbol = "[❯](fg:150)[❯](fg:153)[❯](fg:159)";
        error_symbol = "[❯](fg:172)[❯](fg:173)[❯](fg:174)";
      };
      directory = {
        format = "$path ";
        use_os_path_sep = false;
        truncate_to_repo = false;
        truncation_length = 99;
      };
      git_branch = {
        format = "\\($branch\\)";
      };
      git_commit = {
        format = "\\($hash$tag\\)";
        tag_disabled = false;
        tag_symbol = " @";
      };
      git_status = {
        format = "$conflicted$modified$untracked$staged$stashed";
        conflicted = "!";
        modified = "~";
        untracked = "?";
        staged = "*";
        stashed = " \\[$count\\]";
      };
      git_state = {
        format = " - $state ($progress_current/$progress_total) ";
      };
      cmd_duration = {
        format = "~$duration ";
      };
      time = {
        disabled = false;
        format = "\\[$time\\] ";
        time_format = "%T";
      };
      fill = {
        symbol = " ";
      };
    };
  };
}
