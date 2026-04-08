
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {
    local key_path="$1"
    local ssh_config="$HOME/.ssh/config"

    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    [[ ! -f "$ssh_config" ]] && touch "$ssh_config" && chmod 600 "$ssh_config"

    # Check if github.com block already exists
    if grep -q "^Host github.com" "$ssh_config" 2>/dev/null; then
        print_warning "GitHub host block already exists in ~/.ssh/config"
        ask_for_confirmation "Do you want to update it with the new key?"
        if ! answer_is_yes; then
            return 0
        fi
        # Remove old github.com block
        sed -i '' '/^Host github.com/,/^$/d' "$ssh_config" 2>/dev/null || true
    fi
    printf "%s\n" \
        "Host github.com" \
        "  User $GITHUB_USER" \
        "  IdentityFile $key_path" \
        "  IdentitiesOnly yes" \
        "  ServerAliveInterval 60" \
        "  LogLevel ERROR" >> $ssh_config

    print_result $? "Add SSH configs"

    chmod 600 "$ssh_config"
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
    local key_path="$HOME/.ssh/id_ed25519"
    local pub_key="${key_path}.pub"

    # Get email and name
    if [[ -z "$GITHUB_EMAIL" ]]; then
        ask "Please provide an email address: " && printf "\n"
        GITHUB_EMAIL=$(get_answer)
    else
        print_success "Using email: $GITHUB_EMAIL"
    fi

    if [[ -z "$GITHUB_USER" ]]; then
        ask "Please provide your name: " && printf "\n"
        GITHUB_USER=$(get_answer)
    else
        print_success "Using name: $GITHUB_USER"
    fi

    local generate_new_key=true

    if [[ -f "$key_path" ]]; then
        print_warning "ed25519 key already exists at $key_path"
        ask_for_confirmation "Do you want to generate a NEW key? (This will overwrite the old one)"
        if ! answer_is_yes; then
            print_info "Skipping key generation. Using existing key."
            generate_new_key=false
        fi
    fi

    if [[ "$generate_new_key" == true ]]; then
        ssh-keygen -t ed25519 -a 100 -f "$key_path" -C "$GITHUB_EMAIL"
        print_result $? "Generate SSH keys"

        # Add to ssh-agent (macOS Keychain)
        eval "$(ssh-agent -s)" &>/dev/null
        if ssh-add --apple-use-keychain "$key_path" &>/dev/null; then
            print_success "Key added to macOS Keychain"
        else
            ssh-add "$key_path" &>/dev/null && print_success "Key added to ssh-agent"
        fi
    fi

    # Always continue with the rest of the setup
    create_gitconfig_local "$GITHUB_USER" "$GITHUB_EMAIL"
    add_github_to_ssh_config "$key_path"

    print_info "\nYour public SSH key:"
    print_in_green "$(cat "$pub_key")"

    ask_for_confirmation "\nWould you like to open the GitHub SSH keys page now?"
    if answer_is_yes; then
        open_github_ssh_page "$pub_key"
    fi

    ask_for_confirmation "\nWould you like to test the SSH connection now?"
    if answer_is_yes; then
        test_ssh_connection
    else
        print_info "You can test later by running: ssh -T git@github.com"
    fi
}

open_github_ssh_page() {
    local github_page="https://github.com/settings/keys"
    local pub_key_path="${1:-$HOME/.ssh/id_ed25519.pub}"

    print_info "Opening GitHub SSH keys page..."

    copy_public_ssh_key_to_clipboard "$pub_key_path"

    if cmd_exists "open"; then
        open "$github_page"
        print_success "GitHub SSH keys page opened in browser"
    elif cmd_exists "xdg-open"; then
        xdg-open "$github_page"
        print_success "GitHub SSH keys page opened in browser"
    else
        print_warning "Please visit manually:"
        print_in_green "$github_page"
    fi
}

create_gitconfig_local() {
    local github_user=$1
    local github_email=$2

    local gitconfig="$HOME/.gitconfig.local"

    print_info 'Create local config files'

    # Create the file with template if it doesn't exist
    if [[ ! -f "$gitconfig" ]]; then
        printf "%s\n" \
        "[commit]
            # Sign commits using GPG.
            # https://help.github.com/articles/signing-commits-using-gpg/
            # gpgsign = true
        [user]
            name = '${github_user}'
            email = '${github_email}'
            # signingkey =
        [credential]
            helper = manager
        [http]
            sslVerify = false" \
            >> "${gitconfig}"
        print_success "Created new ${gitconfig} with template"
    fi

    # Automatically include this file in main ~/.gitconfig (only once)
    if ! git config --global --get-regexp include.path | grep -q "\.gitconfig\.local" 2>/dev/null; then
        git config --global --add include.path "~/.gitconfig.local"
        print_success "Added include.path for ~/.gitconfig.local"
    fi

    print_success "Git local config updated → $gitconfig_local"
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
    local git_repository="${1:-$HOME/.dotfiles}"
    local git_remote="${2:-git@github.com:$GITHUB_USER/dotfiles.git}"
    print_info 'Set up GitHub SSH keys'

    if ! is_git_repository; then

        cd $git_repository

        execute \
            "git init && git remote add origin $git_remote" \
            "Initialize the Git repository"

    fi

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        generate_ssh_keys
        open_github_ssh_page
        test_ssh_connection
    fi

    print_result $? "Set up GitHub SSH keys"

}
