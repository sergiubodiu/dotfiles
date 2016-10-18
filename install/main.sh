#!/bin/bash

declare -r GITHUB_REPOSITORY='sergiubodiu/dotfiles'

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/utils.sh"

declare DOTFILES_DIR_PATH="$HOME/.dotfiles"

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

download() {

    local url="$1"
    local output="$2"

    if command -v 'curl' &> /dev/null; then

        curl -LsSo "$output" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show the progress meter
        #     └─ follow redirects

        return $?

    elif command -v 'wget' &> /dev/null; then

        wget -qO "$output" "$url" &> /dev/null
        #     │└─ write output to file
        #     └─ don't show output

        return $?
    fi

    return 1

}

download_dotfiles() {

    local tmpFile="$(mktemp /tmp/XXXXX)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? 'Download archive' 'true'
    printf '\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ask_for_confirmation "Do you want to store the dotfiles in '$DOTFILES_DIR_PATH'?"

    if ! answer_is_yes; then
        dotfilesDirectory=''
        while [ -z "$DOTFILES_DIR_PATH" ]; do
            ask 'Please specify another location for the dotfiles (path): '
            DOTFILES_DIR_PATH="$(get_answer)"
        done
    fi

    # Ensure the `dotfiles` directory is available

    while [ -e "$DOTFILES_DIR_PATH" ]; do
        ask_for_confirmation "'$DOTFILES_DIR_PATH' already exists, do you want to overwrite it?"
        if answer_is_yes; then
            rm -rf "$DOTFILES_DIR_PATH"
            break
        else
            dotfilesDirectory=''
            while [ -z "$DOTFILES_DIR_PATH" ]; do
                ask 'Please specify another location for the dotfiles (path): '
                DOTFILES_DIR_PATH="$(get_answer)"
            done
        fi
    done

    printf '\n'

    mkdir -p "$DOTFILES_DIR_PATH"
    print_result $? "Create '$DOTFILES_DIR_PATH'" 'true'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Extract archive in the `dotfiles` directory

    extract "$tmpFile" "$DOTFILES_DIR_PATH"
    print_result $? 'Extract archive' 'true'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Remove archive

    rm -rf "$tmpFile"
    print_result $? 'Remove archive'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$DOTFILES_DIR_PATH"

}

download_utils() {

    local tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_UTILS_URL" "$tmpFile" \
        && source "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

   return 1

}

extract() {

    local archive="$1"
    local outputDir="$2"

    if command -v 'tar' &> /dev/null; then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi

    return 1

}

initialize_git_repository() {

    declare -r GIT_ORIGIN="$1"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Please provide a URL for the Git origin"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory.

        cd $DOTFILES_DIR_PATH

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize the Git repository"

    fi

}

is_supported_version() {

    declare -a v1=(${1//./ })
    declare -a v2=(${2//./ })
    local i=''

    # Fill empty positions in v1 with zeros
    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done

    for (( i=0; i<${#v1[@]}; i++ )); do

        # Fill empty positions in v2 with zeros
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        fi

    done

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    # Ensure the OS is supported and
    # it's above the required version

    verify_os || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Ensure that the following actions
    # are made relative to this file's path
    #
    # http://mywiki.wooledge.org/BashFAQ/028

    cd "$DOTFILES_DIR_PATH"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Load utils

    if [ -x 'utils.sh' ]; then
        source 'utils.sh' || exit 1
    else
        download_utils || exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Setup the `dotfiles` if needed

    if ! cmd_exists 'git' \
        || [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then

        print_info 'Download and extract archive'
        download_dotfiles

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Create symbolic links'
    ./install/create_symbolic_links.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Install applications'

    ask_for_confirmation 'Do you want to install the applications/command line tools?'
    printf '\n'

    if answer_is_yes; then

        "./$(get_os)/main.sh"
        print_in_green '\n  ---\n\n'

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Set preferences'

    ask_for_confirmation 'Do you want to set the custom preferences?'
    printf '\n'

    if answer_is_yes; then
        ./$(get_os)/preferences/main.sh
    fi

    chsh -s $(which zsh)

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists 'git'; then

        if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
            print_info 'Initialize Git repository'
            initialize_git_repository "$DOTFILES_ORIGIN"

        fi

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists 'atom'; then

        print_info 'Install/Update Atom plugins'

        ask_for_confirmation 'Do you want to install/update the Atom plugins?'
        printf '\n'

        if answer_is_yes; then
            ./install/install_atom_plugins.sh
        fi

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_info 'Restart'

    ask_for_confirmation 'Do you want to restart?'
    printf '\n'

    if answer_is_yes; then
        sudo shutdown -r now &> /dev/null
    fi

}

main
