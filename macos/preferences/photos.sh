#!/bin/bash

. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Photos\n\n"

execute "defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true" \
    "Prevent Photos from opening automatically when devices are plugged in"

killall "Photos" &> /dev/null
