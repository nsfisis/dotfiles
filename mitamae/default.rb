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

directory "#{home}/.config/skk"

execute "home-manager switch" do
  command "nix run 'nixpkgs#home-manager' -- switch --flake '.##{node[:name]}'"
end

if node[:profile] == "private"
  execute "rustup: install nightly toolchain" do
    command "rustup toolchain install nightly"
    not_if "rustup toolchain list | grep nightly"
  end
end
