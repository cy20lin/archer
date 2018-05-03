#!/bin/bash

archer() {
    source "$( dirname "${BASH_SOURCE[0]}" )/../lib/archer/core.bash"
    archer_core_require archer/command
    archer_core_require archer/layer
    archer_core_require archer/dotarcher
    archer_dotarcher_init "${@}"
    archer_command "${@}"
}

test "${BASH_SOURCE[0]}" = "${0}" && archer "${@}"
