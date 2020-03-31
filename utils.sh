#!/bin/bash

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

cmd_exists() {
    command -v "$1" &> /dev/null
    return $?
}

print_question() {
    printf "\e[0;33m  [?] $1\e[0m"
}

get_answer() {
    printf "$REPLY"
}

execute() {
    eval "$1" &> /dev/null
    print_result $? "${2:-$1}"
}
# http://0pointer.de/blog/projects/os-release
# One of the new configuration files systemd introduced is /etc/os-release.
get_os() {

    local os=""
    local osName="$(uname -s)"

    if [ "$osName" == "Darwin" ]; then
        os='macos'
    elif [ "$osName" == "Linux" ] && \
         [ -e "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"
    elif [ "$osName" == "MINGW64_NT-10.0" ]; then
        os='windows'
    else
        os="$osName"
    fi

    printf "%s" "$os"

}

print_in_green() {
    printf "\e[0;32m$1\e[0m"
}

print_in_purple() {
    printf "\e[0;35m$1\e[0m"
}

print_in_red() {
    printf "\e[0;31m$1\e[0m"
}

print_in_yellow() {
    printf "\e[0;33m$1\e[0m"
}

print_info() {
    print_in_purple "\n $1\n\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    return $1
}

print_success() {
    print_in_green "  [✔] $1\n"
}

print_error() {
    print_in_red "  [✖] $1 $2\n"
}

print_warning() {
    print_in_yellow "  [!] $1\n"
}
