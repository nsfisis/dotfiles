fish_add_path $HOME/go/bin $HOME/.cargo/bin $HOME/.deno/bin $HOME/.local/bin $HOME/bin

# For macOS
if test (uname) = "Darwin"
    set -l nix_profile_dir /nix/var/nix/profiles/default
    if test -f $nix_profile_dir/etc/profile.d/nix-daemon.fish
        source $nix_profile_dir/etc/profile.d/nix-daemon.fish
    end
    if test -f $nix_profile_dir/share/fish/vendor_completions.d/nix.fish
        source $nix_profile_dir/share/fish/vendor_completions.d/nix.fish
    end
    # https://github.com/LnL7/nix-darwin/issues/122
    fish_add_path --move $HOME/.nix-profile/bin
end
