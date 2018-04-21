if test ! -z "${ARCHER_LAYER_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_LAYER_BASH_REQUIRED=1

archer_core_require archer/core
archer_core_require archer/algorithm
archer_core_require archer/map

ARCHER_LAYER_DIR="${ARCHER_CORE_PREFIX_DIR}/etc/archer/layer"

archer_layer_dependencies() {
    # @param
    # 1. [in] (string) layer
    # 2. [out] (array) dependencies
    local __layer="${1}"
    local __deps_var="${2}"
    local __deps_script="${ARCHER_LAYER_DIR}/${__layer}/metadata.bash"
    #
    if ! archer_layer_exists "${__layer}" || test -z "${__deps_var}"
    then
        return 1
    fi
    local LAYER=
    local LAYER_DEPENDENCIES=()
    if test -f "${__deps_script}"
    then
        source "${__deps_script}"
    fi
    eval "${__deps_var}"='("${LAYER_DEPENDENCIES[@]}")'
}

archer_layer_exists() {
    # @param
    # $1.layer:
    # @result
    local __layer="${1}"
    if test ! -z "${2}"
    then
        eval "${2}"='"${ARCHER_LAYER_DIR}/${__layer}/main.bash"'
    fi
    test -f "${ARCHER_LAYER_DIR}/${__layer}/main.bash"
}

archer_layer_setup() {
    local __layer="${1}"
    local __script=
    if ! archer_layer_exists "${__layer}" __script
    then
        archer_core_warning "cannot find layer: \"${__layer}\""
        return 1
    fi
    archer_core_info "setup layer: ${__layer}"
    source "${__script}"
}

archer_layer_setup_layers() {
    local __layers_var="${1}"
    local __layers=()
    eval __layers='("${'"${__layers_var}"'[@]}")'
    for __layer in "${__layers[@]}"
    do
        archer_layer_setup "${__layer}"
    done
}
archer_layer__exists_with_info() {
    if archer_layer_exists "${@}"
    then
        return 0
    else
        archer_core_warning "cannot find layer: \"${1}\", ignoring"
        return 1
    fi
}

archer_layer_setup_layers_with_dependencies() {
    local __layers_var="${1}"
    local __layers=()
    local __sorted_=()
    local __cycled_=
    eval __layers='("${'"${__layers_var}"'[@]}")'
    archer_core_info "resolving layer dependencies, layers: [${__layers[@]}]"
    archer_algorithm_topo_sort_vertexs __layers archer_layer_dependencies __sorted_ __cycled_ archer_layer__exists_with_info
    for __layer in "${__sorted_[@]}"
    do
        if archer_map_has_key __cycled_ "${__layer}"
        then
            archer_map_var_at __cycled_ "${__layer}" var
            eval arr='("${'"${var}"'[@]}")'
            archer_core_warning "cyclic depencencies detected, layer ${__layer} will be install before dependent layers (${arr[@]})"
        fi
        archer_core_info "resolved layer: ${__layer}"
    done
    archer_core_info "dependencies resolved" # "with sorted layers [${__sorted_[@]}]."
    archer_layer_setup_layers __sorted_

}
