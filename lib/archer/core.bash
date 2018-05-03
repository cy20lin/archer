if test ! -z "${ARCHER_CORE_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_CORE_BASH_REQUIRED=1
ARCHER_CORE_PREFIX_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
ARCHER_CORE_PWD="${PWD}"
ARCHER_CORE_DOTARCHER_DIR="${PWD}/.archer.d"

archer_core_require__with_dir() {
    # local __module="${1}"
    # local __file="${2}/lib/${__module}.bash"
    if test -f "${2}/lib/${1}.bash"
    then
        source "${2}/lib/${1}.bash"
        return 0
    else
        return 1
    fi
}

archer_core_require() {
    archer_core_require__with_dir "${1}" "${ARCHER_CORE_PREFIX_DIR}" \
     || archer_core_require__with_dir "${1}" "${ARCHER_CORE_DOTARCHER_DIR}"
}

archer_core_print() {
    echo "${@}"
}

archer_core_info() {
    test ARCHER_DEBUG && echo "[archer][info]" "${@}" 1>&2
}

archer_core_warning() {
    echo "[archer][warning]" "${@}" 1>&2
}

archer_core_error() {
    echo "[archer][error]" "${@}" 1>&2
}
