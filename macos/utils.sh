#!/bin/bash

. "$DOTFILES_DIR_PATH/utils.sh"

install_xcode() {

    if ! xcode-select --print-path &> /dev/null; then

        # Prompt user to install the XCode Command Line Tools
        xcode-select --install &> /dev/null

        # Wait until the XCode Command Line Tools are installed
        until xcode-select --print-path &> /dev/null; do
            sleep 5
        done

        print_result $? 'Install XCode Command Line Tools'

        # Point the `xcode-select` developer directory to
        # the appropriate directory from within `Xcode.app`
        # https://github.com/alrra/dotfiles/issues/13

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        print_result $? 'Make "xcode-select" developer directory point to Xcode'

        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10

        sudo xcodebuild -license accept &> /dev/null
        print_result $? 'Agree with the XCode Command Line Tools licence'

    fi

    print_result $? 'XCode Command Line Tools'

}

install_homebrew() {

    if ! cmd_exists 'brew'; then
        printf "\n" | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
        #  └─ simulate the ENTER keypress
    fi

    print_result $? 'Homebrew'

}

brew_install() {

    declare -r CMD="$4"
    declare -r FORMULA="$2"
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r TAP_VALUE="$3"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Homebrew` is installed

    if ! cmd_exists 'brew'; then
        print_error "$FORMULA_READABLE_NAME (\`brew\` is not installed)"
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If `brew tap` needs to be executed, check if it executed correctly

    if [ -n "$TAP_VALUE" ]; then
        if ! brew tap "$TAP_VALUE" &> /dev/null; then
            print_error "$FORMULA_READABLE_NAME (\`brew tap $TAP_VALUE\` failed)"
            return 1
        fi
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the specified formula

    if brew "$CMD" list "$FORMULA" &> /dev/null; then
        print_success "$FORMULA_READABLE_NAME"
    else
        execute "brew $CMD install $FORMULA" "$FORMULA_READABLE_NAME"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

opt_out_of_analytics() {

    # Opt-out of Homebrew's analytics.
    # https://github.com/Homebrew/brew/blob/0c95c60511cc4d85d28f66b58d51d85f8186d941/share/doc/homebrew/Analytics.md#opting-out

    if [ "$(git config --file="$(brew --repository)/.git/config" --get homebrew.analyticsdisabled)" != "true" ]; then
        git config --file="$(brew --repository)/.git/config" --replace-all homebrew.analyticsdisabled true &> /dev/null
    fi

    print_result $? "Homebrew (opt-out of analytics)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update_and_upgrade() {

    # System software update tool
    # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/softwareupdate.8.html

    execute 'sudo softwareupdate --install --all' 'Update system software'
    printf '\n'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

change_default_bash() {

    newShellPath="/usr/local/bin/bash" \

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Add the path of the `Bash` version installed through `Homebrew`
    # to the list of login shells from the `/etc/shells` file.
    #
    # This needs to be done because applications use this file to
    # determine whether a shell is valid (e.g.: `chsh` consults the
    # `/etc/shells` to determine whether an unprivileged user may
    # change the login shell for her own account).
    #
    # http://www.linuxfromscratch.org/blfs/view/7.4/postlfs/etcshells.html

    if ! grep "$newShellPath" < /etc/shells &> /dev/null; then
        execute \
            "printf '%s\n' '$newShellPath' | sudo tee -a /etc/shells" \
            "Bash (add '$newShellPath' in '/etc/shells')" \
        || return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set latest version of `Bash` as the default
    # (macOS uses by default an older version of `Bash`).

    chsh -s "$newShellPath" &> /dev/null
    print_result $? "Bash (use latest version)"

}

