#!/bin/sh

xcode-select --install

echo "start setting up...."

sh ./scripts/link_dotfiles.sh

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

# zsh-autosuggestions
## see also https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# java
## see also https://formulae.brew.sh/formula/openjdk
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# mac os general
sh ./scripts/mac_os_set_default.sh

# afx
echo "installing afx"
curl -sL https://raw.githubusercontent.com/babarot/afx/HEAD/hack/install | sh
afx install
echo "installed afx"

# closing
echo "setup completed...."

exec zsh -l
