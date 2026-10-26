# Global agent rules

Rules for any AI coding agent working on this machine.

## Dotfiles (chezmoi)

- **All dotfiles changes must go through chezmoi.** Never edit dotfiles directly in `$HOME` (e.g. `~/.config/fish/config.fish`, `~/.gitconfig`, `~/.config/...`).
- The chezmoi source directory is `~/.local/share/chezmoi`. Edit files there instead of editing targets in `$HOME`.
- After changing files in the source directory, apply with:
  ```bash
  chezmoi apply
  ```
- To see what would change before applying:
  ```bash
  chezmoi diff
  ```
- To bring a newly created/modified file in `$HOME` under chezmoi management:
  ```bash
  chezmoi add <path>
  ```
- Templates use chezmoi's syntax (`.tmpl` files, `chezmoiData`, etc.). Don't hardcode machine-specific values when a template variable exists.
- Commit and push each change in the source directory with a descriptive message (the repo is `your-dotfiles`).

## General

- The user's login shell is fish. Write shell commands, aliases, and scripts in fish syntax. Shell config lives in `~/.config/fish/` and is chezmoi-managed.
- Do not edit files under `$HOME` that are managed by other tools without checking first (`chezmoi managed` lists chezmoi's targets).
- Prefer minimal, targeted edits over rewrites.

## Pi configuration and agent skills

- All changes to Pi configuration (`~/.pi/`) must be managed by chezmoi, committed, and pushed.
- User-authored skills live in `~/.agents/skills/` only. Manage them through chezmoi.
- Pi package skills and Hermes-generated skills are runtime-owned resources. Keep them in their package or Hermes storage roots; do not copy or symlink them into the user-authored skill directory.
- Do not create duplicate skill symlinks under `~/.pi/agent/skills/`.
- Every user-authored skill must be managed by chezmoi (`chezmoi add ~/.agents/skills/<name>`), committed, and pushed.
