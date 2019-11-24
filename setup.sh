xcode-select --install

echo "start setting up...."

# installing homebrew and other app by homebrew bundle
sh homebrew_setup.sh
echo "home brew completed"

# installing tools from npm
sh npm_setup.sh
echo "npm setup completed"

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# link dotfiles
DOT_FILES=(
  .gitconfig
  .zshrc
)

for file in ${DOT_FILES[@]}
  do
    ln -s $HOME/dotfiles/$file $HOME/$file
  done

echo "linked dotfiles"

# setting up git
sh git_setup.sh
echo "git setup and ssh key is on clipboard"

echo "setup completed...."
exec zsh -l
