#!/bin/sh

# link dotfiles
DOT_FILES=(
  .gitconfig
  .zshrc
  starship.toml
  .aliases
  .gitmessage
  # afx
  .config/afx/github.yaml
  .config/afx/gh-extensions.yaml
)

for file in ${DOT_FILES[@]}
  do
    rm $HOME/$file
    ln -s $HOME/workspace/github.com/omuomugin/dotfiles/$file $HOME/$file
  done

echo "linked dotfiles"