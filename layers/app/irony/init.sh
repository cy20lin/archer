#!/usr/bin/bash
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
##

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

install() {
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

    tmpdir="${TMPDIR}"
    test -z "${tmpdir}" && tmpdir="${TMP}"
    test -z "${tmpdir}" && return
    ironydir=$(mktemp -d "${tmpdir}/irony-XXXXXXX")
    test -z "${ironydir}" && return
    git clone --depth=1 https://github.com/Sarcasm/irony-mode "${ironydir}"
    pushd "${ironydir}/server"
    cmake -Bbuild -H. -GUnix\ Makefiles "-DCMAKE_INSTALL_PREFIX=${MSYSTEM_PREFIX}/local"
    cmake --build ./build --config Release --target all
    cmake --build build --config Release --target install
    popd
    rm -rf "${ironydir}"
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

main
