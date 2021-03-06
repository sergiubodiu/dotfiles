#!/bin/bash

. "$DOTFILES_DIR_PATH/macos/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main() {

    # install_xcode

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_homebrew

    opt_out_of_analytics

    brew_install "Homebrew Cask" "homebrew/cask/brew-cask" "homebrew/cask"

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install "Bash" "bash"

    change_default_bash

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install "Android File Transfer" "android-file-transfer" "homebrew/cask" "cask"
    brew_install "Firefox" "firefox" "homebrew/cask" "cask"
    brew_install "F.lux" "flux" "homebrew/cask" "cask"
    brew_install "ImageOptim" "imageoptim" "homebrew/cask" "cask"
    brew_install "ImageMagick" "imagemagick"
    brew_install "LICEcap" "licecap" "homebrew/cask" "cask"
    brew_install "Open JDK" "adoptopenjdk" "homebrew/cask" "cask"
    brew_install "Rectangle" "rectangle" "homebrew/cask" "cask"
    brew_install "Unarchiver" "the-unarchiver" "homebrew/cask" "cask"
    brew_install "Vivaldi" "vivaldi" "homebrew/cask" "cask"
    brew_install "VLC" "vlc" "homebrew/cask" "cask"

    print_in_purple "\n   Compression Tools\n\n"
    brew_install "Brotli" "brotli"
    brew_install "Zopfli" "zopfli"

    print_in_purple "\n   Git\n\n"
    brew_install "Git" "git"
    brew_install "GitHub CLI" "gh"
    brew_install "GPG" "gpg"
    
    brew_install "Podman" "podman"
    brew_install "Kind" "kind"
    brew_install "Gradle" "gradle"
    brew_install "Maven" "maven"
    brew_install "tmux" "tmux"
    brew_install "Tree" "tree"
    brew_install "watch" "watch"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # brew_install "AWS" "awscli"
    # brew_install "CloudFoundry" "cf-cli" "cloudfoundry/tap"
    # brew_install "SpringBoot" "springboot" "pivotal/tap"
    # print_in_purple "\n   Web Font Tools\n\n"
    # brew_install "Web Font Tools: TTF/OTF → WOFF (Zopfli)" "sfnt2woff-zopfli" "bramstein/webfonttools"
    # brew_install "Web Font Tools: TTF/OTF → WOFF" "sfnt2woff" "bramstein/webfonttools"
    # brew_install "Web Font Tools: WOFF2" "woff2" "bramstein/webfonttools"
    # brew install "chruby" "chruby"
    # brew_install "ruby-install" "ruby-install"
    # brew_install "ShellCheck" "shellcheck"
    # brew_install "Chrome" "google-chrome" "homebrew/cask" "cask"
    # brew_install "Skype" "skype" "homebrew/cask" "cask"
    # brew_install "Transmission" "transmission" "homebrew/cask" "cask"
    # brew_install "VirtualBox" "virtualbox" "homebrew/cask" "cask"

    print_in_green "\n  ---\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists "brew"; then

        execute "brew cleanup" "brew (cleanup)"

    fi

}

main
