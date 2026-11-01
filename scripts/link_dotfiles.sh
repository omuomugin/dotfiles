#!/bin/sh

# Set dotfiles directory (default to the original path if not specified)
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

# link dotfiles
DOT_FILES=(
  .gitconfig
  .zshrc
  .aliases
  .gitmessage
  themes.gitconfig
)

for file in ${DOT_FILES[@]}
  do
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    ls -l "$HOME/$file"
  done

# karabiner
mkdir -p "$HOME/.config/karabiner"
ln -sf "$DOTFILES_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ls -l "$HOME/.config/karabiner/karabiner.json"

# ghostty
## see also https://ghostty.org/docs/config#xdg-configuration-path-(all-platforms):
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/.ghostty" "$HOME/.config/ghostty/config"
ls -l "$HOME/.config/ghostty/config"

# mise
mkdir -p "$HOME/.config/mise"
ln -sf "$DOTFILES_DIR/.mise.config.toml" "$HOME/.config/mise/config.toml"
ls -l "$HOME/.config/mise/config.toml"

# sheldon
mkdir -p "$HOME/.config/sheldon"
ln -sf "$DOTFILES_DIR/.sheldon.plugins.toml" "$HOME/.config/sheldon/plugins.toml"
ls -l "$HOME/.config/sheldon/plugins.toml"

# pnpm
## see also https://pnpm.io/settings
mkdir -p "$HOME/Library/Preferences/pnpm"
ln -sf "$DOTFILES_DIR/.pnpm.config.yaml" "$HOME/Library/Preferences/pnpm/config.yaml"
ls -l "$HOME/Library/Preferences/pnpm/config.yaml"

# uv
## see also https://docs.astral.sh/uv/concepts/configuration-files/
mkdir -p "$HOME/.config/uv"
ln -sf "$DOTFILES_DIR/.uv.toml" "$HOME/.config/uv/uv.toml"
ls -l "$HOME/.config/uv/uv.toml"

# herdr
## see also `herdr --default-config`
mkdir -p "$HOME/.config/herdr"
ln -sf "$DOTFILES_DIR/.herdr.config.toml" "$HOME/.config/herdr/config.toml"
ls -l "$HOME/.config/herdr/config.toml"

# herdr desktop app
## see also ~/.config/herdr-app/AGENTS.md (other files there are written by the app)
## select the layout once on a new machine: herdr-app do layout.switch '{"name":"my-main"}'
HERDR_APP_FILES=(
  settings.json
  keys.json
  layouts/my-main.json
  mods/my-spaces
  mods/my-status
)
mkdir -p "$HOME/.config/herdr-app/layouts" "$HOME/.config/herdr-app/mods"
for file in ${HERDR_APP_FILES[@]}
  do
    # -n: replace an existing symlink to a directory instead of linking inside it
    ln -sfn "$DOTFILES_DIR/herdr-app/$file" "$HOME/.config/herdr-app/$file"
    ls -l "$HOME/.config/herdr-app/$file"
  done

echo "linked dotfiles"
