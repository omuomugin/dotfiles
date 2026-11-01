dotfiles for omuomugin

## install tools and apps

```sh
git clone git@github.com:omuomugin/dotfiles.git ~/workspace/github.com/omuomugin/dotfiles
```

- run `sh initial_setup.sh`
- run `sh scripts/link_dotfiles.sh`
- run `mise install`

## setup git

generate key and add key to GitHub Developers Setting

```sh
sh ./scripts/git_setup.sh
```

- install Google Chrome
- Login to 1Password from Web
- Open GitHub and Login
- Register Key to GitHub


## Terminal Profile
import `terminal_profile.terminal` from terminal setting.

## Raycast
import `xxxx.raycast` from raycast setting.

## Herdr

- `mise install` installs the herdr CLI, `brew bundle` installs the Herdr desktop app
- `sh scripts/link_dotfiles.sh` links `.herdr.config.toml` and `herdr-app/`
  - it also merges `herdr-app/shared.overrides.json` (layout, Files/Changes panels) into the app-owned `~/.config/herdr-app/shared.json`. A running app picks the values up on its next start (the layout is switched right away)

- `claude/statusline.sh` is the Claude Code status line. Add it to `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "~/workspace/github.com/omuomugin/dotfiles/claude/statusline.sh" }
```

It also writes the latest rate limits to `~/.cache/claude-usage/`, which the `my-status` mod shows in the Herdr status bar.
