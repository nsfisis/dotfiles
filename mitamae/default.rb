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

execute "home-manager switch" do
  command "nix run 'nixpkgs#home-manager' -- switch --flake '.##{node[:name]}'"
  not_if "type home-manager"
end

link "#{home}/.config/nvim" do
  to "#{home}/dotfiles/.config/nvim"
end
directory "#{home}/.config/skk"

if node[:profile] == "private"
  execute "rustup: install nightly toolchain" do
    command "rustup toolchain install nightly"
    not_if "rustup toolchain list | grep nightly"
  end

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
  command "nix run 'nixpkgs#home-manager' -- switch --flake '.##{node[:name]}'"
end
