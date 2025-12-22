dotfiles for omuomugin

## Initial

- install Google Chrome
- Login to 1Password from Web
- Open GitHub and Login
- see https://github.com/omuomugin/dotfiles and download with zip (or else)
- run `sh initial_setup.sh`
- run `mise install

## After installing application and git

```sh
sh ./scripts/git_setup.sh
```

generate key and add key to GitHub Developers Setting

```sh
ghq get git@github.com:omuomugin/dotfiles.git
# move to omuomugin/dotfiles
sh scripts/link_dotfiles.sh
```

## Terminal Profile
import `terminal_profile.terminal` from terminal setting.

## Raycast
import `xxxx.raycast` from raycast setting.
