#!/bin/bash

archer_help() {
	  echo ""
	  echo "archer <command> <args>..."
	  echo ""
	  echo "command:"
	  echo "  help                   this help content."
	  echo "  setup     <layers>...  setup layers."
	  echo "  raw-setup <layers>...  setup layers."
	  echo ""
	  echo "examples:"
    echo "  archer setup app/emacs app/spacemacs lang/c-c++"
	  echo ""
}

archer_setup() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_setup_layers_with_dependencies layers
    fi
}

archer_raw_setup() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_setup_layers_with_dependencies layers
    fi
}

archer() {
    source "$( dirname "${BASH_SOURCE[0]}" )/../lib/archer/core.bash"
    local cmds=
    local cmd="${1}"
    shift
    case "${cmd}" in
        setup) archer_setup "${@}";;
        raw-setup) archer_raw_setup "${@}" ;;
        *) archer_help "${@}" ;;
    esac
}

test "${BASH_SOURCE[0]}" = "${0}" && archer "${@}"
