# Install

## Hotaru

```
$ sudo apt update
$ sudo apt upgrade

$ ./bootstrap hotaru

$ sudo adduser $(whoami) docker

$ cargo install alacritty

$ cd ~/src/reparojson
$ cargo install --path .
```

## PC 168

```
$ brew update
$ brew upgrade

$ brew install libiconv

$ ./bootstrap pc168

$ brew install --cask alacritty

# Latest version: https://github.com/adobe-fonts/source-han-code-jp/releases/latest
$ curl -fLo ~/Library/Fonts/SourceHanCodeJP.ttc --create-dirs https://github.com/adobe-fonts/source-han-code-jp/releases/download/2.012R/SourceHanCodeJP.ttc
$ sudo atsutil databases -remove

$ /usr/local/opt/ncurses/bin/infocmp tmux-256color > /var/tmp/tmux-256color.info
$ tic -xe tmux-256color /var/tmp/tmux-256color.info

# Restart your machine.
```

# Update

* `nix flake update`
* `nix store gc`
* `home-manager switch --flake ".#<host>"`
