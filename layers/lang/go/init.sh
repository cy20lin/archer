#!/usr/bin/bash
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
##

# function join_by()
#   http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
# for example
#   join_by , a b c #a,b,c
#   join_by ' , ' a b c #a , b , c
#   join_by ')|(' a b c #a)|(b)|(c
#   join_by ' %s ' a b c #a %s b %s c
#   join_by $'\n' a b c #a<newline>b<newline>c
#   join_by - a b c #a-b-c
#   join_by '\' a b c #a\b\c
#   join_by , a "b c" d #a,b c,d
#   join_by / var local tmp #var/local/tmp
#   FOO=( a b c )
#   join_by , "${FOO[@]}" #a,b,c

join_by() {
  local d=$1
  shift
  echo -n "$1"
  shift
  printf "%s" "${@/#/$d}"
}

create_alias_script() {
    local shell=/usr/bin/bash
    local file
    local command

    case $# in
        2)
            file="$1"
            command="$2"
            ;;
        3)
            shell="$1"
            file="$2"
            command="$3"
            ;;
    esac
    echo "#!${shell}" >  "${file}"
    echo "#"          >> "${file}"
    echo "${command} \"\$@\""     >> "${file}"
}

action= #echo
perform() {
    if [[ -z "${action}" ]]; then
        "$@"
    else
        ${action} "$@"
    fi
}

set_gopath() {
    export GOPATH="${MSYSTEM_PREFIX}/lib/go"
    goexport=$(cat /etc/exports | grep "export GOPATH=")
    test ! -z "${goexport}" && return
    echo ' -- export GOPATH="${MSYSTEM_PREFIX}/lib/go/bin"' # >>/etc/exports
    echo 'export GOPATH="${MSYSTEM_PREFIX}/lib/go/bin"' >>/etc/exports
}

set_goroot() {
    export GOROOT="${MSYSTEM_PREFIX}/bin/go"
    goexport=$(cat /etc/exports | grep "export GOROOT=")
    test ! -z "${goexport}" && return
    echo ' -- export GOROOT="${MSYSTEM_PREFIX}/lib/go"' # >>/etc/exports
    echo 'export GOROOT="${MSYSTEM_PREFIX}/lib/go"' >>/etc/exports
}

set_path() {
    pathexport=$(cat /etc/exports | grep 'export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"')
    test ! -z "${pathexport}" && return
    export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"
    echo ' -- export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"'
    echo 'export PATH="${GOPATH}/bin:${GOROOT}/bin:${PATH}"' >>/etc/exports
}

install_packages() {
    echo " -- install basic packages"
    local mingw_packages=(
        go
    )
    local msys_packages=(
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
    set_gopath
    set_goroot
    set_path
}

_install() {
    install_packages
}

_test() {
    action=echo
    install
}

main() {
    if [[ $# == 0 ]]; then
        _install
    else
 	      echo " -- $@"
        _install
 	      echo " -- $@ done"
    fi
}

main "$@"
