if test ! -z "${ARCHER_ARRAY_BASH_REQUIRED}"
then
    return 1
fi
ARCHER_ARRAY_BASH_REQUIRED=1

archer_array_remove() {
    local __array="${1}"
    local __value="${2}"
    local __indics=
    eval __indics='("${!'"${__array}"'[@]}")'
    for i in "${__indics[@]}"
    do
        if eval test '"${'"${__array}[${i}]"'}"' = '"${__value}"'
        then
            unset -v "${__array}[${i}]"
        fi
    done
}
