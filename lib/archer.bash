#!/bin/bash

archer_help() {
	  echo ""
	  echo "archer <command> <args>..."
	  echo ""
	  echo "command:"
	  echo "  help                           this help content."
	  echo "  install           <layers>...  install layers and their dependencies."
	  echo ""
	  echo "command (experimental):"
	  echo "  raw-install       <layers>...  install layers without dependencies."
	  echo "  force-install     <layers>...  install layers and dependencies even if already installed."
	  echo "  raw-force-install <layers>...  install layers even if already installed."
	  echo ""
	  echo "examples:"
    echo "  archer install app/emacs app/spacemacs lang/c-c++"
    echo "  archer install /ubuntu/app/emacs lang/c-c++"
	  echo ""
}

archer_install() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_install_layers_with_dependencies layers
    fi
}

archer_force_install() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_force_install_layers_with_dependencies layers
    fi
}

archer_raw_install() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_install_layers layers
    fi
}

archer_raw_force_install() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_force_install_layers layers
    fi
}

archer() {
    source "$( dirname "${BASH_SOURCE[0]}" )/../lib/archer/core.bash"
    local cmds=
    local cmd="${1}"
    shift
    case "${cmd}" in
        install) archer_install "${@}";;
        force-install) archer_force_install "${@}";;
        raw-install) archer_raw_install "${@}" ;;
        force-raw-install) archer_force_raw_install "${@}" ;;
        *) archer_help "${@}" ;;
    esac
}

test "${BASH_SOURCE[0]}" = "${0}" && archer "${@}"
