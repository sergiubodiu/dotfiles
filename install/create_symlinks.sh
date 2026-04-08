#!/bin/bash

set -euo pipefail

export DOTFILES_DIR=$HOME/.dotfiles
. "$DOTFILES_DIR/install/utils.sh" || { echo "Failed to source utils.sh" >&2; exit 1; }

create_symlinks() {

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    local OS_NAME=$(get_os)
    local FILES_TO_SYMLINK=(
        # Shell
        "shell/aliases"
        "shell/bashrc"
        "shell/exports"
        "shell/functions"
        "shell/inputrc"
        "shell/minttyrc"
        "shell/zshrc"

        # OS-specific
        "shell/$OS_NAME/zprofile"
        "shell/$OS_NAME/nanorc"

        # Git
        "git/gitconfig"
        "git/gitignore"
        "git/gitattributes"
    )

    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$DOTFILES_DIR/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        symlink_file "$sourceFile" "$targetFile"

    done

    print_info "Setting up ~/.config applications..."

    CONFIG_DIR="$HOME/.config"
    # Alacritty (directory style - recommended)
    mkdir -p "$HOME/.config/alacritty"
    # Starship
    symlink_file "$DOTFILES_DIR/shell/starship.toml" "$HOME/.config/starship.toml"

    # Alacritty
    symlink_file "$DOTFILES_DIR/shell/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
}


symlink_file() {
    local sourceFile="$1"
    local targetFile="$2"

    if [[ "$OS_NAME" = "windows" ]] || [ ! -e "$targetFile" ] ; then

        execute \
            "ln -fs $sourceFile $targetFile" \
            "$targetFile → $sourceFile"

    elif [[ "$(readlink "$targetFile")" = "$sourceFile" ]]; then

        print_success "$targetFile → $sourceFile"

    else
        ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"

        if answer_is_yes; then
            rm -rf "$targetFile"

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"
        fi

    fi

}

 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_info 'Create symbolic links'
    create_symlinks "$@"
}

main "$@"
