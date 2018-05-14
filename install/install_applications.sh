#!/bin/bash

declare DOTFILES_DIR_PATH="$HOME/.dotfiles"
. "$DOTFILES_DIR_PATH/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    if test "$(which code)"; then
        
        # from `code --list-extensions`
        modules="
    k--kato.intellij-idea-keybindings
    jpogran.puppet-vscode
    CoenraadS.bracket-pair-colorizer
    EditorConfig.EditorConfig
    HookyQR.beautify
    PeterJausovec.vscode-docker
    be5invis.toml
    caarlos0.language-prometheus
    carolynvs.dep
    esbenp.prettier-vscode
    formulahendry.auto-close-tag
    formulahendry.auto-rename-tag
    foxundermoon.shell-format
    haaaad.ansible
    ipedrazas.kubernetes-snippets
    lukehoban.Go
    mauve.terraform
    ms-python.python
    octref.vetur
    patbenatar.advanced-new-file
    rebornix.Ruby
    rust-lang.rust
    sbrink.elm
    shanoor.vscode-nginx
    shinnn.alex
    teabyii.ayu
    timonwong.shellcheck
    "
        for module in $modules; do
            code --install-extension "$module" || true
        done
    fi

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    while :; do
        case $1 in
            -y|--yes) skipQuestions=true; break;;
                   *) break;;
        esac
        shift 1
    done

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$(uname -s)" = "Darwin" ]; then
        VSCODE_HOME="$HOME/Library/Application Support/Code"
    else
        VSCODE_HOME="$HOME/.config/Code"
    fi

    settings="
    settings.json
    snippets
    "

    for i in $settings; do
    
        sourceFile="$DOTFILES_DIR_PATH/vscode/$i"
        targetFile="$VSCODE_HOME/User/$i"

        if [ ! -e "$targetFile" ] || $skipQuestions; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [[ "$(readlink "$targetFile")" == "$sourceFile" ]]; then
            print_success "$targetFile → $sourceFile"
        else

            if ! $skipQuestions; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then

                    rm -rf "$targetFile"

                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"

                else
                    print_error "$targetFile → $sourceFile"
                fi

            fi

        fi
    done

}

print_in_purple "\n • Install Applications\n\n"
main "$@"
