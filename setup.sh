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

sh link_files.sh

echo "linked dotfiles"

echo "setup completed...."
exec zsh -l
