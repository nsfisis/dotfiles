{
  pkgs,
  nurpkgs,
  env,
  ...
}:
{
  home.packages = [
    pkgs.clang-tools
    pkgs.cmake
    pkgs.gcc
    pkgs.gopls
    pkgs.rustup
    pkgs.zig
    pkgs.zls
  ];
}
