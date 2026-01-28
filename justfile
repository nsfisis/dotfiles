default_host := trim_start_match(file_stem(shell('grep -R -l "$1" "$2"', '"hostname": "' + shell('uname -n') + '"', join(justfile_directory(), "mitamae"))), 'node.')

help:
    @just --list

update HOST=default_host:
    nix flake update
    just switch "{{HOST}}"
    just generate-package-versions
    git add -- flake.lock home-manager/package-versions.txt
    git commit -m "nix: update flake"

update-nur-packages HOST=default_host:
    nix flake update nur-packages
    just switch "{{HOST}}"
    just generate-package-versions
    git add -- flake.lock home-manager/package-versions.txt
    git commit -m "nix: update flake"

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

generate-package-versions:
    home-manager packages | grep -v '\bman$' > home-manager/package-versions.txt

gc:
    home-manager expire-generations '-1 month'
    nix profile wipe-history
    nix store gc

# TODO
copy-claude-code-settings:
    cp .config/claude/settings.json ~/.claude/settings.json
