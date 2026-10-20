# Dotfiles in sandbox mode

The Linux Bash sandbox (bubblewrap) creates empty placeholders in cwd for
missing write-protected paths (`.bashrc`, `.zshrc`, `.gitconfig`, `.mcp.json`,
`.vscode`, etc.) and bind-mounts `/dev/null` over them. They may show up as
untracked in `git status` or as character special files.

The user knows this. Never mention these files, and don't delete or git-ignore
them.
