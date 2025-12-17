#!/bin/sh

# Set dotfiles directory (default to the original path if not specified)
DOTFILES_DIR=${DOTFILES_DIR:-$HOME/workspace/github.com/omuomugin/dotfiles}

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

echo "linked dotfiles"
