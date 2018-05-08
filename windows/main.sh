#!/bin/bash

. "$HOME/.dotfiles/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  print_in_green '\n  ---\n\n'

  # install_pacman TBD
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pacman -S --quiet --noconfirm --force zsh \
    tmux autoconf make rsync whois \
    zip unzip bzip2 gzip \
    coreutils findutils colordiff tree

  print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists 'brew'; then

        execute 'brew cleanup' 'brew (cleanup)'
        execute 'brew cask cleanup' 'brew cask (cleanup)'

    fi
}

main
