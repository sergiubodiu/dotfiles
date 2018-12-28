#!/bin/bash

declare GITHUB_REPOSITORY='sergiubodiu/dotfiles'
declare GITHUB_SSH_KEY="$HOME/.ssh/github"

declare DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"
declare DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/utils.sh"
declare DOTFILES_DIR_PATH="$HOME/.dotfiles"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_gitconfig_local() {

    print_info 'Create local config files'

    declare FILE_PATH="$HOME/.gitconfig.local"

    printf "%s\n\n" "#!/bin/bash" >> "$HOME/.exports.local

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        printf "%s\n" \
"[commit]
    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/
    # gpgsign = true
[user]
    name =
    email =
    # signingkey =" \
        >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

add_ssh_configs() {

    printf "%s\n" \
        "Host github.com" \
        "  IdentityFile $1" \
        "  LogLevel ERROR" >> ~/.ssh/config

    print_result $? "Add SSH configs"

}

copy_public_ssh_key_to_clipboard () {

    if cmd_exists "pbcopy"; then

        pbcopy < "$1"
        print_result $? "Copy public SSH key to clipboard"

    elif cmd_exists "xclip"; then

        xclip -selection clip < "$1"
        print_result $? "Copy public SSH key to clipboard"

    else
        print_warning "Please copy the public SSH key ($1) to clipboard"
    fi

}

generate_ssh_keys() {

    ask "Please provide an email address: " && printf "\n"
    ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

    print_result $? "Generate SSH keys"

}

open_github_ssh_page() {

    local githubPage="https://github.com/settings/ssh"

    # The order of the following checks matters
    # as on Ubuntu there is also a utility called `open`.

    if cmd_exists "xdg-open"; then
        xdg-open "$githubPage"
    elif cmd_exists "open"; then
        open "$githubPage"
    else
        print_warning "Please add the public SSH key to GitHub ($githubPage)"
    fi

}

test_ssh_connection() {

    while true; do

        ssh -T git@github.com &> /dev/null
        [ $? -eq 1 ] && break

        sleep 5

    done

}


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

    print_info 'Download and extract archive'

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
        && . "$tmpFile" \
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

    declare GIT_ORIGIN="$1"

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Please provide a URL for the Git origin"
        exit 1
    fi

    print_in_purple "\n • Set up GitHub SSH keys\n\n"

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory.

        cd $DOTFILES_DIR_PATH

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize the Git repository"

    fi

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        generate_ssh_keys
        add_ssh_configs
        copy_public_ssh_key_to_clipboard "${GITHUB_SSH_KEY}.pub"
        open_github_ssh_page
        test_ssh_connection \
            && rm "${GITHUB_SSH_KEY}.pub"
    fi

    print_result $? "Set up GitHub SSH keys"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_symbolic_links() {

    local i=""
    local sourceFile=""
    local targetFile=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    print_info 'Create symbolic links'

    FILES_TO_SYMLINK=(
        "shell/aliases"
        "shell/bashrc"
        "shell/$(get_os)/bash_profile"
        "shell/$(get_os)/nanorc"
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

 overrite_symbolik_link {

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

install_ide() {

    local i=""
    local sourceFile=""
    local targetFile=""
    local settings="settings.json snippets"

    if test "$(which code)"; then

        # from `code --list-extensions`
        modules="
    esbenp.prettier-vscode
    ms-kubernetes-tools.vscode-kubernetes-tools
    ms-python.python
    "
        for module in $modules; do
            code --install-extension "$module" || true
        done
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$(uname -s)" = "Darwin" ]; then
        VSCODE_HOME="$HOME/Library/Application Support/Code"
    else
        VSCODE_HOME="$HOME/.config/Code"
    fi


    for i in $settings; do

        sourceFile="$DOTFILES_DIR_PATH/vscode/$i"
        targetFile="$VSCODE_HOME/User/$i"

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

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    # Ensure the OS is supported and
    # it's above the required version

    # Ensure that the following actions
    # are made relative to this file's path
    #
    # http://mywiki.wooledge.org/BashFAQ/028
    mkdir -p "$DOTFILES_DIR_PATH"
    cd "$DOTFILES_DIR_PATH"

    # Load utils

    if [ -x 'utils.sh' ]; then
        . 'utils.sh' || exit 1
    else
        download_utils || exit 1
    fi

    ask_for_sudo

    download_dotfiles

    create_symbolic_links

    create_gitconfig_local

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

    install_ide

    if cmd_exists 'git'; then

        if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
            print_info 'Initialize Git repository'
            initialize_git_repository "$DOTFILES_ORIGIN"

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
