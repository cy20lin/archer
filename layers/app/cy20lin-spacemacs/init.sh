#!/usr/bin/bash
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
##

install() {
    pacman -S --needed --quiet --noconfirm \
            mingw-w64-${MSYSTEM_CARCH}-emacs \
            mingw-w64-${MSYSTEM_CARCH}-xpm-nox
    pacman -S --needed --quiet --noconfirm emacs
    test ! -e ~/.emacs.d && git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
    test ! -e ~/.spacemacs.d && git clone https://github.com/cy20lin/.spacemacs.d ~/.spacemacs.d
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
