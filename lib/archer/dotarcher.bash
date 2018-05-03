
archer_dotarcher__init_with_dir() {
    if test ! -z "${1}" -a -f "${1}/init.bash"
    then
        # archer_core_info "loading user config file"
        if source "${1}/init.bash"
        then
            # archer_core_info "user config file loaded"
            true
        else
            archer_core_error "user config file loading failure"
            return 1
        fi
    else
        archer_core_error "user config file .archer.d/init.bash not found"
        return 1
    fi
    shift
    if test "$( type -t dotarcher_init )" = "function"
    then
        # archer_core_info "dotarcher_init loading"
        shift
        if dotarcher_init "${@}"
        then
            # archer_core_info "dotarcher_init loaded"
            return 0
        else
            archer_core_error "dotarcher_init loaded failure"
            return 1
        fi
    else
        archer_core_error "function dotarcher_init not found in user config file .archer.d/init.bash"
        return 1
    fi
}

archer_dotarcher_init() {
    if archer_dotarcher__init_with_dir "${ARCHER_CORE_DOTARCHER_DIR}" "${@}"
    then
        return 0
    else
        return 1
    fi
}
