#requires -v 3

# This script installs sergiubodiu's dotfiles to a basic level under Powershell on Windows.
#
# Install:
#
#    iwr https://raw.githubusercontent.com/sergiubodiu/dotfiles/master/install/install.ps1 -useb | iex

$erroractionpreference = 'stop'

if (!(test-path ~/dotfiles)) {

    if ((get-executionpolicy) -gt 'remotesigned') {
        set-executionpolicy remotesigned process -force
    }

    if (!(get-command scoop -ea si)) {
        iwr https://get.scoop.sh -useb | iex
    }

    scoop install 7zip busybox clink conemu curl freecommander git-with-openssh nano
    scoop install chromium cygwin go gradle graphviz jq kotlin nginx plantuml squirrel-sql vscode

    git clone -b master --recursive --jobs 3 https://github.com/sergiubodiu/dotfiles "$(resolve-path ~)/.dotfiles"
}
