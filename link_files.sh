# link dotfiles
DOT_FILES=(
  .gitconfig
  .zshrc
  starship.toml
)

for file in ${DOT_FILES[@]}
  do
    ln -s $HOME/dotfiles/$file $HOME/$file
  done
