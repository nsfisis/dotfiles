{
  pkgs,
  nurpkgs,
  env,
  ...
}:
{
  home.sessionVariables = {
    GITLAB_HOST = "https://gitlab.dcdev.jp";
  };
}
