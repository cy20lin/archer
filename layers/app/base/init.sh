#!/usr/bin/bash
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
##

join_by() {
    local d=$1
    shift
    echo -n "$1"
    shift
    printf "%s" "${@/#/$d}"
}

install_packages() {
    echo " -- install packages"
    local mingw_packages=()
    local msys_packages=(
        base
        # diffutils, patch
        # make, automake
        base-devel
        git svn
        # rsync, openssh, lftp
        net-utils
        # archive
        atool
        tar gzip bzip2 xz
        p7zip zip unzip unrar
        #cpio lha lzop unace
    )
    # [note]
    # http://stackoverflow.com/questions/6426142/how-to-append-a-string-to-each-element-of-a-bash-array
    # array=( "${array[@]/%/_suffix}" )
    # will append the '_suffix' string to each element.
    # array=( "${array[@]/#/prefix_}" )
    # will prepend 'prefix_' string to each element
    mingw_packages=( "${mingw_packages[@]/#/mingw-w64-${MSYSTEM_CARCH}-}" )
    package_list=("${mingw_packages[@]}" "${msys_packages[@]}")
    perform pacman -S --noconfirm --needed --quiet $(join_by ' ' "${package_list[@]}")
    echo " -- install packages done"
}

action= #echo
perform() {
    if [[ -z "${action}" ]]; then
        "$@"
    else
        ${action} "$@"
    fi
}

install() {
    install_packages
    local arch
    local dir
    case $MSYSTEM_CARCH in
        i686)
            dir=/mingw32/bin
            ;;
        x86_64|*)
            dir=/mingw64/bin
            ;;
    esac
}

test() {
    action=echo
    install
}

main() {
    if [[ $# == 0 ]]; then
        install
    else
        echo " -- $@"
        "$@"
        echo " -- $@ done"
    fi
}

main "$@"
