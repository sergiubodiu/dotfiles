#!/bin/bash

. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Language & Region\n\n"

execute "defaults write NSGlobalDomain AppleLanguages -array 'en'" \
    "Set language"

execute "defaults write NSGlobalDomain AppleMeasurementUnits -string 'Centimeters'" \
    "Set measurement units"

execute "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false" \
    "Disable auto-correct"
