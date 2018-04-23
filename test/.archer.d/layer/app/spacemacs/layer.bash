
layer_help() {
    true
}

layer_metadata() {
    LAYER_DEPENDENCIES=(
        app/emacs
        app/git
        lang/c-c++
        lang/javascript
        lang/python
    )
}

layer_is_installed() {
    false
}

layer_install() {
    echo "install spacemacs"
    true
}

