{ pkgs, specialArgs, ... }:
let
  username = specialArgs.env.username;
  homeDirectory = specialArgs.env.homeDirectory;
  clipboardCopyCommand = specialArgs.env.gui.clipboard.copyCommand;
  requiresWlClipboard = clipboardCopyCommand == "wl-copy";
  terminalApp = specialArgs.env.gui.terminalApp;
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
    pkgs.efm-langserver
    pkgs.fd
    pkgs.fzf
    pkgs.gcc
    pkgs.git
    pkgs.gnumake
    pkgs.go
    pkgs.gopls
    pkgs.hyperfine
    pkgs.jnv
    pkgs.jq
    pkgs.neovim
    pkgs.nodejs_20
    pkgs.pandoc
    pkgs.phpactor
    pkgs.pwgen
    pkgs.python314
    pkgs.ripgrep
    pkgs.ruby_3_4
    pkgs.rustup
    pkgs.sqlite
    pkgs.tokei
    pkgs.tree
    pkgs.vim
    pkgs.zig_0_13

    (pkgs.php84.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [
        ffi
      ]));
      extraConfig = ''
        ffi.enable=true
      '';
    })
    pkgs.php84Packages.composer

    pkgs.nodePackages.pnpm
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.yarn
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
    # XDG Base Directories: PHP
    PHP_HISTFILE = "${XDG_CACHE_HOME}/php_history";
    # XDG Base Directories: SQLite
    SQLITE_HISTORY = "${XDG_CACHE_HOME}/sqlite_history";

    # Locale settings
    LANG = "en_US.utf-8";
    LC_ALL = "";
    # Locale: less
    LESSCHARSET = "utf-8";

    # Editor
    VISUAL = "nvim";
    EDITOR = "nvim";

    # Bat
    BAT_THEME = "base16";
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
    escapeTime = 5;
    historyLimit = 50000;
    mouse = false;
    prefix = "C-t";
    terminal = "tmux-256color";

    extraConfig =
      let
        commonConfig = builtins.readFile ./config/tmux/tmux.conf;
        clipboardConfig = if clipboardCopyCommand != null then
                            ''
                              bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${clipboardCopyCommand}"
                            ''
                          else
                            "";
        terminalConfig = if terminalApp == "alacritty" then
                           ''
                             set-option -ga terminal-overrides ',alacritty:RGB'
                           ''
                         else
                           "";
      in
      commonConfig + clipboardConfig + terminalConfig;
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = builtins.readFile ./config/fish/config.fish;
    shellInitLast = builtins.readFile ./config/fish/path.fish;
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      command_timeout = 1000;
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

  programs.gh.enable = true;
}
