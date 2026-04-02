#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'UI & UX'

execute "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true" \
   "Avoid creating '.DS_Store' files on network volumes"

# execute "defaults write com.apple.menuextra.battery ShowPercent -string 'NO'" \
#     "Hide battery percentage from the menu bar"

execute "defaults write com.apple.CrashReporter UseUNC 1" \
    "Make crash reports appear as notifications"

# execute "defaults write com.apple.LaunchServices LSQuarantine -bool false" \
#     "Disable 'Are you sure you want to open this application?' dialog"

execute "defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true" \
    "Automatically quit the printer app once the print jobs are completed"

# Screenshots
execute "defaults write com.apple.screencapture disable-shadow -bool true && \
         defaults write com.apple.screencapture location -string '${HOME}/Desktop' && \
         defaults write com.apple.screencapture type -string 'png'" \
    "Screenshots: no shadow, save to Desktop as PNG"

execute "defaults write com.apple.screensaver askForPassword -int 1 && \
         defaults write com.apple.screensaver askForPasswordDelay -int 0"\
    "Require password immediately after into sleep or screen saver mode"

execute "defaults write -g AppleFontSmoothing -int 0" \
    "Enable subpixel font rendering on non-Apple LCDs"

execute "defaults write -g AppleShowScrollBars -string 'Always'" \
    "Always show scrollbars"

execute "defaults write -g NSDisableAutomaticTermination -bool true" \
    "Disable automatic termination of inactive apps"

execute "defaults write -g NSNavPanelExpandedStateForSaveMode -bool true" \
    "Expand save panel by default"

execute "defaults write -g NSUseAnimatedFocusRing -bool false" \
    "Disable the over-the-top focus ring animation"

# execute "defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false" \
#     "Disable resume system-wide"

execute "defaults write -g PMPrintingExpandedStateForPrint -bool true" \
    "Expand print panel by default"

# execute "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string 'Laptop' && \
#          sudo scutil --set ComputerName 'laptop' && \
#          sudo scutil --set HostName 'laptop' && \
#          sudo scutil --set LocalHostName 'laptop'" \
#     "Set computer name"
# Changing the name of a OSX

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# changehostname() {
#    if [ $# -eq 0  ]; then
#        echo 'Usage: changehostname laptop01'
#    else
#         sudo scutil --set HostName $1
#  	      sudo scutil --set LocalHostName $1
#  	      sudo scutil --set ComputerName $1
#  	      diskutil rename / $1
#    fi
# }

# execute "sudo systemsetup -setrestartfreeze on" \
#     "Restart automatically if the computer freezes"

killall "SystemUIServer" &> /dev/null
