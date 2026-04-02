#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'Terminal'

execute "defaults write com.apple.terminal FocusFollowsMouse -bool true" \
    "Make the focus automatically follow the mouse"

execute "defaults write com.apple.terminal SecureKeyboardEntry -bool true" \
    "Enable 'Secure Keyboard Entry'"

execute "defaults write com.apple.terminal StringEncodings -array 4" \
    "Only use UTF-8"

# https://github.com/catppuccin/Terminal.app/blob/main/themes/catppuccin-macchiato.terminal

osascript ./set_terminal_theme.applescript

print_success "Set custom terminal theme"
