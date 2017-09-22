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
  # if [[ -n "${MSYSTEM}" && -n "${MSYSTEM_CARCH}" ]]; then
    pacman -S --needed --quiet --noconfirm \
      mingw-w64-${MSYSTEM_CARCH}-emacs \
      mingw-w64-${MSYSTEM_CARCH}-xpm-nox
  # else
  	pacman -S --needed --quiet --noconfirm emacs
  # fi
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
  # create_alias_script /usr/bin/emacs "${dir}/emacs"
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
