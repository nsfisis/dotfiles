{
  pkgs,
  nurpkgs,
  nodeName,
  env,
  ...
}:
let
  username = env.username;
  homeDirectory = env.homeDirectory;
  clipboardCopyCommand = env.gui.clipboard.copyCommand;
  requiresWlClipboard = clipboardCopyCommand == "wl-copy";
  terminalApp = env.gui.terminalApp;
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  news.display = "silent";

  home.packages =
    [
      # pkgs.alacritty
      pkgs.bat
      pkgs.bed
      pkgs.curl
      pkgs.deno
      pkgs.efm-langserver
      pkgs.fd
      pkgs.fzf
      pkgs.git
      pkgs.glab
      pkgs.gnumake
      pkgs.go
      pkgs.gomi
      pkgs.htop
      pkgs.hyperfine
      pkgs.imagemagick
      pkgs.jnv
      pkgs.jq
      pkgs.just
      pkgs.mmv-go
      pkgs.neovim
      pkgs.nodejs_22
      pkgs.pandoc
      pkgs.phpactor
      pkgs.pwgen
      pkgs.python314
      pkgs.ripgrep
      pkgs.ruby_3_4
      pkgs.similarity
      pkgs.sqlite
      pkgs.tokei
      pkgs.tree
      pkgs.universal-ctags
      pkgs.vim

      pkgs.nodePackages.pnpm
      pkgs.nodePackages.typescript-language-server
      pkgs.nodePackages.yarn

      nurpkgs.claude-code
      nurpkgs.deck
      nurpkgs.hgrep

      nurpkgs.git-helpers
      nurpkgs.reparojson
      nurpkgs.term-banner
      nurpkgs.term-clock
    ]
    ++ (
      let
        php = (
          pkgs.php84.buildEnv {
            extensions = { enabled, all }: enabled ++ [ all.ffi ];
            extraConfig = ''
              ffi.enable=true
            '';
          }
        );
      in
      [
        php
        php.packages.composer
      ]
    )
    ++ pkgs.lib.optional requiresWlClipboard pkgs.wl-clipboard;

  home.file = {
    ".config/alacritty/alacritty.common.toml".source = ../../.config/alacritty/alacritty.common.toml;
    ".config/alacritty/alacritty.local.toml".source = ../../.config/alacritty/alacritty.${env.os}.toml;
    ".config/alacritty/alacritty.toml".source = ../../.config/alacritty/alacritty.toml;
    ".config/fish/completions/git-sw.fish".source = ../../.config/fish/completions/git-sw.fish;
    ".config/gdb/gdbinit".source = ../../.config/gdb/gdbinit;
    ".config/git/ignore".source = ../../.config/git/ignore;
    ".config/nvim".source = ../../.config/nvim;
    ".config/sh/claude-code.sh".source = ../config/sh/claude-code.sh;
    ".config/skk/jisyo.L".source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
    ".config/vim/vimrc".source = ../../.config/vim/vimrc;
    ".local/share/fonts/SourceHanCodeJP.ttc".source =
      "${nurpkgs.source-han-code-jp}/share/fonts/SourceHanCodeJP.ttc";
    ".zshrc".source = ../config/zsh/.zshrc;
    "bin/__claude-code-notify".source = ../../bin/__claude-code-notify;
    "bin/tmux-pane-idx".source = ../../bin/tmux-pane-idx;

    ".config/git/config".text =
      builtins.readFile ../../.config/git/config
      + (
        if builtins.pathExists ../../.config/git/local.${nodeName}.config then
          builtins.readFile ../../.config/git/local.${nodeName}.config
        else
          ""
      );
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

    # Fzf
    FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --exclude .git";

    # Hgrep
    HGREP_DEFAULT_OPTS = "--theme=Nord";
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
        commonConfig = builtins.readFile ../config/tmux/tmux.conf;
        clipboardConfig =
          if clipboardCopyCommand != null then
            ''
              bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${clipboardCopyCommand}"
            ''
          else
            "";
        terminalConfig =
          if terminalApp == "alacritty" then
            ''
              set-option -ga terminal-overrides ',alacritty:RGB'
            ''
          else
            "";
      in
      commonConfig + clipboardConfig + terminalConfig;
  };

  programs.bash = {
    enable = true;

    bashrcExtra = builtins.readFile ../config/bash/.bashrc;
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = builtins.readFile ../config/fish/config.fish;
    shellInitLast =
      builtins.readFile ../config/fish/path.fish
      + (
        if builtins.pathExists ../config/fish/local.${nodeName}.path.fish then
          builtins.readFile ../config/fish/local.${nodeName}.path.fish
        else
          ""
      );
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      command_timeout = 1000;
      format = "[$directory$git_branch$git_commit$git_status$git_state](bold fg:75)$fill$cmd_duration$time$line_break$jobs$shell$nix_shell$direnv$character";
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
        tag_symbol = " @ ";
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
      jobs = {
        style = "white";
        symbol = "+";
      };
      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        fish_indicator = "";
        bash_indicator = "bash ";
        zsh_indicator = "zsh ";
      };
      nix_shell = {
        format = "[N]($style) ";
        style = "white";
        heuristic = true;
      };
      direnv = {
        disabled = false;
        format = "[$loaded]($style)";
        style = "white";
        loaded_msg = "D ";
        unloaded_msg = "";
      };
    };
  };

  programs.gh = {
    enable = true;

    settings.aliases = {
      clone = "repo clone";
    };
  };
}
