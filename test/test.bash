#!/bin/bash
if test ! -z "${BASH_SOURCE[0]}"
then
    file="${BASH_SOURCE[0]}"
else
    file="${0}"
fi
dir="$( dirname "${file}" )"
dir="$( cd "${dir}" && pwd )"
pushd "${dir}" >/dev/null
bash "${dir}/../bin/archer" setup app/cy20lin-spacemacs /app///emacs
result=$?
popd >/dev/null
exit $result

