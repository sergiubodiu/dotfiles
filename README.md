# [Sergiu](https://github.com/sergiubodiu)’s dotfiles

These are the base dotfiles that I start with when I set up a
new environment.

## Setup

ssh-keygen -t rsa -b 4096 -C "sergiu.bodiu@mailnator.com"

Create local export configuration: .exports.local

    export DOTFILES_DIR_PATH='/Users/add name/.dotfiles'
    # Important for omzsh theme
    export DEFAULT_USER='add name'

Create local git configuration: .gitconfig.local

    [user]
        name = 'add name'
        email = 'add name@email'

    ## Mac Only
    [credential]
        helper = osxkeychain

    ## Windows Only https://github.com/Microsoft/Git-Credential-Manager-for-Windows
    [core]
        editor = 'c:/workspace/scoop/shims/code' -w
        packedGitLimit = 128m
        packedGitWindowSize = 128m
    [credential]
        helper = manager

Look for [Git Submodules](.gitmodules)

    eval `ssh-agent -s`
    ssh-add ~/.ssh/*_rsa
    git submodule update --init --recursive

You can init and update the modules separetely

    git submodule init
    git submodule update

How to add & remove submodules

    git submodule add git://github.com/robbyrussell/oh-my-zsh.git

    git submodule deinit oh-my-zsh
    git rm oh-my-zsh

## Install

To install the dotfiles just run the appropriate snippet in the
terminal:

(:warning: **DO NOT** run the setup snippet if you don't fully
understand [what it does](main.sh). Seriously, **DON'T**!)

|   OS   | Snippet                                                                                      |
| :----: | :------------------------------------------------------------------------------------------- |
|  OS X  | `bash -c "$(curl -LsS https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"`  |
| Ubuntu | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |
| Cygwin | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |

curl -O rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin

Read about [SSH Hardening](https://medium.com/@jasonrigden/hardening-ssh-1bcb99cd4cef)

## Acknowledgements

Inspiration and code was taken from many sources, including:

- [Cătălin'](https://github.com/alrra)
  [dotfiles](https://github.com/alrra/dotfiles)
