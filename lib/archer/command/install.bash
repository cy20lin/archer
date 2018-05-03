
command_entry() {
    local layers=("${@}")
    archer_core_require archer/layer
    archer_layer_install_layers_with_dependencies layers
}
