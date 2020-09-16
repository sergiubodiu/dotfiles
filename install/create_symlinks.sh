#!/bin/bash

cd "${DOTFILES_DIR_PATH}" \
 && . "${DOTFILES_DIR_PATH}/utils.sh"

create_symlinks() {

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    local OS_NAME=$(get_os)
    local FILES_TO_SYMLINK=(
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
        "git/gitattributes"
    )

    local WORKDIR=$(pwd)
    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$WORKDIR/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if OS_NAME=="windows" || [ ! -e "$targetFile" ] ; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [[ "$(readlink "$targetFile")" == "$sourceFile" ]]; then

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

    done

}

 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_info 'Create symbolic links'
    create_symlinks "$@"
}

main "$@"
