#!/bin/bash

. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Chrome\n\n"

execute "defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true" \
    "Expand print dialog by default"

execute "defaults write com.google.Chrome DisablePrintPreview -bool true" \
    "Use system-native print preview dialog"

killall "Google Chrome" &> /dev/null
