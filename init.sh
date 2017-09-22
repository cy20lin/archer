#!/usr/bin/bash
##
## Copyright (c) 2017 ChienYu Lin
##
## Author: ChienYu Lin <cy20lin@gmail.com>
##

SOURCE="${BASH_SOURCE[0]}"
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-which-directory-it-is-stored-in/246128#246128
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

print_help() {
	echo ""
	echo "./bootstrap/init.sh <option> <args>..."
	echo ""
	echo "options:"
	echo "  --help                 this help content."
	echo "  install <package>...   install packages."
	echo ""
	echo "examples:"
  echo "  ./bootstrap/init.sh install msys2 app/emacs app/spacemacs lang/c-c++"
	echo ""
}

main() {
    pushd $SCRIPT_DIR > /dev/null
    local cmds=
    case "$1" in
        install)
            shift
            dirs=("$@")
            for dir in "${dirs[@]}"
            do
                echo " -- bootstrap ${dir}"
                # dir="./$(sed 's#\.#\/#g' <<< $dir )/init.sh install"
                dir="./layers/${dir}"
                pushd "${dir}" >/dev/null
                bash "./init.sh" install
                popd >/dev/null
            done
        ;;
        test)
            shift
            dirs=("$@")
            for dir in "${dirs[@]}"
            do
                # dir="./$(sed 's#\.#\/#g' <<< $dir )/init.sh test"
                dir="./layers/${dir}"
                pushd "${dir}" >/dev/null
                bash "./init.sh" install
                popd >/dev/null
            done
        ;;
        *)
        print_help
        ;;
    esac
    popd > /dev/null
}

main "$@"

