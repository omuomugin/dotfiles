# see also https://macos-defaults.com/

# General
## Keyboard speed
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

## Mouse speed
defaults write -g com.apple.mouse.scaling 7
defaults write -g com.apple.trackpad.scaling 7

## Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Dock
## hide dock automatically
defaults write com.apple.dock "autohide" -bool "true"

# Desktop
## hide desktop icons
defaults write com.apple.finder "CreateDesktop" -bool "false"

# Finder
## show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "false"

# [Sonoma] 
## Diable showing tool tip when switching language
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

# reset
killall Dock
killall Finder

# you should reboot if you want to apply it all