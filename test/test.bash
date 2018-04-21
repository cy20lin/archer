
source ./lib/archer/core.bash
source ./lib/archer/map.bash 
# archer_core_require archer/core && echo t || echo f
# archer_core_require archer/core && echo t || echo f
# archer_core_require archer/core && echo t || echo f
# archer_core_require archer/core && echo t || echo f
archer_core_require archer/algorithm && echo t || echo f
archer_core_require archer/layer && echo t-layer || echo f-layer
# archer_core_require archer/map && echo t || echo f
# archer_core_require archer/map && echo t || echo f
# archer_core_require archer/array && echo t || echo f

test_vertex_getter() {
    if test "${1}" -lt 0 -o "${1}" -gt 4
    then
        return 1
    fi
    local v=(v0 v1 v2 v3 v4)
    local v0=(1)
    local v1=(2 4)
    local v2=(3)
    local v3=(0)
    local v4=(3)
    # echo eval "${2}"='("${v'"${1}"'[@]}")'
    eval "${2}"='("${v'"${1}"'[@]}")'
}

# # test_vertex_getter 3 out
# # echo "${out[@]}"
# # echo 'x=1' | source '/dev/stdin'
# # echo x=$x
# archer_map_init m
# # archer_map_static_default_hash "lang/c-c++" out
# archer_map_var_at m "ss  ss" v
# # echo var=$v
# archer_map_hash m "ss  ss" v
# # echo var=$v
# archer_map_static_hash_default "c " x
# # echo hash=$x
# archer_map_hash m "lang/c-c++" out
# # echo $out
# archer_map_insert m "a" x
# # echo .
# archer_map_insert m "a" y
# # echo .
# archer_map_insert m "a" z
# # echo .
# archer_map_insert m "b" y
# # echo .
# archer_map_insert m "c " z
# # echo .
# archer_map_at m "a" x
# # echo value at c =$x
# # echo xxxxxxxxxxxxx
# # echo m_keys=$m_keys
# archer_map_keys m keys
# # archer_map_at m a x
# # echo out=$out
# # echo keys=${keys[@]}
# a=(1 0)
# # archer_algorithm_topo_sort 0 test_vertex_getter sorted cycled
# archer_algorithm_topo_sort_vertexs a test_vertex_getter sorted cycled

# echo "${sorted[@]}"
# for vertex in "${sorted[@]}"
# do
#     if archer_map_has_key cycled "${vertex}"
#     then
#         archer_map_var_at cycled "${vertex}" var
#         eval arr='("${'"${var}"'[@]}")'
#         echo visit vertex: $vertex, with cycled parents: "${arr[@]}"
#     else
#         echo visit vertex: $vertex
#     fi
# done

# archer_map_fini m
echo ${ARCHER_LAYER_DIR}
archer_layer_exists lang/c-c++
echo exists $?

archer_layer_dependencies app/cy20lin-spacemacs deps
echo result=$?
echo deps:"${deps[@]}"

layers=(app/cy20lin-spacemacs)
archer_layer_setup_layers_with_dependencies layers
