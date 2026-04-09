#!/usr/bin/env bash

set -euo pipefail  # exit on errors, undefined vars, pipe failures

export DOTFILES_DIR_PATH=$HOME/.dotfiles
PREFERENCES_DIR="${DOTFILES_DIR_PATH}/macos/preferences"
. "$DOTFILES_DIR_PATH/install/utils.sh" || { echo "Failed to source utils.sh" >&2; exit 1; }

cd "${PREFERENCES_DIR}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close any open `System Preferences` panes in order to
# avoid overriding the preferences that are being changed.

if [ -f "./close_system_preferences_panes.applescript" ]; then
    echo "→ Closing System Settings panes..."
    osascript ./close_system_preferences_panes.applescript || true
fi

# Now SOURCE the preference scripts (no ./ and no chmod +x needed)
for script in \
    app_store.sh \
    chrome.sh \
    dock.sh \
    finder.sh \
    keyboard.sh \
    photos.sh \
    safari.sh \
    siri.sh \
    terminal.sh \
    touchid-sudo.sh \
    trackpad.sh \
    ui_and_ux.sh
do
    if [ -f "./$script" ]; then
        echo "→ Sourcing $script..."
        . "./$script" || echo "  [WARN] $script had non-zero exit code" >&2
    else
        echo "  [SKIP] $script not found"
    fi
    echo ""
done

# Optional: final flush (helps many prefs stick)
killall cfprefsd Finder Dock SystemUIServer &> /dev/null || true

echo "Done! Log out/in or reboot for full effect (especially trackpad, keyboard repeat, Dock)."