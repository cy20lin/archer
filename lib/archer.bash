#!/bin/bash

archer() {
    source "$( dirname "${BASH_SOURCE[0]}" )/../lib/archer/core.bash"
    archer_core_require archer/command
    archer_command "${@}"
}

test "${BASH_SOURCE[0]}" = "${0}" && archer "${@}"
