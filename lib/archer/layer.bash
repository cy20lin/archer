if test ! -z "${ARCHER_LAYER_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_LAYER_BASH_REQUIRED=1

archer_core_require archer/core
archer_core_require archer/algorithm
archer_core_require archer/map

ARCHER_LAYER_DIR="${ARCHER_CORE_PWD}/.archer.d/layer"
ARCHER_LAYER_DEFAULT_PREFIX=
# ARCHER_LAYER_PREFIX=
# ARCHER_LAYER_DIR="${ARCHER_CORE_PREFIX_DIR}/etc/archer/layer"

archer_layer_is_absolute() {
    case "${1}" in
        /*) return 0 ;;
    esac
    return 1
}

archer_layer_to_absolute() {
    if ! archer_layer_is_absolute "${1}"
    then
        eval "${2}"='"${ARCHER_LAYER_PREFIX}/${1}"'
    else
        eval "${2}"='"${1}"'
    fi
    # TODO enhance normalization process
    # to resolve relative path with double dot
    # we has to remove it parent dir exclude it name is '.' or '..'
    # but sed doesn't has negative lookahead,
    # so we select the pattern manually
    # for one char string: [^/.]
    # for two char string: [^/.]\. or \.[^/.]
    # for multiple char string: [^/.][^/.][^/]*
    eval "${2}"='"$( sed " :remove-extra-slash s@//*@/@g ;
    :resolve-double-dot s@/\([^/.]\|\.[^/.]\|[^/.]\.\|[^/.][^/.][^/]*\)/\.\.\(/\|$\)@/@ ; t resolve-double-dot ;
    :resolve-single-dot s@/.\(/\|$\)@\1@g ;
    " <<< "${'"${2}"'}" )"'
    # eval '${2}"=$( sed "s@/[^/]*/\.\.\(/\|$\)@\1@g" <<< "${'"${2}"'}" )"'
}

archer_layer_dependencies() {
    # @param
    # 1. [in] (string) layer
    # 2. [out] (array) dependencies
    #
    if test -z "${2}" || archer_layer_load "${1}"
    then
        if test "$( type -t layer_metadata )" = "function" && layer_metadata
        then
            eval "${2}"='("${LAYER_DEPENDENCIES[@]}")'
            return 0
        else
            echo eval "${2}"='()'
            eval "${2}"='()'
        fi
    fi
    return 1
}

archer_layer_normalized_dependencies() {
    # 1. [in] (string) layer
    # 2. [out] (array) dependencies
    archer_layer_dependencies "${1}" "${2}"
    archer_layer_normalize_layers "${2}"
}

archer_layer_exists() {
    # @param
    # $1.layer:
    # @result
    local __layer=
    archer_layer_to_absolute "${1}" __layer
    if test ! -z "${2}"
    then
        eval "${2}"='"${ARCHER_LAYER_DIR}${__layer}"'
    fi
    test -f "${ARCHER_LAYER_DIR}${__layer}/layer.bash"
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

archer_layer_normalize_layers() {
    eval __layers_='("${'"${1}"'[@]}")'
    eval "${1}"='()'
    for __layer in "${__layers_[@]}"
    do
        if archer_layer_to_absolute "${__layer}" __layer
        then
            eval "${1}"+='("${__layer}")'
        fi
    done
}

archer_layer_load() {
    local __layer="${1}"
    local __script=
    if ! archer_layer_exists "${__layer}" __script
    then
        return 1
    fi
    source "${__script}/layer.bash"
}

archer_layer_unload() {
    unset -f layer_help
    unset -f layer_metadata
    unset -f layer_install
    unset -f layer_run
    unset -f layer_is_installed
}

archer_layer_install() {
    if archer_layer_load "${1}"
    then
        if test "$( type -t layer_is_installed )" = "function" && layer_is_installed
        then
            archer_core_info "layer ${1} already installed, skipping"
            archer_layer_unload "${1}"
            return 0
        else
            archer_core_info "install layer: ${__layer}"
            if test "$( type -t layer_install )" = "function" && layer_install
            then
                archer_core_info "layer ${1} installed successfully"
                archer_layer_unload "${1}"
                return 0
            else
                archer_core_info "layer ${1} installed failed"
                archer_layer_unload "${1}"
                return 1
            fi
        fi
    else
        archer_core_warning "cannot find layer: \"${__layer}\""
        return 1
    fi
}

archer_layer_run() {
    if archer_layer_load "${1}"
    then
        if test "$( type -t layer_run )" = "function"
        then
            shift
            layer_run "${@}"
        fi
    else
        archer_core_warning "cannot find layer: \"${__layer}\""
        return 1
    fi
}

archer_layer_install_layers() {
    local __layers_var="${1}"
    local __layers=()
    eval __layers='("${'"${__layers_var}"'[@]}")'
    for __layer in "${__layers[@]}"
    do
        archer_layer_install "${__layer}"
    done
}

archer_layer_force_install() {
    if archer_layer_load "${1}"
    then
        if test "$( type -t layer_is_installed )" = "function" && layer_is_installed
        then
            archer_core_info "layer ${1} already installed, but install forcefully"
        fi
        archer_core_info "install layer: ${1}"
        if test "$( type -t layer_install )" = "function" && layer_install
        then
            archer_core_info "layer ${1} installed successfully"
            archer_layer_unload "${1}"
            return 0
        else
            archer_core_info "layer ${1} installed failed"
            archer_layer_unload "${1}"
            return 1
        fi
    else
        return 1
    fi
}

archer_layer_force_install_layers() {
    local __layers_var="${1}"
    local __layers=()
    eval __layers='("${'"${__layers_var}"'[@]}")'
    for __layer in "${__layers[@]}"
    do
        archer_layer_force_install "${__layer}"
    done
}

archer_layer_install_layers_with_dependencies() {
    local __layers_var="${1}"
    local __layers=()
    local __sorted_=()
    local __cycled_=
    eval __layers='("${'"${__layers_var}"'[@]}")'
    archer_layer_normalize_layers __layers
    archer_core_info "resolving layer dependencies, layers: [${__layers[@]}]"
    archer_algorithm_topo_sort_vertexs __layers archer_layer_normalized_dependencies __sorted_ __cycled_ archer_layer__exists_with_info
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
    archer_layer_install_layers __sorted_
}

archer_layer_force_install_layers_with_dependencies() {
    local __layers_var="${1}"
    local __layers=()
    local __sorted_=()
    local __cycled_=
    eval __layers='("${'"${__layers_var}"'[@]}")'
    archer_layer_normalize_layers __layers
    archer_core_info "resolving layer dependencies, layers: [${__layers[@]}]"
    archer_algorithm_topo_sort_vertexs __layers archer_layer_normalized_dependencies __sorted_ __cycled_ archer_layer__exists_with_info
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
    archer_layer_force_install_layers __sorted_
}
