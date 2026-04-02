#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'Keyboard'

execute "defaults write -g AppleKeyboardUIMode -int 3" \
    "Enable full keyboard access for all controls"

execute "defaults write -g ApplePressAndHoldEnabled -bool false" \
    "Disable press-and-hold in favor of key repeat"

execute "defaults write -g 'InitialKeyRepeat_Level_Saved' -int 10" \
    "Set delay until repeat"

execute "defaults write -g KeyRepeat -int 1" \
    "Set the key repeat rate to fast"

execute "defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false" \
    "Disable smart quotes"

execute "defaults write -g NSAutomaticDashSubstitutionEnabled -bool false" \
    "Disable smart dashes"

execute "defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false" \
    "Disable smart periods"
    
print_info 'Language & Region'

execute "defaults write -g AppleLanguages -array 'en'" \
    "Set language"

execute "defaults write -g AppleMeasurementUnits -string 'Centimeters'" \
    "Set measurement units"

execute "defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false" \
    "Disable auto-correct"
