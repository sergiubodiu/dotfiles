# [Sergiu](https://github.com/sergiubodiu)’s dotfiles

These are the base dotfiles that I start with when I set up a
new environment.

Added __Oh My Zsh is a way of life!__

    git submodule add git://github.com/robbyrussell/oh-my-zsh.git

## Setup

ssh-keygen -t rsa -b 4096 -C "sergiu.bodiu@gmail.com"

TBD

Create local export configuration: .exports.local

    export DOTFILES_DIR_PATH='/Users/add name/.dotfiles'
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

The first step is to install the [Spring Cloud CLI](https://github.com/spring-cloud/spring-cloud-cli)̨

    spring install org.springframework.cloud:spring-cloud-cli:1.2.1.RELEASE
    spring help cloud

Look for [Git Submodules](.gitmodules)

$ git submodule init
$ git submodule update

## Install

To install the dotfiles just run the appropriate snippet in the
terminal:

(:warning: **DO NOT** run the setup snippet if you don't fully
understand [what it does](main.sh). Seriously, **DON'T**!)

| OS | Snippet |
|:---:|:---|
| OS X | `bash -c "$(curl -LsS https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |
| Ubuntu | `bash -c "$(wget -qO - https://raw.github.com/sergiubodiu/dotfiles/master/install/main.sh)"` |

## Acknowledgements

Inspiration and code was taken from many sources, including:

* [Cătălin'](https://github.com/alrra)
  [dotfiles](https://github.com/alrra/dotfiles)
