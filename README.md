# [Sergiu](https://github.com/sbodiu-pivotal)’s dotfiles

These are the base dotfiles that I start with when I set up a
new environment.

Added __Oh My Zsh is a way of life!__

    git submodule add git://github.com/robbyrussell/oh-my-zsh.git



## Setup

ssh-keygen -t rsa -b 4096 -C "sergiu.bodiu@gmail.com"

TBD

Create local export configuration: .exports.local

    export DOTFILES_DIR_PATH='$HOME/.dotfiles'
    export OS='osx'
    # Important for omzsh theme
    export DEFAULT_USER='add name'

Create local git configuration: .gitconfig.local

    [user]
        name = 'add name'
        email = 'add name@email'
    [credential]
        helper = osxkeychain

Install nano (MacOS)
 
    brew install homebrew/dupes/nano

Install 
   * [Docker Toolbox](https://www.docker.com/products/docker-toolbox)
   * [Bosh](http://bosh.io)
        
Look for [Git Submodules](.gitmodules)

$ git submodule init
$ git submodule update

## Setup

To setup the dotfiles just run the appropriate snippet in the
terminal:

(:warning: **DO NOT** run the setup snippet if you don't fully
understand [what it does](setup.sh). Seriously, **DON'T**!)

| OS | Snippet |
|:---:|:---|
| OS X | `bash -c "$(curl -LsS https://raw.github.com/sergiubodiu/dotfiles/master/setup.sh)"` |
| Ubuntu | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/setup.sh)"` |

