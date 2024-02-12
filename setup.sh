#!/bin/sh

xcode-select --install

echo "start setting up...."

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# installing homebrew and other app by homebrew bundle
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/bundle

# in case if failed
## see also https://github.com/Homebrew/brew/pull/9383
# git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core fetch --unshallow
# git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask fetch --unshallow

brew bundle install
echo "homebrew ready"

# brew bundle
brew bundle
echo "installing brew completed"

sh ./scripts/link_dotfiles.sh

echo "setup completed...."

exec zsh -l
