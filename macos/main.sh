#!/bin/bash

export DOTFILES_DIR_PATH=$HOME/.dotfiles
. "$DOTFILES_DIR_PATH/install/utils.sh" || { echo "Failed to source utils.sh" >&2; exit 1; }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    _install_xcode

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    _install_homebrew

    execute "brew analytics off" "Homebrew (opt-out of analytics)"

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n   Installing/updating Homebrew taps, formulae and casks"
    brew bundle --verbose


    # brew_install "Podman" "podman"
    # brew_install "Kind" "kind"
    # brew_install "Gradle" "gradle"
    # brew_install "Maven" "maven"
    # brew 'worktrunk'
    # brew 'the_platinum_searcher'
    # brew 'telnet'
    # brew 'ollama'
    # brew 'chruby'
    # cask 'antigravity'
    # cask 'spotify'
    # cask 'slack'
    # cask 'orbstack'
    # cask 'orbstack'
    # cask 'discord'
    # cask 'docker'
    # cask 'codex'
    # cask 'chatgpt'
    # cask 'claude'
    # cask 'claude-code'
    # brew 'withgraphite/tap/graphite'
    # cask 'rectangle'
    # cask 'reflect'
    # brew 'postgresql@14', restart_service: true


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # brew_install "AWS" "awscli"
    # brew_install "CloudFoundry" "cf-cli" "cloudfoundry/tap"
    # brew_install "SpringBoot" "springboot" "pivotal/tap"
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists "brew"; then

        execute "brew cleanup" "brew (cleanup)"

    fi

}


_install_xcode() {

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

_install_homebrew() {

    if ! cmd_exists 'brew'; then
        printf "\n" | bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
        #  └─ simulate the ENTER keypress
    fi

    print_result $? 'Homebrew'

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

_update_and_upgrade() {

    # System software update tool
    # https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man8/softwareupdate.8.html

    execute 'sudo softwareupdate --install --all' 'Update system software'
    printf '\n'

}

main
