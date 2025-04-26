help:
    @just --list

update HOST:
    nix flake update
    git add -- ./flake.lock
    git commit -m "nix: update flake"
    just switch "{{HOST}}"

sync HOST:
    git fetch --all
    git stash save
    git switch -d origin/main
    git stash pop
    just switch "{{HOST}}"

switch HOST:
    home-manager switch --flake ".#{{HOST}}"

gc:
    # TODO: leave the last 3 generations?
    # home-manager remove-generations $({ home-manager generations | tail +4 && date -d '-1 month' '+%Y-%m-%d %H:%M : id DELETE ->'; } | sort -r | sed -n '/: id DELETE ->/,$p' | tail +2 | grep -o ': id [0-9]* ->' | awk '{ print $3; }')
    home-manager expire-generations '-1 month'
    nix profile wipe-history
    nix store gc
