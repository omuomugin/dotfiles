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
    rm "$HOME/$file"
    ln -s "$DOTFILES_DIR/$file" "$HOME/$file"
  done

ls -l "$HOME/$file"

# karabiner
rm "$HOME/.config/karabiner/karabiner.json"
ln -s "$DOTFILES_DIR/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
ls -l "$HOME/.config/karabiner/karabiner.json"

# ghostty
## see also https://ghostty.org/docs/config#xdg-configuration-path-(all-platforms):
rm "$HOME/.config/ghostty/config"
ln -s "$DOTFILES_DIR/.ghostty" "$HOME/.config/ghostty/config"
ls -l "$HOME/.config/ghostty/config"

# mise
rm "$HOME/.config/mise/config.toml"
ln -s "$DOTFILES_DIR/.mise.config.toml" "$HOME/.config/mise/config.toml"
ls -l "$HOME/.config/mise/config.toml"

echo "linked dotfiles"
