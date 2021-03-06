#!/bin/bash

. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'Terminal'

execute "defaults write com.apple.terminal FocusFollowsMouse -string true" \
    "Make the focus automatically follow the mouse"

execute "defaults write com.apple.terminal SecureKeyboardEntry -bool true" \
    "Enable 'Secure Keyboard Entry'"

execute "defaults write com.apple.terminal StringEncodings -array 4" \
    "Only use UTF-8"

execute "./set_terminal_theme.applescript" \
    "Set custom terminal theme"
