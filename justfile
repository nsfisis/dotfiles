default_host := trim_start_match(file_stem(shell('grep -R -l "$1" "$2"', '"hostname": "' + shell('uname -n') + '"', join(justfile_directory(), "mitamae"))), 'node.')

help:
    @just --list

update HOST=default_host:
    nix flake update
    git add -- ./flake.lock
    git commit -m "nix: update flake"
    just switch "{{HOST}}"

update-nur-packages:
    nix flake update nur-packages

sync HOST=default_host:
    git fetch --all
    if git diff --quiet; then \
        git switch -d origin/main; \
    else \
        git stash save; \
        git switch -d origin/main; \
        git stash pop; \
    fi
    just switch "{{HOST}}"

switch HOST=default_host:
    home-manager switch --flake ".#{{HOST}}"

gc:
    # TODO: leave the last 3 generations?
    # home-manager remove-generations $({ home-manager generations | tail +4 && date -d '-1 month' '+%Y-%m-%d %H:%M : id DELETE ->'; } | sort -r | sed -n '/: id DELETE ->/,$p' | tail +2 | grep -o ': id [0-9]* ->' | awk '{ print $3; }')
    home-manager expire-generations '-1 month'
    nix profile wipe-history
    nix store gc

# TODO
copy-claude-code-settings:
    cp .config/claude-code/settings.json ~/.claude/
