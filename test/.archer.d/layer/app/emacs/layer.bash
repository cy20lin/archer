
layer_help() {
    true
}

layer_metadata() {
    LAYER_DEPENDENCIES=(
    )
}

layer_is_installed() {
    false
}

layer_install() {
    archer_core_print "install emacs"
    true
}

