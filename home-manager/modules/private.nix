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
    pkgs.typst
    pkgs.zig
    pkgs.zls
  ];
}
