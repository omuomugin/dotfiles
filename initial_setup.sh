#!/bin/sh
xcode-select --install

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# install tools using mise
curl https://mise.run | sh

# install tools using homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle

# git-prompt
mkdir -p "~/.zsh"
curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# set mac os settings
sh ./scripts/mac_os_set_default.sh

# reset
# sudo reboot
