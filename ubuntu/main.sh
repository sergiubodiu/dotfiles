#!/bin/bash

. "$HOME/.dotfiles/ubuntu/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update
upgrade

print_in_purple "\n   Build Essentials\n\n"

# Install tools for compiling/building software from source.
install_package "Build Essential" "build-essential"

# GnuPG archive keys of the Debian archive.
install_package "GnuPG archive keys" "debian-archive-keyring"

# Software which is not included by default
# in Ubuntu due to legal or copyright reasons.
#install_package "Ubuntu Restricted Extras" "ubuntu-restricted-extras"

install_package "Git" "git"

print_in_purple "\n   Compression Tools\n\n"

install_package "Brotli" "brotli"
install_package "Zopfli" "zopfli"

print_in_purple "\n   Miscellaneous\n\n"

install_package "GIMP" "gimp"
# install_package "ImageMagick" "imagemagick"
install_package "Transmission" "transmission"
install_package "VLC" "vlc"
install_package "cURL" "curl"
install_package "ShellCheck" "shellcheck"
install_package "xclip" "xclip"
install_package "tmux" "tmux"


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
if ! package_is_installed "yarn"; then

    add_key "https://packages.microsoft.com/keys/microsoft.asc" \
        || print_error "Microsoft (add key)"

    add_to_source_list "https://packages.microsoft.com/repos/vscode stable main" "vscode.list" \
        || print_error "Microsoft (add to package resource list)"

    update &> /dev/null \
        || print_error "Microsoft (resync package index files)"

    install_package "Code" "code"
fi

print_in_purple "\n   Cleanup\n\n"
autoremove
