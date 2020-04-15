#!/bin/bash

. "$DOTFILES_DIR_PATH/macos/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main() {

    # install_xcode

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_homebrew

    opt_out_of_analytics

    brew_install 'Homebrew Cask' 'homebrew/cask/brew-cask' 'homebrew/cask'

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install 'Bash' 'bash'

    change_default_bash

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install 'Alfred' 'alfred' 'homebrew/cask' 'cask'
    #brew_install 'F.lux' 'flux' 'homebrew/cask' 'cask'
    brew_install 'Docker' 'docker' 'homebrew/cask' 'cask'
    brew_install 'Intellij' 'intellij-idea-ce' 'homebrew/cask' 'cask'
    brew_install 'LICEcap' 'licecap' 'homebrew/cask' 'cask'
    brew_install 'Opera' 'opera' 'homebrew/cask' 'cask'    
    brew_install 'Oracle JDK' 'java' 'homebrew/cask' 'cask'
    brew_install 'Unarchiver' 'the-unarchiver' 'homebrew/cask' 'cask'
    brew_install 'VirtualBox' 'virtualbox' 'homebrew/cask' 'cask'
    brew_install 'Visual Studio Code' 'visual-studio-code' 'homebrew/cask' 'cask'

    brew_install 'Git' 'git'
    brew_install 'Gradle' 'gradle'
    brew_install 'Maven' 'maven'
    brew_install 'ShellCheck' 'shellcheck'
    brew_install 'tmux' 'tmux'
    brew_install 'Tree' 'tree'
    brew_install 'watch' 'watch'

    # brew_install 'Skype' 'skype' 'homebrew/cask' 'cask'
    # brew_install 'Chrome' 'google-chrome' 'homebrew/cask' 'cask'
    # brew_install 'Transmission' 'transmission' 'homebrew/cask' 'cask'
    

    # brew_install 'VLC' 'vlc' 'homebrew/cask' 'cask'
    # brew_install 'ImageAlpha' 'imagealpha' 'homebrew/cask' 'cask'
    # brew_install 'ImageMagick' 'imagemagick'
    # brew_install 'ImageOptim' 'imageoptim' 'homebrew/cask' 'cask'
    # brew_install 'TTF/OTF → WOFF (Zopfli)' 'sfnt2woff-zopfli' 'bramstein/webfonttools'
    # brew_install 'TTF/OTF → WOFF' 'sfnt2woff' 'bramstein/webfonttools'
    # brew_install 'Unarchiver' 'the-unarchiver' 'homebrew/cask' 'cask'
    # brew_install 'WOFF2' 'woff2' 'bramstein/webfonttools'
    # brew_install 'Zopfli' 'zopfli'
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#    brew_install 'AWS' 'awscli'
#    brew_install 'Android File Transfer' 'android-file-transfer' 'homebrew/cask' 'cask'   
#    brew_install 'CloudFoundry' 'cf-cli' 'cloudfoundry/tap'
#    brew_install 'SpringBoot' 'springboot' 'pivotal/tap'
#    brew install 'chruby' 'chruby'
#    brew_install 'ruby-install' 'ruby-install'
    
    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists 'brew'; then

        execute 'brew cleanup' 'brew (cleanup)'
        execute 'brew cask cleanup' 'brew cask (cleanup)'

    fi

}

main
