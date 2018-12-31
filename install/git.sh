
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {

    printf "%s\n" \
        "Host github.com" \
        "  User $GITHUB_USER" \
        "  IdentityFile $1" >> ~/.ssh/config

    print_result $? "Add SSH configs"

}

copy_public_ssh_key_to_clipboard () {

    if cmd_exists "pbcopy"; then

        pbcopy < "$1"
        print_result $? "Copy public SSH key to clipboard"

    elif cmd_exists "xclip"; then

        xclip -selection clip < "$1"
        print_result $? "Copy public SSH key to clipboard"

    elif cmd_exists "clip"; then

        clip < "$1"
        print_result $? "Copy public SSH key to clipboard"

    else
        print_warning "Please copy the public SSH key ($1) to clipboard"
    fi

}

generate_ssh_keys() {

    ask "Please provide an email address: " && printf "\n"
    GITHUB_EMAIL = $(get_answer)
    ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL" -f "$1"

    print_result $? "Generate SSH keys"

    add_ssh_configs '~/.ssh/id_rsa'

    create_gitconfig_local GITHUB_EMAIL
}

create_gitconfig_local() {

    GITHUB_EMAIL = $1

    print_info 'Create local config files'

    local gitconfig="$HOME/.gitconfig.local"

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        printf "%s\n" \
"[commit]
    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/
    # gpgsign = true
[user]
    name = '$GITHUB_USER'
    email = $GITHUB_EMAIL
    # signingkey =
[credential]
    helper = manager
[http]
    sslVerify = false" \
        >> "$gitconfig"
    fi

    print_result $? "$FILE_PATH"

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

is_git_repository() {
    git rev-parse &> /dev/null
    return $?
}

initialize_git_repository() {

    print_info 'Set up GitHub SSH keys'

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory.

        cd $DOTFILES_DIR_PATH

        execute \
            "git init && git remote add origin $DOTFILES_ORIGIN" \
            "Initialize the Git repository"

    fi

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        generate_ssh_keys
        copy_public_ssh_key_to_clipboard "${GITHUB_SSH_KEY}.pub"
        open_github_ssh_page
        test_ssh_connection \
            && rm "${GITHUB_SSH_KEY}.pub"
    fi

    print_result $? "Set up GitHub SSH keys"

}
