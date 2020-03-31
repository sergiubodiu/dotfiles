#!/bin/bash

. "$HOME/.dotfiles/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_key() {

    wget -qO - "$1" | sudo apt-key add - &> /dev/null
    #     │└─ write output to file
    #     └─ don't show output

}

add_to_source_list() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'"
}

install_package() {

    declare EXTRA_ARGUMENTS="$3"
    declare PACKAGE="$2"
    declare PACKAGE_READABLE_NAME="$1"

    if ! package_is_installed "$PACKAGE"; then
        execute "sudo apt-get install --allow-unauthenticated -qqy $EXTRA_ARGUMENTS $PACKAGE" "$PACKAGE_READABLE_NAME"
        #                                      suppress output ─┘│
        #            assume "yes" as the answer to all prompts ──┘
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi

}

package_is_installed() {
    dpkg -s "$1" &> /dev/null
}

update() {

    # Resynchronize the package index files from their sources.

    execute \
        "sudo apt-get update -qqy" \
        "APT (update)"

}

upgrade() {

    # Install the newest versions of all packages installed.

    execute \
        "export DEBIAN_FRONTEND=\"noninteractive\" \
            && sudo apt-get -o Dpkg::Options::=\"--force-confnew\" upgrade -qqy" "APT (upgrade)"

}

if [ -d "$HOME/.nvm" ]; then

    if ! package_is_installed "yarn"; then

        add_key "https://dl.yarnpkg.com/debian/pubkey.gpg" \
            || print_error "Yarn (add key)"

        add_to_source_list "https://dl.yarnpkg.com/debian/ stable main" "yarn.list" \
            || print_error "Yarn (add to package resource list)"

        update &> /dev/null \
            || print_error "Yarn (resync package index files)"

    fi

    install_package "Yarn" "yarn" "--no-install-recommends"
fi


# https://code.visualstudio.com/docs/setup/linux
if ! package_is_installed "code"; then

    add_key "https://packages.microsoft.com/keys/microsoft.asc" \
        || print_error "Microsoft (add key)"

    add_to_source_list "https://packages.microsoft.com/repos/vscode stable main" "vscode.list" \
        || print_error "Microsoft (add to package resource list)"

    update &> /dev/null \
        || print_error "Microsoft (resync package index files)"

    install_package "Code" "code"
fi

update
upgrade

print_in_purple "\n   Build Essentials\n\n"

# Install tools for compiling/building software from source.
install_package "Build Essential" "build-essential"

# GnuPG archive keys of the Debian archive.
install_package "GnuPG archive keys" "debian-archive-keyring"

# Software which is not included by default
# in Ubuntu due to legal or copyright reasons.
install_package "Ubuntu Restricted Extras" "ubuntu-restricted-extras"

print_in_purple "\n   Miscellaneous\n\n"

sudo apt install -qqy curl git brotli pylint3 shellcheck tmux xclip zopfli

print_in_purple "\n   Cleanup\n\n"

# Remove packages that were automatically installed to satisfy
# dependencies for other packages and are no longer needed.
execute "sudo apt-get autoremove -qqy" "APT (autoremove)"
