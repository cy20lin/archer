#!/usr/bin/bash
##
## Copyright (c) 2016-2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
## Since: 2016.10.17
##

# References:
# + http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in/246128#246128
# + http://stackoverflow.com/questions/1527049/bash-join-elements-of-an-array
# + http://unix.stackexchange.com/questions/124081/why-isnt-there-any-shell-command-to-create-files
# + http://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable
# + http://stackoverflow.com/questions/4676459/write-to-file-but-overwrite-it-if-it-exists
# + http://unix.stackexchange.com/questions/209653/read-multiple-lines-from-text-files-in-bash
# + http://unix.stackexchange.com/questions/99068/read-a-variable-with-read-and-preserve-backslashes-entered-by-the-user

SOURCE="${BASH_SOURCE[0]}"
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in/246128#246128
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

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

comment() {
    local prefix="$1"
    local comment_="$2"

}
uncomment() {
    :
}

action= #echo
perform() {
    if [[ -z "${action}" ]]; then
        "$@"
    else
        ${action} "$@"
    fi
}


append_if_not_exist() {
    local file="$1"
    local fixed_string="$2"
    grep -q -F "${fixed_string}" "${file}" || echo "${fixed_string}" >> "${file}"
}

create_devdir() {
    local prefix=$1
    test "$#" -ne 1 && return 1
    test "${prefix}" == ""  && return 1
    mkdir -p "${prefix}"
    mkdir -p "${prefix}/bin"
    mkdir -p "${prefix}/lib"
    mkdir -p "${prefix}/include"
    mkdir -p "${prefix}/doc"
    mkdir -p "${prefix}/src"
    mkdir -p "${prefix}/share"
}


create_local_dirs() {
    echo " -- create local dir in '/usr', '/mingw32', '/mingw64'"
    create_devdir /usr/local/
    create_devdir /mingw32/local/
    create_devdir /mingw64/local/
    create_devdir ~/usr/
    create_devdir ~/mingw32/
    create_devdir ~/mingw64/
    create_devdir ~/usr/local/
    create_devdir ~/mingw32/local/
    create_devdir ~/mingw64/local/
}

enable_native_symlink() {
    echo " -- enable native symlink"
    sed -i -e 's#^rem \(set MSYS=winsymlinks:nativestrict\)#\1#' "/msys2_shell.cmd"
    local config_files=(\
                        msys2.ini\
                            mingw32.ini\
                            mingw64.ini\
        )
    for file in "${config_files[@]}"
    do
        sed -i -e 's@^#\(MSYS=winsymlinks:nativestrict\)@\1@' "/${file}"
    done
}

disable_native_symlink() {
    echo " -- disable native symlink"
    sed -i -e 's#^\(set MSYS=winsymlinks:nativestrict\)#rem \1#' "/msys2_shell.cmd"
    local config_files=(
        msys2.ini\
            mingw32.ini\
            mingw64.ini\
            )
    for file in "${config_files[@]}"
    do
        sed -i -e 's@^\(MSYS=winsymlinks:nativestrict\)@#\1@' "/${file}"
    done

}

patch_etc_profile() {
    echo " -- patch /etc/profile, set additional path of \'local\' dirs"
    perform cp -f "${SCRIPT_DIR}/etc/profile" "/etc/profile"
}

set_default_locale_of_profile() {
    sed -i -e 's@\(export LANG=$(locale -uU)\)@#\1@' "/etc/skel/.profile"
    test -f ~/.profile && sed -i -e 's@\(export LANG=$(locale -uU)\)@#\1@' "~/.profile"
}

create_etc_exports() {
    #export LC_ALL=en_US.utf8
    #while read -r env; do export "$env"; done
    # using English for bash environment
    echo " -- create /etc/exports"
    > /etc/exports
    echo 'export LANG=en_US.utf8' >> /etc/exports
}

create_etc_aliases() {
    echo " -- create /etc/aliases"
    > /etc/aliases
    echo 'alias cc=gcc' >> /etc/aliases
}

reload_profiles() {
    # reference:
    # http://www.thegeekstuff.com/2008/10/execution-sequence-for-bash_profile-bashrc-bash_login-profile-and-bash_logout/
    # https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
    # http://unix.stackexchange.com/questions/22721/completely-restart-bash
    # restart bash
    echo " -- reload profiles, refresh your environment with following commands "
    if test -f /etc/profile ; then
       echo " --   source /etc/profile"
       source /etc/profile
    fi
    if [[ -f ~/.bash_profile ]]; then
        echo " --   source ~/.bash_profile"
        source ~/.bash_profile
    elif [[ -f ~/.bash_login ]]; then
        echo " --   source ~/.bash_login"
        source ~/.bash_login
    elif [[ -f ~/.profile ]]; then
        echo " --   source ~/.profile"
        source ~/.profile
    fi
}

set_local() {
    true
}

main() {
    test "$1" == "test" && action=echo
    perform pacman -Sy #< refresh package database
    enable_native_symlink
    #disable_native_symlink
    create_local_dirs
    create_etc_aliases
    create_etc_exports
    patch_etc_profile
    reload_profiles
    # install_packages
}

main "$@"
