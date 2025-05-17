#!/bin/sh
xcode-select --install

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# installing homebrew and other app by homebrew bundle
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap homebrew/bundle

brew bundle install
echo "homebrew ready"

# brew bundle
brew bundle
echo "installing brew completed"

# zsh-autosuggestions
## see also https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# git-prompt
curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# java
## see also https://formulae.brew.sh/formula/openjdk
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
## maybe need to restart
nvm install 22

# biff
sh ./install/install_biff.sh

# set mac os settings
sh ./scripts/mac_os_set_default.sh

# reset
sudo reboot
