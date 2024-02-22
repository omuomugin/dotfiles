# General
## Keyboard speed
defaults write -g NSGlobalDomain KeyRepeat -int 2
defaults write -g NSGlobalDomain InitialKeyRepeat -int 15

## Mouse speed
defaults write -g com.apple.mouse.scaling 5

## Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Dock
## hide dock automatically
defaults write -g com.apple.dock autohide -bool true

# Finder
## hide desktop icons
defaults write -g com.apple.finder CreateDesktop -bool false

## show hidden files
defaults write -g com.apple.finder AppleShowAllFiles YES

# reset
killall Finder
killall Dock