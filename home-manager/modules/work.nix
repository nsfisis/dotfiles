{
  pkgs,
  nurpkgs,
  env,
  ...
}:
{
  home.sessionVariables = {
    GITLAB_HOST = "https://gitlab.dcdev.jp";
    REDMINE_HOST = "https://redmine.dcdev.jp";
  };
}
