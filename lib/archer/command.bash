
archer_command() {
    local ARCHER_COMMAND="${1}"
    shift
    local ARGV=("${@}")
    if archer_core_require "archer/command/${ARCHER_COMMAND[@]}"
    then
        command_entry "${ARGV[@]}"
    else
        archer_core_require archer/command/help && command_entry "${ARGV[@]}"
    fi
}
