http_request ".bootstrap/nix-install" do
  url "https://nixos.org/nix/install"
end

execute "nix-install" do
  command "sh .bootstrap/nix-install --daemon"
  not_if "test -d /nix"
end

file "/etc/nix/nix.conf" do
  action :edit
  block do |content|
    content + "experimental-features = nix-command flakes\n"
  end
  not_if "grep -q 'nix-command flakes' /etc/nix/nix.conf"
end

home = ENV['HOME']

directory "#{home}/.local/state/nix/profiles"

# XDG Base Directories
directory "#{home}/.config"
directory "#{home}/.cache"
directory "#{home}/.local/share"
directory "#{home}/.local/state"

directory "#{home}/bin"

execute "home-manager" do
  command "nix run 'nixpkgs#home-manager' -- switch --flake '.##{node[:name]}'"
  not_if "type home-manager"
end

# These dotfiles are not managed by home-manager for now.

link "#{home}/.vimrc" do
  to "#{home}/dotfiles/.vimrc"
end
link "#{home}/.config/alacritty" do
  to "#{home}/dotfiles/.config/alacritty"
end
link "#{home}/.config/git" do
  to "#{home}/dotfiles/.config/git"
end
link "#{home}/.config/nvim" do
  to "#{home}/dotfiles/.config/nvim"
end

directory "#{home}/bin"

# Go
execute "go" do
  command "go build -o #{home}/bin/git-extract-issue src/gitalias/git-extract-issue.go"
  not_if "test -f #{home}/bin/git-extract-issue"
end
execute "go" do
  command "go build -o #{home}/bin/git-sw src/gitalias/git-sw.go"
  not_if "test -f #{home}/bin/git-sw"
end

link "#{home}/bin/tmux-pane-idx" do
  to "#{home}/dotfiles/bin/tmux-pane-idx"
end

# SKK
directory "#{home}/.config/skk"
http_request "#{home}/.config/skk/SKK-JISYO.L.unannotated.gz" do
  url "https://skk-dev.github.io/dict/SKK-JISYO.L.unannotated.gz"
end
execute "unzip skk" do
  command "gunzip -cd #{home}/.config/skk/SKK-JISYO.L.unannotated.gz > #{home}/.config/skk/jisyo.L"
  not_if "test -f #{home}/.config/skk/jisyo.L"
end

link "#{home}/.config/alacritty/alacritty.local.toml" do
  is_macos = node[:targetArch].include?("darwin")
  to "#{home}/.config/alacritty/alacritty.#{is_macos ? "macos" : "linux"}.toml"
end

# Rust
execute "rustup: install nightly toolchain" do
  command "rustup toolchain install nightly"
  not_if "rustup toolchain list | grep nightly"
end
execute "cargo: install hgrep" do
  command "cargo install hgrep"
  not_if "type hgrep"
end

if node[:profile] == "private"
  package "pkg-config"
  package "libssl-dev"

  execute "cargo: install cargo-compete" do
    envs = {
      CFLAGS: "-I/usr/include",
      OPENSSL_LIB_DIR: "/usr/lib/x86_64-linux-gnu",
      OPENSSL_INCLUDE_DIR: "/usr/include/x86_64-linux-gnu",
    }
    command "#{envs.map{"#{_1}=#{_2}"}.join(" ")} cargo install cargo-compete"
    not_if "type cargo-compete"
  end
end

execute "home-manager switch" do
  command "home-manager switch --flake '.##{node[:name]}'"
end
