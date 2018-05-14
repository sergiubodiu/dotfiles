#!/bin/bash

declare DOTFILES_DIR_PATH="$HOME/.dotfiles"
. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r SDKMAN_DIRECTORY="$HOME/.sdkman"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install `sdkman` See below URLs for more information
    # - http://sdkman.io/install.html
    # - https://get.sdkman.io/

    execute \
        "curl -s 'https://get.sdkman.io' | bash" \
        "sdkman (install)" || return 1

    # NOTE: The init script is what adds the SDKs/candidiates to PATH (doesn't export)
    # sdkman-init.sh -> __sdkman_prepend_candidate_to_path -> sdkman-path-helpers.sh
    execute \
        ". $SDKMAN_DIRECTORY/bin/sdkman-init.sh" \
        "sdkman (. ~/.sdkman/bin/sdkman-init.sh)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Temporarily configure sdkman to non-interactive mode so that we can install sdk's/candidiates via scripts
    # See http://sdkman.io/usage.html#config

    execute \
        "sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $SDKMAN_DIRECTORY/etc/config" \
        "sdkman (set non-interactive mode)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Ensure the latest version of `sdkman` is used
    # See http://api.sdkman.io/selfupdate

    execute \
        "sdk selfupdate" \
        "sdkman (upgrade)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install SDKs/candidiates: maven, gradle
    # For a list of candidiates, either:
    # - http://api.sdkman.io/candidates
    # - type `sdk list` in terminal prompt
    # NOTE: The install script also adds the SDKs/candidiates to PATH (doesn't export)
    # sdkman-install.sh -> __sdkman_add_to_path -> sdkman-path-helpers.sh

    execute \
        "sdk install gradle \
         && sdk install maven" \
        "sdkman (install SDKs: gradle, maven)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Configure sdkman to the default interactive mode
    # See http://sdkman.io/usage.html#config

    execute \
        "sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' $SDKMAN_DIRECTORY/etc/config" \
        "sdkman (set interactive mode)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_green "\n  ---\n\n"

}

main