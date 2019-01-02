#!/usr/bin/env bash

# This script installs sergiubodiu's dotfiles to a basic level under bash.
#
# Install:
#    `curl https://raw.githubusercontent.com/sergiubodiu/dotfiles/master/install/install.sh | bash`

set -Eeuo pipefail

declare -r GITHUB_USER='sergiubodiu'
declare -r GITHUB_REPOSITORY="$GITHUB_USER/dotfiles"

echo " usage: curl https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/install/install.sh | bash"

if [[ ! -e ~/.dotfiles ]]; then
    git clone -b master --recursive https://github.com/$GITHUB_REPOSITORY ~/.dotfiles
fi

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/utils.sh"
declare -r DOTFILES_DIR="$HOME/.dotfiles"
declare -r OS_NAME=get_os

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

get_os() {

    local osName="$(uname -s)"
    local os=''

    if [[ "$osName" == "Darwin" ]]; then
        os='macos'
    elif [[ "$osName" == "Linux" ]] && [ -e "/etc/lsb-release" ]; then
        os='ubuntu'
    elif [[ "$osName" == "MINGW64_NT-10.0" ]]; then
        os='windows'
    else
        os="$osName"
    fi

    printf "%s" "$os"

}

cmd_exists() {
    command -v "$1" &> /dev/null
    return $?
}

print_question() {
    printf "\e[0;33m  [?] $1\e[0m"
}

ask() {
    print_question "$1"
    read -r
}

get_answer() {
    printf "$REPLY"
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

restart() {
    print_info 'Restart'
    sudo shutdown -r now &> /dev/null
}

download() {

    local url="$1"
    local output="$2"

    if cmd_exists 'curl' ; then

        curl -LsSo "$output" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show the progress meter
        #     └─ follow redirects

        return $?

    elif cmd_exists 'wget'; then

        wget -qO "$output" "$url" &> /dev/null
        #     │└─ write output to file
        #     └─ don't show output

        return $?
    fi

    return 1

}

download_dotfiles() {

    print_info 'Download and extract archive'

    local tmpFile="$(mktemp /tmp/XXXXX)"
    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? 'Download archive' 'true'
    printf '\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ask_for_confirmation "Do you want to store the dotfiles in '$DOTFILES_DIR'?"

    # Ensure the `dotfiles` directory is available

    # while [ -e "$DOTFILES_DIR" ]; do
    #     ask_for_confirmation "'$DOTFILES_DIR' already exists, do you want to overwrite it?"
    #     if answer_is_yes; then
    #         rm -rf "$DOTFILES_DIR"
    #         break
    #     else
    #         dotfilesDirectory=''
    #         while [ -z "$DOTFILES_DIR" ]; do
    #             ask 'Please specify another location for the dotfiles (path): '
    #             DOTFILES_DIR="$(get_answer)"
    #         done
    #     fi
    # done

    # Extract archive in the `dotfiles` directory
    mkd "$DOTFILES_DIR" && extract "$tmpFile" "$DOTFILES_DIR" \
    && rm -rf "$tmpFile" \
    && return 0

    return 1
}

download_utils() {

    local tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_UTILS_URL" "$tmpFile" \
        && . "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

   return 1

}

extract() {

    local archive="$1"
    local outputDir="$2"

    if cmd_exists 'tar'; then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi

    return 1

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_symbolic_links() {

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    print_info 'Create symbolic links'

    FILES_TO_SYMLINK=(
        "shell/aliases"
        "shell/bashrc"
        "shell/$OS_NAME/bash_profile"
        "shell/$OS_NAME/nanorc"
        "shell/exports"
        "shell/functions"
        "shell/inputrc"
        "shell/minttyrc"
        "shell/zshrc"

        "git/gitconfig"
        "git/gitignore"
    )

    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$(pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ ! -e "$targetFile" ] ; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [[ "$(readlink "$targetFile")" == "$sourceFile" ]]; then

            print_success "$targetFile → $sourceFile"

        else

            overrite_symbolik_link $sourceFile $targetFile

        fi

    done

}

overrite_symbolik_link() {

    local sourceFile=$1
    local targetFile=$2

    ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
    if answer_is_yes; then

        rm -rf "$targetFile"

        execute \
            "ln -fs $sourceFile $targetFile" \
            "$targetFile → $sourceFile"

    else
        print_error "$targetFile → $sourceFile"
    fi
 }

ask_for_sudo() {

    # Ask for the administrator password upfront
    sudo -v &> /dev/null

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    download_utils

    # Load utils
    if [ -x "$DOTFILES_DIR/utils.sh" ]; then
        . "$DOTFILES_DIR/utils.sh" || exit 1
    else
        download_utils || exit 1
    fi

    ask_for_sudo

    download_dotfiles || exit 1

    create_symbolic_links

    printf "%s\n\n" "#!/bin/sh" >> "$HOME/.exports.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Install applications'

    ask_for_confirmation 'Do you want to install the applications/command line tools?'
    printf '\n'

    if answer_is_yes; then
        "./$OS_NAME/main.sh"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Set preferences'

    ask_for_confirmation 'Do you want to set the custom preferences?'
    printf '\n'

    if answer_is_yes; then
        "./$OS_NAME/preferences/main.sh"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_ide

    if cmd_exists 'git'; then

        if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
            print_info 'Initialize Git repository'
            ## initialize_git_repository

        fi

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ask_for_confirmation 'Do you want to restart?'
    printf '\n'

    if answer_is_yes; then
       restart
    fi

}

main
