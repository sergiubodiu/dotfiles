#!/bin/bash

. "$DOTFILES_DIR_PATH/macos/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main() {

    # install_xcode

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_homebrew

    opt_out_of_analytics

    brew_install 'Homebrew Cask' 'caskroom/cask/brew-cask' 'caskroom/cask'

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install 'Bash' 'bash'

    change_default_bash

    print_in_green '\n  ---\n\n'

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_install 'Alfred' 'alfred' 'caskroom/cask' 'cask'
    #brew_install 'F.lux' 'flux' 'caskroom/cask' 'cask'
    brew_install 'Docker' 'docker' 'caskroom/cask' 'cask'
    brew_install 'Intellij' 'intellij-idea-ce' 'caskroom/cask' 'cask'
    brew_install 'Oracle JDK' 'java' 'caskroom/cask' 'cask'
    brew_install 'LICEcap' 'licecap' 'caskroom/cask' 'cask'
    brew_install 'Opera' 'opera' 'caskroom/cask' 'cask'
    brew_install 'VirtualBox' 'virtualbox' 'caskroom/cask' 'cask'

    brew_install 'Git' 'git'
    brew_install 'Gradle' 'gradle'
    brew_install 'Maven' 'maven'
    brew_install 'tmux' 'tmux'
    brew_install 'Tree' 'tree'
    brew_install 'watch' 'watch'

    # brew_install 'Skype' 'skype' 'caskroom/cask' 'cask'
    # brew_install 'Chrome' 'google-chrome' 'caskroom/cask' 'cask'
    # brew_install 'Transmission' 'transmission' 'caskroom/cask' 'cask'


    # brew_install 'VLC' 'vlc' 'caskroom/cask' 'cask'
    # brew_install 'ImageAlpha' 'imagealpha' 'caskroom/cask' 'cask'
    # brew_install 'ImageMagick' 'imagemagick --with-webp'
    # brew_install 'ImageOptim' 'imageoptim' 'caskroom/cask' 'cask'
    # brew_install 'TTF/OTF → WOFF (Zopfli)' 'sfnt2woff-zopfli' 'bramstein/webfonttools'
    # brew_install 'TTF/OTF → WOFF' 'sfnt2woff' 'bramstein/webfonttools'
    # brew_install 'Unarchiver' 'the-unarchiver' 'caskroom/cask' 'cask'
    # brew_install 'WOFF2' 'woff2' 'bramstein/webfonttools'
    # brew_install 'Zopfli' 'zopfli'
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#    brew_install 'AWS' 'awscli'
#    brew_install 'Android File Transfer' 'android-file-transfer' 'caskroom/cask' 'cask'   
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
