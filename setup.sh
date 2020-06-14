#!/bin/sh

xcode-select --install

echo "start setting up...."

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# installing homebrew and other app by homebrew bundle
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/bundle
brew bundle install
echo "homebrew ready"

# brew bundle
brew bundle
echo "installing brew completed"

sh ./scripts/link_dotfiles.sh

echo "setup completed...."

restart # --> alias
