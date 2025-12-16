#!/bin/sh

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
    rm $HOME/$file
    ln -s $HOME/workspace/github.com/omuomugin/dotfiles/$file $HOME/$file
  done

# karabiner
rm $HOME/.config/karabiner/karabiner.json
ln -s $HOME/workspace/github.com/omuomugin/dotfiles/karabiner.json $HOME/.config/karabiner/karabiner.json

# ghostty
## see also https://ghostty.org/docs/config#xdg-configuration-path-(all-platforms):
rm $HOME/.config/ghostty/config
ln -s $HOME/workspace/github.com/omuomugin/dotfiles/.ghostty $HOME/.config/ghostty/config

# mise
rm $HOME/.config/mise/config.toml
ln -s $HOME/workspace/github.com/omuomugin/dotfiles/.mise.config.toml $HOME/.config/mise/config.toml

echo "linked dotfiles"
