
command_entry() {
    local layers=("${@}")
    archer_core_require archer/layer
    if archer_layer_load_pwd_user_config
    then
        archer_layer_force_install_layers layers
    fi
}
