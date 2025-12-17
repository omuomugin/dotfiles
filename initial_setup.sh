#!/bin/sh
xcode-select --install

# create dir for code workspace
mkdir $HOME/workspace
echo "workspace dir created"

# install tools using mise
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

# install tools using homebre
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# FIXME: 
# brew bundle

# zsh-autosuggestions
## see also https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# git-prompt
curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# set mac os settings
sh ./scripts/mac_os_set_default.sh

# reset
# sudo reboot
