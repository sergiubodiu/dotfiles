#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_info 'Configuring Touch ID for sudo...'

# Check if Touch ID hardware is available
if ! bioutil -r -s > /dev/null 2>&1; then
    print_warning "Touch ID hardware not available, skipping setup"
    return 0
fi

# Modern macOS (Sonoma 14.0+) uses /etc/pam.d/sudo_local which persists across updates
# Older macOS versions require modifying /etc/pam.d/sudo directly
PAM_TID_LINE="auth       sufficient     pam_tid.so"

if [[ -f /etc/pam.d/sudo_local ]]; then
    # Modern approach - use sudo_local (persists across OS updates)
    if ! grep -q "pam_tid.so" /etc/pam.d/sudo_local 2>/dev/null; then
        echo "$PAM_TID_LINE" | sudo tee /etc/pam.d/sudo_local > /dev/null
        print_success "Touch ID enabled for sudo (will persist across updates)"
    else
        print_success "Touch ID already enabled via /etc/pam.d/sudo_local"
    fi
else
    # Legacy approach - modify /etc/pam.d/sudo directly
    if ! grep -q "pam_tid.so" /etc/pam.d/sudo 2>/dev/null; then
        # Create a backup
        sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.backup
        # Add pam_tid.so as the first auth line
        sudo sed -i '' '1a\
'"$PAM_TID_LINE"'
' /etc/pam.d/sudo
        print_success "Touch ID enabled for sudo"
        print_warning "Note: This may be reset by macOS updates. Consider upgrading to macOS Sonoma or later."
    else
        print_success "Touch ID already enabled via /etc/pam.d/sudo"
    fi
fi
