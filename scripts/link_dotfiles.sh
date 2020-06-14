#!/bin/sh

# link dotfiles
DOT_FILES=(
  .gitconfig
  .zshrc
  starship.toml
  .aliases
  .gitmessage
)

for file in ${DOT_FILES[@]}
  do
    ln -s $HOME/workspace/github.com/omuomugin/dotfiles/$file $HOME/$file
  done

echo "linked dotfiles"