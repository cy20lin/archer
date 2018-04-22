if test ! -z "${ARCHER_CORE_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_CORE_BASH_REQUIRED=1
ARCHER_CORE_PREFIX_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
ARCHER_CORE_PWD="${PWD}"

archer_core_require() {
    local __module="${1}"
    local __file="${ARCHER_CORE_PREFIX_DIR}/lib/${__module}.bash"
    if test -f "${__file}"
    then
        source "${__file}"
    else
        return 1
    fi
}

archer_core_print() {
    echo "${@}"
}

archer_core_info() {
    echo "[info]" "${@}"
}

archer_core_warning() {
    echo "[warning]" "${@}"
}

archer_core_error() {
    echo "[error]" "${@}"
}
