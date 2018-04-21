if test ! -z "${ARCHER_ALGORITHM_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_ALGORITHM_BASH_REQUIRED=true

archer_core_require archer/map

archer_algorithm_topo_sort() {
    # archer_algorithm_topo_sort begin_vertex getter sorted detected_cycled_vertexs
    # 1. vertex_value
    # 2. sub_vertexs_getter
    # 3. sorted_vertexs_array
    # 4. [opt] detected_cycled_vertexs_map_var
    local __is_sorting=
    local __is_sorted=
    local __sorted="${3}"
    local __detected_cycled_vertexs=()
    local __detected_cycled_vertexs_map="${4}"
    local __deps=()
    local __var=
    local __vertex_getter="${2}"
    archer_map_init __is_sorting_map
    archer_map_init __is_sorted_map
    archer_algorithm_topo_sort__impl "${1}"
    archer_map_fini __is_sorting_map
    archer_map_fini __is_sorted_map
}

archer_algorithm_topo_sort_vertexs() {
    # archer_algorithm_topo_sort begin_vertex getter sorted detected_cycled_vertexs
    # 1. vertexs_array_var
    # 2. sub_vertexs_getter
    # 3. sorted_vertexs_array
    # 4. [opt] detected_cycled_vertexs_map_var
    local __is_sorting=
    local __is_sorted=
    local __sorted="${3}"
    local __detected_cycled_vertexs=()
    local __detected_cycled_vertexs_map="${4}"
    local __deps=()
    eval __deps='("${'"${1}"'[@]}")'
    local __var=
    local __is_vertex_valid="${5-true}"
    local __vertex_getter="${2}"
    archer_map_init __is_sorting_map
    archer_map_init __is_sorted_map
    for __sub_vertex in "${__deps[@]}"
    do
        archer_algorithm_topo_sort__impl "${__sub_vertex}"
    done
    archer_map_fini __is_sorting_map
    archer_map_fini __is_sorted_map
}

archer_algorithm_topo_sort__impl() {
    # if this layer is resolving
    if ! eval "${__is_vertex_valid}" "${1}"
    then
        return
    fi
    archer_map_at __is_sorting_map "${1}" __is_sorting
    if test "${__is_sorting}" = true
    then
         __detected_cycled_vertexs+=("${1}")
        return
    fi
    # if this layer is resolved
    archer_map_at __is_sorted_map "${1}" __is_sorted
    if test "${__is_sorted}" = true
    then
        return
    fi
    # mark this layer to be in resolving state
    archer_map_insert_or_assign __is_sorting_map "${1}" true
    eval "${__vertex_getter}" "${1}" __deps
    # for each dependent layer of this layer
    for __sub_vertex in "${__deps[@]}"
    do
        archer_algorithm_topo_sort__impl "${__sub_vertex}"
    done
    # update result
    eval "${__sorted}"+='("${1}")'
    if test ! -z "${__detected_cycled_vertexs_map}" -a "${#__detected_cycled_vertexs}" -gt 0
    then
        archer_map_var_at "${__detected_cycled_vertexs_map}" "${1}" __var
        eval "${__var}"='("${__detected_cycled_vertexs[@]}")'
    fi
    __detected_cycled_vertexs=()
    # unmark this layer
    archer_map_insert_or_assign __is_sorting_map "${1}" ""
    archer_map_insert_or_assign __is_sorted_map "${1}" true
}
