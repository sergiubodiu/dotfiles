#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'Photos'

# Prevent Photos from auto-launching when connecting iPhone/iPad/camera/SD card
execute "defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true" \
    "Disable auto-open Photos on device connect (iPhone, SD card, etc.)"

# Optional: More aggressive — stop auto-import entirely (if you use other tools like osxphotos or manual import)
# execute "defaults write com.apple.Photos PKDisableAutoImport -bool true" \
#     "Disable automatic import from connected devices (test carefully)"

# Privacy: Disable sharing analytics / usage data with Apple from Photos
execute "defaults write com.apple.Photos allowSendingAnalysisData -bool false" \
    "Disable analytics & usage sharing from Photos app"

# Performance/UI: Limit background iCloud sync thrashing (helps on lower-storage Macs)
# Note: This is a common tweak; Tahoe still respects it
execute "defaults write com.apple.Photos PHPhotoLibraryShouldOptimizeOnBattery -bool true" \
    "Optimize iCloud storage when on battery (reduces background downloads)"

# Optional: Force dark mode appearance in Photos (if you prefer consistency)
execute "defaults write com.apple.Photos NSRequiresAquaSystemAppearance -bool false" \
    "Allow Photos to follow system dark/light mode (default in Tahoe)"

# Tahoe-specific: No direct plist keys for new features like Pinned Collections tile size or filter defaults yet
print_warning "New Tahoe features are GUI-only for now — customize in Photos > View / Sidebar"

# Apply changes — Photos needs relaunch or cfprefsd flush
killall "Photos" &> /dev/null || true