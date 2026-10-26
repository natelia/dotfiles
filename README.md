# dotfiles starter — pi + herdr + ghostty

Curated dotfiles, managed with [chezmoi](https://www.chezmoi.io). Gruvbox Dark everywhere.

## What's inside

- **Ghostty** terminal: Gruvbox Dark, ligatures, copy-on-select. Every new window opens straight into herdr.
- **Herdr** terminal multiplexer: alt+t new tab, alt+n/p switch tab, alt+backslash split, alt+h/j/k/l move focus, alt+y new tab with pi in it (needs `jq`).
- **Pi** coding agent: package list (subagents, agent browser, todo, ask-user), keybindings, theme.
- **Fish** shell: git/docker/fd/rg abbreviations, zoxide as `cd`, starship prompt, fzf with gruvbox colors.
- **Skills**: brainstorming, writing-plans, deep-research, find-skills.

## Prerequisites

Required: `fish ghostty herdr pi node pnpm jq starship` and a Nerd Font
(config uses `LigaMonaco Nerd Font` — change `font-family` in `dot_config/ghostty/config` if you use another).

Optional (aliases turn on when installed): `eza bat procs bottom zoxide fzf mise lazygit delta`

Arch: `sudo pacman -S fish starship eza bat procs bottom zoxide fzf jq`
macOS: `brew install fish starship eza bat procs bottom zoxide fzf jq`

## Install

```bash
unzip dotfiles-starter.zip
cp -r dotfiles-starter/. ~/.local/share/chezmoi/
chezmoi diff    # preview what changes
chezmoi apply
```

## After install

1. Open Ghostty. You land in herdr; `alt+y` starts pi in a new tab.
2. Point pi at your own model: edit `~/.pi/agent/settings.json`
   (`defaultProvider`, `defaultModel`, `enabledModels`) and add your API key.
   It ships pointing at `zai` / `glm-5.3`. See `pi` docs → models.
3. Run `pi` once — it installs the packages listed in settings.
4. macOS only: delete the `window-decoration`, `adw-toolbar-style`, and
   `gtk-single-instance` lines from `~/.config/ghostty/config` (Linux-only options).

## Changing things later

Edit files under `~/.local/share/chezmoi`, then:

```bash
chezmoi diff && chezmoi apply
```

Full rules in `AGENTS.md`. Never edit `~/.config/*` directly.
