# see also https://macos-defaults.com/

# General
## Keyboard speed
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

## Mouse speed
defaults write -g com.apple.mouse.scaling 7
defaults write -g com.apple.trackpad.scaling 7

# Dock
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "show-recents" -bool "false"

# Desktop
## hide desktop icons
defaults write com.apple.finder "CreateDesktop" -bool "false"

# Finder
## show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "false"
defaults write com.apple.finder "AppleShowAllFiles" -bool "false"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

# Menu Bar
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""

# Others
## Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

## [Sonoma] 
### Diable showing tool tip when switching language
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 0

# ライブ変換をオフ
defaults write -g JIMPrefLiveConversionKey -bool false

# reset
killall Dock
killall Finder

# you should reboot if you want to apply it all